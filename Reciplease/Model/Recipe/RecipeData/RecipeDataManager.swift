//
//  RecipeDataManager.swift
//  Reciplease
//
//  Created by Benjamin Breton on 22/01/2021.
//

import Foundation
import CoreData
class RecipeDataManager {
    let stack: CoreDataStack
    var recipes: [RecipeData] {
        let request: NSFetchRequest<RecipeData> = RecipeData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "optionalTitle", ascending: true)]
        guard let result = try? stack.viewContext.fetch(request) else { return [] }
        return result
    }
    
    init(coreDataStack: CoreDataStack = CoreDataStack()) {
        self.stack = coreDataStack
    }
    func addToFavorites(_ recipe: Recipe) {
        let savedRecipe = RecipeData(context: stack.viewContext)
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
        stack.saveContext()
    }

    func checkIfIsFavorite(recipe: Recipe, completionHandler: (Bool) -> Void) {
        guard let _ = getWithPredicate(recipe.uri) else {
            completionHandler(false)
            return
        }
        completionHandler(true)
    }
    func removeFromFavorites(_ recipe: Recipe) {
        guard let recipe = getWithPredicate(recipe.uri) else { return }
        stack.viewContext.delete(recipe)
        stack.saveContext()
    }
    private func getWithPredicate(_ recipeUri: String) -> RecipeData? {
        let request: NSFetchRequest<RecipeData> = RecipeData.fetchRequest()
        let predicate = NSPredicate(format: "optionalUri == %@", recipeUri)
        request.predicate = predicate
        guard let recipes = try? stack.viewContext.fetch(request), recipes.count > 0 else { return nil }
        return recipes[0]
    }
}

