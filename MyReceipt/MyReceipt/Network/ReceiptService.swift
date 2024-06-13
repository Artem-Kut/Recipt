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
    func getReceipt(with id: String) -> AnyPublisher<ReceiptDescriptions, Error>
}

class ReceiptService: ReceiptServiceProtocol {
    let apiClient = URLSessionAPIClient<ReceiptEndpoint>()
    func getReceipts() -> AnyPublisher<Receipts, Error> {
        return apiClient.request(.getMeals(filter: "Dessert"))
    }
    func getReceipt(with id: String) -> AnyPublisher<ReceiptDescriptions, Error> {
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
        self.urlImage = try container.decode(String.self, forKey: .urlImage)
        self.id = try container.decode(String.self, forKey: .id)
    }
    init(name: String, urlImage: String, id: String) {
        self.name = name
        self.urlImage = urlImage
        self.id = id
    }
}

struct ReceiptDescriptions: Codable {
    let meals: [ReceiptDescription]
}

struct Ingredient: Identifiable, Codable {
    var id = UUID()
    let ingredient: String
    let measure: String
}

struct ReceiptDescription: Codable {
    let receipt: Receipt
    let ingredients: [Ingredient]
    let instructions: String
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
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var tempIngredients = [Ingredient]()
        let allKeys = dynamicContainer.allKeys.sorted(by: { $0.stringValue < $1.stringValue })
        var tempName = ""
        var tempUrlImage = ""
        var tempId = ""
        var tempInstructions = ""
        for key in allKeys {
            print(key)
            guard let stringKey = DynamicCodingKeys(stringValue: key.stringValue) else {
                continue
            }
            if stringKey.stringValue == "strMeal" {
                tempName = try dynamicContainer.decode(String.self, forKey: stringKey)
                continue
            }
            if stringKey.stringValue == "strMealThumb" {
                tempUrlImage = try dynamicContainer.decode(String.self, forKey: stringKey)
                continue
            }
            if stringKey.stringValue == "idMeal" {
                tempId = try dynamicContainer.decode(String.self, forKey: stringKey)
                continue
            }
            if stringKey.stringValue == "strInstructions" {
                tempInstructions = try dynamicContainer.decode(String.self, forKey: stringKey)
            }
            guard stringKey.stringValue.contains("strIngredient") else {
                continue
            }
            let ingredient = try dynamicContainer.decodeIfPresent(String.self, forKey: stringKey)
            guard let ingredient else { continue }
            let number = stringKey.stringValue.replacingOccurrences(of: "strIngredient", with: "")
            guard let measureKey = DynamicCodingKeys(stringValue: "strMeasure" + number) else {
                tempIngredients.append(Ingredient(ingredient: ingredient, measure: ""))
                continue
            }
            let measure = try dynamicContainer.decode(String.self, forKey: measureKey)
            if !ingredient.isEmpty {
                tempIngredients.append(Ingredient(ingredient: ingredient, measure: measure))
            }
        }
        self.receipt = Receipt(name: tempName, urlImage: tempUrlImage, id: tempId)
        self.ingredients = tempIngredients
        self.instructions = tempInstructions.replacingOccurrences(of: "\r", with: "\n")
    }
}
