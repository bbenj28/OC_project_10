//
//  RecipeData.swift
//  Reciplease
//
//  Created by Benjamin Breton on 22/01/2021.
//

import Foundation
import CoreData
open class RecipeData: NSManagedObject, Recipe {
    var title: String {
        guard let title = optionalTitle else { return "" }
        return title
    }
    var url: String {
        guard let url = optionalUrl else { return "" }
        return url
    }
    var imageURL: String {
        guard let url = optionalImageUrl else { return "" }
        return url
    }
    var yield: Int {
        return Int(optionalYield)
    }
    var ingredients: String {
        guard let ingredients = optionalIngredients else { return "" }
        return ingredients
    }
    var healthLabels: String {
        guard let labels = optionalHealthLabels else { return "" }
        return labels
    }
    var cautions: String {
        guard let cautions = optionalCautions else { return "" }
        return cautions
    }
    var ingredientsOnALine: String {
        return ingredients.split(separator: "\n").joined(separator: " ")
    }
}
