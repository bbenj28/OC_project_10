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
    func searchRecipe(for ingredients: [String], completionHandler: @escaping (Result<[Recipe], Error>) -> Void) {
        getRecipes(for: ingredients) { (result) in
            switch result {
            case .success(let recipes):
                var finalRecipes: [Recipe] = []
                guard recipes.count > 0 else {
                    completionHandler(.success(finalRecipes))
                    return
                }
                let hits = recipes.hits
                for index in 0...hits.count - 1 {
                    let recipe = hits[index].recipe
                    if let url = URL(string: recipe.imageURL) {
                        self.getPictureData(url: url) { (data) in
                            finalRecipes.append(Recipe(title: recipe.title, pictureData: data, ingredients: recipe.ingredients))
                            if index == hits.count - 1 {
                                completionHandler(.success(finalRecipes))
                            }
                        }
                    } else {
                        finalRecipes.append(Recipe(title: recipe.title, pictureData: nil, ingredients: recipe.ingredients))
                        if index == hits.count - 1 {
                            completionHandler(.success(finalRecipes))
                        }
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getRecipes(for ingredients: [String], completionHandler: @escaping (Result<RecipeJSONStructure, Error>) -> Void) {
        performNetworkCall(for: ingredients) { (response) in
            self.decoder.decode(response, completionHandler: completionHandler)
        }
    }
    
    func recipesAnalyzer() {
        
    }
    
    func getPictureData(url: URL, completionHandler: @escaping (Data?) -> Void) {
        AF.request(url).response { (response) in
            if let data = response.data {
                completionHandler(data)
            } else {
                completionHandler(nil)
            }
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
