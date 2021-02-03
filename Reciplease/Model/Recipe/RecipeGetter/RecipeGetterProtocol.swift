//
//  RecipeGetterProtocol.swift
//  Reciplease
//
//  Created by Benjamin Breton on 25/01/2021.
//

import Foundation
/// Protocol used to be sure controllers have a recipe getter property.
protocol RecipeGetterProtocol {
    var recipeGetter: RecipeGetter? { get set }
}
