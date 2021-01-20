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
            self.decoder.decode(response, completionHandler: completionHandler)
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
    
}
