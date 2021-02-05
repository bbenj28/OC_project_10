//
//  RecipeDataManager.swift
//  Reciplease
//
//  Created by Benjamin Breton on 22/01/2021.
//

import Foundation
import CoreData
class RecipeDataManager {
    
    // MARK: - Properties
    
    /// CoreDataStack used to save and load favorites recipes.
    let stack: CoreDataStack
    /// Loaded recipes.
    var recipes: [RecipeData] {
        let request: NSFetchRequest<RecipeData> = RecipeData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "optionalTitle", ascending: true)]
        guard let result = try? stack.viewContext.fetch(request) else { return [] }
        return result
    }
    
    // MARK: - Init
    
    /// Class used to save and load favorites recipes.
    /// - parameter coreDataStack: CoreDataStack used to save and load favorites recipes.
    init(coreDataStack: CoreDataStack = CoreDataStack()) {
        self.stack = coreDataStack
    }
    
    // MARK: - Add favorite
    
    /// Add a recipe to favorites.
    /// - parameter recipe: Recipe to add.
    func addToFavorites(_ recipe: Recipe) {
        // create entity
        let savedRecipe = RecipeData(context: stack.viewContext)
        // add each property
        savedRecipe.optionalUri = recipe.uri
        savedRecipe.optionalTitle = recipe.title
        savedRecipe.optionalUrl = recipe.url
        savedRecipe.optionalImageUrl = recipe.imageURL
        savedRecipe.optionalYield = Int64(recipe.yield)
        savedRecipe.calories = recipe.calories
        savedRecipe.totalWeight = recipe.totalWeight
        savedRecipe.totalTime = recipe.totalTime
        savedRecipe.pictureData = recipe.pictureData
        savedRecipe.optionalIngredients = recipe.ingredients
        savedRecipe.optionalCautions = recipe.cautions
        savedRecipe.optionalHealthLabels = recipe.healthLabels
        // save context
        stack.saveContext()
    }

    // MARK: - Supporting methods
    
    /// Check if a recipe has already been saved.
    /// - parameter recipe: Recipe to check.
    /// - parameter completionHandler: Actions to do when an answer has been received.
    func checkIfIsFavorite(recipe: Recipe, completionHandler: (Bool) -> Void) {
        // if the recipe hasn't been saved, return false
        guard let _ = getWithPredicate(recipe.uri) else {
            completionHandler(false)
            return
        }
        // else return true
        completionHandler(true)
    }
    /// Get the saved recipe with its URI.
    /// - parameter recipeUri: URI to search.
    /// - returns: The RecipeData of the recipe if it has been found, otherwise returns nil.
    private func getWithPredicate(_ recipeUri: String) -> RecipeData? {
        // prepare request and predicate
        let request: NSFetchRequest<RecipeData> = RecipeData.fetchRequest()
        let predicate = NSPredicate(format: "optionalUri == %@", recipeUri)
        request.predicate = predicate
        // get RecipeData
        guard let recipes = try? stack.viewContext.fetch(request), recipes.count == 1 else { return nil }
        return recipes[0]
    }
    
    // MARK: - Remove favorite
    
    /// Remove a recipe from the favorites.
    /// - parameter recipe: Recipe to remove.
    func removeFromFavorites(_ recipe: Recipe) {
        // get Recipe
        guard let recipe = getWithPredicate(recipe.uri) else { return }
        // remove it
        stack.viewContext.delete(recipe)
        stack.saveContext()
    }
    
}

