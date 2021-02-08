//
//  RecipeGetter.swift
//  Reciplease
//
//  Created by Benjamin Breton on 23/01/2021.
//

import Foundation

final class RecipeGetter {
    
    // MARK: - Methods enum
    
    /// Method types which can be used by recipe getter to get recipes.
    enum Method {
        case service, manager
        /// Title to display by the navigation controller for the page which will contains recipes tableview.
        var title: String {
            switch self {
            case .service:
                return "Results"
            case .manager:
                return "Favorite"
            }
        }
    }
    
    // MARK: - Properties
    
    /// Service used to get recipes when service method is selected.
    private let service: RecipeService
    /// Data manager used to get recipes when manager method is selected.
    private let dataManager: RecipeDataManager
    /// Selected method to get recipes.
    var method: Method = .service
    /// Used by controller to know if the list has been changed.
    var favoritesListDidChange: Bool = true
    
    // MARK: - Init
    
    init(coreDataStack: CoreDataStack = CoreDataStack(), session: AlamofireSession = RecipeSession()) {
        self.service = RecipeService(session: session)
        self.dataManager = RecipeDataManager(coreDataStack: coreDataStack)
    }
    
    // MARK: - Get recipes
    
    /// Used to get recipes regarding the selected method.
    /// - parameter ingredients: Ingredients to specify when service method has been selected. Nil otherwise.
    /// - parameter completionHandler: Actions to do with returned result.
    /// - returns: Result containing recipes in case of success.
    func getRecipes(ingredients: [String]? = nil, completionHandler: @escaping (Result<[Recipe], Error>) -> Void) {
        switch method {
        case .service:
            guard let ingredients = ingredients else { return }
            service.searchRecipe(for: ingredients, completionHandler: completionHandler)
        case .manager:
            completionHandler(.success(dataManager.recipes))
            // last version of favorites list has been loaded, so change property to false
            favoritesListDidChange = false
        }
    }
    
    // MARK: - Favorites
    
    /// Add a recipe to favorites.
    /// - parameter recipe: The recipe to add.
    func addToFavorites(_ recipe: Recipe) {
        dataManager.addToFavorites(recipe)
        // favorites list has been changed, so change property to true
        favoritesListDidChange = true
    }
    /// Remove a recipe from favorites.
    /// - parameter recipe: The recipe to remove.
    func removeFromFavorites(_ recipe: Recipe) {
        dataManager.removeFromFavorites(recipe)
        // favorites list has been changed, so change property to true
        favoritesListDidChange = true
    }
    /// Check if a recipe has already been added as favorite.
    /// - parameter recipe: The recipe to check.
    /// - parameter completionHandler: Actions to do regarding the result. The result is setted as parameter of the closure : *true* if the recipe is a favorite, *false* otherwise.
    func checkIfIsFavorite(_ recipe: Recipe, completionHandler: (Bool) -> Void) {
        dataManager.checkIfIsFavorite(recipe: recipe, completionHandler: completionHandler)
    }
}
