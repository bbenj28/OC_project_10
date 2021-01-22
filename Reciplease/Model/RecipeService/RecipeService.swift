//
//  RecipeService.swift
//  Reciplease
//
//  Created by Benjamin Breton on 19/01/2021.
//

import Foundation
import Alamofire
class RecipeService {
    typealias RecipeDetails = (Recipe, PictureData)
    typealias PictureData = Data?
    let decoder = JSONStructureDecoder()
    let session: AlamofireSession
    init(session: AlamofireSession = RecipeSession()) {
        self.session = session
    }
    
    func searchRecipe(for ingredients: [String], completionHandler: @escaping (Result<[RecipeDetails], Error>) -> Void) {
        // get recipes from a network call
        getRecipes(for: ingredients) { (result) in
            switch result {
            case .success(let response):
                // in case of success, prepare the recipes to return
                var finalRecipes: [RecipeDetails] = []
                guard response.count > 0 else {
                    // no result case : return empty array
                    completionHandler(.success(finalRecipes))
                    return
                }
                // get hits
                let hits = response.hits
                // get picture and recipe from each hit
                for index in 0...hits.count - 1 {
                    let recipe = hits[index].recipe
                    self.getPictureData(recipe.imageURL) { (pictureData) in
                        finalRecipes.append((recipe, pictureData))
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
    
    private func getRecipes(for ingredients: [String], completionHandler: @escaping (Result<RecipeJSONStructure, Error>) -> Void) {
        guard let url = URL(string: "https://api.edamam.com/search") else { return }
        performNetworkCall(for: ingredients, with: url) { (response) in
            self.decoder.decode(response, completionHandler: completionHandler)
        }
    }
    private func getPictureData(_ url: String, completionHandler: (PictureData) -> Void) {
        if session is FakeAlamofireSession {
            // if a fakesession is used, get default picture
            completionHandler(nil)
        } else {
            // otherwise, get picture with the url
            if let url = URL(string: url) {
                let data = try? Data(contentsOf: url)
                completionHandler(data)
            } else {
                completionHandler(nil)
            }
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
