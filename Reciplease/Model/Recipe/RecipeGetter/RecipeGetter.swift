//
//  RecipeGetter.swift
//  Reciplease
//
//  Created by Benjamin Breton on 23/01/2021.
//

import Foundation

class RecipeGetter {
    enum Method {
        case service, manager
        var title: String {
            switch self {
            case .service:
                return "Results"
            case .manager:
                return "Favorite"
            }
        }
    }
    let service: RecipeService
    let dataManager: RecipeDataManager
    var method: Method = .service
    init(coreDataStack: CoreDataStack = CoreDataStack(), session: RecipeSession = RecipeSession()) {
        self.service = RecipeService(session: session)
        self.dataManager = RecipeDataManager(coreDataStack: coreDataStack)
    }
    
    func getRecipes(ingredients: [String]? = nil, completionHandler: @escaping (Result<[Recipe], Error>) -> Void) {
        switch method {
        case .service:
            guard let ingredients = ingredients else { return }
            service.searchRecipe(for: ingredients, completionHandler: completionHandler)
        case .manager:
            completionHandler(.success(dataManager.recipes))
        }
    }
    func addToFavorites(_ recipe: Recipe, completionHandler: () -> Void) {
        dataManager.addToFavorites(recipe, completionHandler: completionHandler)
    }
    func removeFromFavorites(_ recipe: Recipe, completionHandler: (Bool) -> Void) {
        dataManager.removeFromFavorites(recipe, completionHandler: completionHandler)
    }
    func checkIfIsFavorite(_ recipe: RecipeDetailsJSONStructure, completionHandler: (Bool) -> Void) {
        let recipeData = dataManager.checkIfIsFavoriteAndReturnData(recipe: recipe)
        completionHandler(recipeData != nil)
    }
}
