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
    let session: AlamofireSession
    init(session: AlamofireSession = RecipeSession()) {
        self.session = session
    }
    func searchRecipe(for ingredients: [String], completionHandler: @escaping (Result<[Recipe], Error>) -> Void) {
        // get recipes from a network call
        getRecipes(for: ingredients) { (result) in
            switch result {
            case .success(let recipes):
                var finalRecipes: [Recipe] = []
                guard recipes.count > 0 else {
                    completionHandler(.success(finalRecipes))
                    return
                }
                // get hits
                let hits = recipes.hits
                // get pictures from each hit
                for index in 0...hits.count - 1 {
                    let recipe = hits[index].recipe
                    // check if the session is a fake
                    if let fakeSession = self.session as? FakeAlamofireSession {
                        // if is a fake session, get picture from session
                        finalRecipes.append(Recipe(title: recipe.title, pictureData: fakeSession.pictureData, ingredients: recipe.ingredients, time: recipe.totalTime, persons: recipe.yield))
                        if index == hits.count - 1 {
                            completionHandler(.success(finalRecipes))
                        }
                    } else {
                        // otherwise, get picture with the url
                        if let url = URL(string: recipe.imageURL) {
                            let data = try? Data(contentsOf: url)
                            finalRecipes.append(Recipe(title: recipe.title, pictureData: data, ingredients: recipe.ingredients, time: recipe.totalTime, persons: recipe.yield))
                            if index == hits.count - 1 {
                                completionHandler(.success(finalRecipes))
                            }
                        } else {
                            finalRecipes.append(Recipe(title: recipe.title, pictureData: nil, ingredients: recipe.ingredients, time: recipe.totalTime, persons: recipe.yield))
                            if index == hits.count - 1 {
                                completionHandler(.success(finalRecipes))
                            }
                        }
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getRecipes(for ingredients: [String], completionHandler: @escaping (Result<RecipeJSONStructure, Error>) -> Void) {
        guard let url = URL(string: "https://api.edamam.com/search") else { return }
        performNetworkCall(for: ingredients, with: url) { (response) in
            self.decoder.decode(response, completionHandler: completionHandler)
        }
    }
    
    private func performNetworkCall(for ingredients: [String], with url: URL, completionHandler: @escaping (AFDataResponse<Any>) -> Void) {
        let ingredientsRequest = ingredients.joined(separator: ", ")
        let parameters = [
            "q": ingredientsRequest,
            "app_id": APIKeys.edamamId,
            "app_key": APIKeys.edamamKey
        ]
        session.request(url: url, method: .get, parameters: parameters, completionHandler: completionHandler)
    }
    
}
