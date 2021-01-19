//
//  RecipeService.swift
//  Reciplease
//
//  Created by Benjamin Breton on 19/01/2021.
//

import Foundation
import Alamofire
class RecipeService {
    let decoder = JSONStructureDecoder()
    init() {
    }
    
    func searchRecipe(for ingredients: [String], completionHandler: @escaping (Result<RecipeJSONStructure, Error>) -> Void) {
        performNetworkCall(for: ingredients) { (response) in
            self.decodeResponse(response, completionHandler: completionHandler)
        }
    }
    
    private func performNetworkCall(for ingredients: [String], completionHandler: @escaping (AFDataResponse<Any>) -> Void) {
        let ingredientsRequest = ingredients.joined(separator: ", ")
        let parameters = [
            "q": ingredientsRequest,
            "app_id": APIKeys.edamamId,
            "app_key": APIKeys.edamamKey
        ]
        AF.request("https://api.edamam.com/search", method: .get, parameters: parameters).responseJSON(completionHandler: completionHandler)
    }
    private func decodeResponse(_ response: AFDataResponse<Any>, completionHandler: (Result<RecipeJSONStructure, Error>) -> Void) {
        guard let httpresponse = response.response else {
            completionHandler(.failure(ApplicationErrors.noresponse))
            return
        }
        guard httpresponse.statusCode == 200 else {
            completionHandler(.failure(ApplicationErrors.badcode(httpresponse.statusCode)))
            return
        }
        decoder.decode(response.data, completionHandler: completionHandler)
    }
}

class JSONStructureDecoder {
    func decode<T: Decodable>(_ data: Data?, completionHandler: (Result<T, Error>) -> Void) {
        guard let data = data else {
            completionHandler(.failure(ApplicationErrors.nodata))
            return
        }
        guard let dataJson = try? JSONDecoder().decode(T.self, from: data) else {
            completionHandler(.failure(ApplicationErrors.dataConformityLess))
            return
        }
        completionHandler(.success(dataJson))
    }
}

enum ApplicationErrors: Error, CustomStringConvertible, Equatable {
    
    // MARK: - Errors
    
    // network call
    case nodata, noresponse, badcode(Int), notemp, dataConformityLess
    
    // MARK: - Descriptions
    
    /// Description to print in the console for developpers to know whats is the problem.
    var description: String {
        switch self {
        // network call
        case .nodata:
            return "pas de data"
        case .noresponse:
            return "Pas de réponse"
        case .badcode(let code):
            return "code \(code)"
        case .notemp:
            return "temp non trouvée"
        case .dataConformityLess:
            return "data non conforme"
        }
    }
}
