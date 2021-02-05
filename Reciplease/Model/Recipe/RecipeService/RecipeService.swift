//
//  RecipeService.swift
//  Reciplease
//
//  Created by Benjamin Breton on 19/01/2021.
//

import Foundation
import Alamofire
final class RecipeService {
    
    // MARK: - Properties
    
    /// Property used to analyze network call's response.
    private let decoder = JSONStructureDecoder()
    /// Session used to perform network calls.
    private let session: AlamofireSession
    
    // MARK: - Init
    
    /// Service used to get recipes by performing network calls.
    /// - parameter session: Session used to perform network calls.
    init(session: AlamofireSession = RecipeSession()) {
        self.session = session
    }
    
    // MARK: - Get recipes
    
    /// Performs a network call and returns getted recipes.
    /// - parameter ingredients: Choosen ingredients.
    /// - parameter completionHandler: Actions to do with the recipes.
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
    /// Performs a network call and returns getted recipes.
    /// - parameter ingredients: Choosen ingredients.
    /// - parameter completionHandler: Actions to do with the recipes.
    private func getRecipes(for ingredients: [String], completionHandler: @escaping (Result<RecipeJSONStructure, Error>) -> Void) {
        guard let url = URL(string: "https://api.edamam.com/search") else { return }
        performNetworkCall(for: ingredients, with: url) { (response) in
            self.decoder.decode(response, completionHandler: completionHandler)
        }
    }
    /// Get data of the recipe's picture.
    /// - parameter url: Picture's url.
    /// - parameter completionHandler: Actions to do with the datas.
    private func getPictureData(_ url: String, completionHandler: (Data?) -> Void) {
        // if a RecipeSession is used, get picture with the url, otherwise nil
        session is RecipeSession ? completionHandler(Data(contentsOfUrlString: url)) : completionHandler(nil)
    }
    /// Performs a network call and returns getted response.
    /// - parameter ingredients: Choosen ingredients.
    /// - parameter completionHandler: Actions to do with the recipes.
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
