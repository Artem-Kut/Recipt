//
//  ReceiptService.swift
//  MyReceipt
//
//  Created by Artem Kutasevych on 6/10/24.
//

import Foundation
import Combine

protocol ReceiptServiceProtocol {
    func getReceipts() -> AnyPublisher<Receipts, Error>
    func getReceipt(with id: String) -> AnyPublisher<ReceiptDescription, Error>
}

class ReceiptService: ReceiptServiceProtocol {
    let apiClient = URLSessionAPIClient<ReceiptEndpoint>()
    func getReceipts() -> AnyPublisher<Receipts, Error> {
        return apiClient.request(.getMeals(filter: "Dessert"))
    }
    func getReceipt(with id: String) -> AnyPublisher<ReceiptDescription, Error> {
        return apiClient.request(.getMeal(id: id))
    }
}

struct Receipts: Codable {
    let meals: [Receipt]
}

struct Receipt: Codable, Identifiable {
    let name: String
    let urlImage: String
    let id: String
    private enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case urlImage = "strMealThumb"
        case id = "idMeal"
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.urlImage = try container.decode(String.self, forKey: .urlImage).replacingOccurrences(of: "\\", with: "")
        self.id = try container.decode(String.self, forKey: .id)
    }
}

struct ReceiptDescription: Codable {
    let receipt: Receipt
    let ingredients: [String: String]
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.receipt = try container.decode(Receipt.self, forKey: .receipt)
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var tempIngredients = [String: String]()
        let allKeys = dynamicContainer.allKeys.sorted(by: { $0.stringValue < $1.stringValue })
        for key in allKeys {
            guard let stringKey = DynamicCodingKeys(stringValue: key.stringValue),
                  stringKey.stringValue.contains("strIngredient") else {
                continue
            }
            let ingredient = try dynamicContainer.decode(String.self, forKey: stringKey)
            let number = stringKey.stringValue.replacingOccurrences(of: "strIngredient", with: "")
            guard let measureKey = DynamicCodingKeys(stringValue: "strMeasure" + number) else {
                tempIngredients[ingredient] = ""
                continue
            }
            let measure = try dynamicContainer.decode(String.self, forKey: measureKey)
            tempIngredients[ingredient] = measure
        }
        self.ingredients = tempIngredients
    }
}
