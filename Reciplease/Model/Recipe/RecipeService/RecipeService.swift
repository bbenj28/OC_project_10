//
//  RecipeService.swift
//  Reciplease
//
//  Created by Benjamin Breton on 19/01/2021.
//

import Foundation
import Alamofire
class RecipeService {
    typealias PictureData = Data?
    let decoder = JSONStructureDecoder()
    let session: AlamofireSession
    init(session: AlamofireSession = RecipeSession()) {
        self.session = session
    }
    
    func searchRecipe(for ingredients: [String], completionHandler: @escaping (Result<[Recipe], Error>) -> Void) {
        // get recipes from a network call
        getRecipes(for: ingredients) { (result) in
            switch result {
            case .success(let response):
                // in case of success, prepare the recipes to return
                var finalRecipes: [RecipeDetailsJSONStructure] = []
                guard response.count > 0 else {
                    // no result case : return empty array
                    completionHandler(.success(finalRecipes))
                    return
                }
                // get hits
                let hits = response.hits
                // get picture and recipe from each hit
                for index in 0...hits.count - 1 {
                    var recipe = hits[index].recipe
                    self.getPictureData(recipe.imageURL) { (pictureData) in
                        recipe.pictureData = pictureData
                        finalRecipes.append(recipe)
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
        if session is RecipeSession {
            // if a RecipeSession is used, get picture with the url
            if let url = URL(string: url) {
                let data = try? Data(contentsOf: url)
                completionHandler(data)
            } else {
                completionHandler(nil)
            }
        } else {
            // otherwise a fakesession is used, so get default picture
            completionHandler(nil)
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
