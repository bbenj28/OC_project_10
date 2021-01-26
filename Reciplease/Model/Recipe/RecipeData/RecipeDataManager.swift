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
    var ingredients: [Ingredient] {
        let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let result = try? stack.viewContext.fetch(request) else { return [] }
        return result
    }
    var healthLabels: [HealthLabel] {
        let request: NSFetchRequest<HealthLabel> = HealthLabel.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let result = try? stack.viewContext.fetch(request) else { return [] }
        return result
    }
    var cautions: [Caution] {
        let request: NSFetchRequest<Caution> = Caution.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let result = try? stack.viewContext.fetch(request) else { return [] }
        return result
    }
    
    init(coreDataStack: CoreDataStack = CoreDataStack()) {
        self.stack = coreDataStack
    }
    func addToFavorites(_ recipe: Recipe, completionHandler: () -> Void) {
        let savedRecipe = RecipeData(context: stack.viewContext)
        savedRecipe.optionalTitle = recipe.title
        savedRecipe.optionalUrl = recipe.url
        savedRecipe.optionalImageUrl = recipe.imageURL
        savedRecipe.optionalYield = Int64(recipe.yield)
        savedRecipe.calories = recipe.calories
        savedRecipe.totalWeight = recipe.totalWeight
        savedRecipe.totalTime = recipe.totalTime
        savedRecipe.pictureData = recipe.pictureData
        addRecipeParts(from: recipe, to: savedRecipe)
        stack.saveContext()
        completionHandler()
    }
    private func addRecipeParts(from recipe: Recipe, to savedRecipe: RecipeData) {
        for index in 1...3 {
            switch index {
            case 1:
                let array: [Ingredient] = getRecipeParts(recipe.ingredients)
                let set = NSSet(array: array)
                savedRecipe.optionalIngredients = set
            case 2:
                let array: [HealthLabel] = getRecipeParts(recipe.healthLabels)
                let set = NSSet(array: array)
                savedRecipe.optionalHealthLabels = set
            case 3:
                let array: [Caution] = getRecipeParts(recipe.cautions)
                let set = NSSet(array: array)
                savedRecipe.optionalCautions = set
            default:
                break
            }
        }
    }
    private func getRecipeParts<T: RecipePart>(_ recipeArray: [String]) -> [T] {
        var tArray: [T] = []
        for singleName in recipeArray {
            if let singleT: T = checkExistingEntity(singleName) {
                tArray.append(singleT)
            } else {
                if var singleT = Ingredient(context: stack.viewContext) as? T {
                    singleT.name = singleName
                    tArray.append(singleT)
                }
                if var singleT = HealthLabel(context: stack.viewContext) as? T {
                    singleT.name = singleName
                    tArray.append(singleT)
                }
                if var singleT = Caution(context: stack.viewContext) as? T {
                    singleT.name = singleName
                    tArray.append(singleT)
                }
            }
        }
        return tArray
    }
    private func checkExistingEntity<T: RecipePart>(_ name: String) -> T? {
        let entities: [[RecipePart]] = [ingredients, healthLabels, cautions]
        for entity in entities {
            if let _ = entity as? [T] {
                for single in entity {
                    if let singleName = single.name, singleName == name, let existingEntity = single as? T {
                        return existingEntity
                    }
                }
            }
        }
        return nil
    }
    func removeFromFavorites(_ recipe: Recipe, completionHandler: (Bool) -> Void) {
        if let recipe = recipe as? RecipeData {
            deleteRecipe(recipe, hasToCloseTable: true, completionHandler: completionHandler)
        } else if let recipe = recipe as? RecipeDetailsJSONStructure {
            guard let recipe = checkIfIsFavoriteAndReturnData(recipe: recipe) else { return }
            deleteRecipe(recipe, hasToCloseTable: false, completionHandler: completionHandler)
        }
    }
    func checkIfIsFavoriteAndReturnData(recipe recipeToSearch: RecipeDetailsJSONStructure) -> RecipeData? {
        if recipes.count > 0 {
            for recipe in recipes {
                if recipe.title == recipeToSearch.title {
                    return recipe
                }
            }
        }
        return nil
    }
    private func deleteRecipe(_ recipe: RecipeData, hasToCloseTable: Bool, completionHandler: (Bool) -> Void) {
        stack.viewContext.delete(recipe)
        stack.saveContext()
        completionHandler(hasToCloseTable)
    }
}
