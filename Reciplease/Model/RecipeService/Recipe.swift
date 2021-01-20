//
//  Recipe.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/01/2021.
//

import Foundation
class Recipe {
    let title: String
    var pictureData: Data?
    let ingredients: String
    let time: Int
    let persons: Int
    init(title: String, pictureData: Data?, ingredients: [String], time: Float, persons: Int) {
        self.title = title
        self.ingredients = "ingredients:\n\(ingredients.map({"- \($0)"}).joined(separator: "\n"))"
        self.pictureData = pictureData
        self.persons = persons
        self.time = Int(time)
    }
}
