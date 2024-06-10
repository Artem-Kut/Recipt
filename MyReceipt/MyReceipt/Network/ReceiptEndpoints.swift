//
//  ReceiptEndpoints.swift
//  MyReceipt
//
//  Created by Artem Kutasevych on 6/10/24.
//

import Foundation
enum ReceiptEndpoint: APIEndpoint {
    case getMeals(filter: String)
    case getMeal(id: String)
    var baseURL: URL {
        return URL(string: "https://themealdb.com/api/json/v1/1")!
    }
    var path: String {
        switch self {
        case .getMeals:
            return "/filter.php"
        case .getMeal:
            return "/lookup.php"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .getMeals, .getMeal:
            return .get
        }
    }
    var headers: [String: String]? {
        return nil
    }
    var parameters: [String: Any]? {
        var parametersIn = [String: Any]()
        switch self {
        case .getMeals(let filter):
             parametersIn["c"] = filter
        case .getMeal(let id):
             parametersIn["i"] = id
        }
        return parametersIn
    }
}
