//
//  Recipe.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/01/2021.
//

import Foundation
class Recipe {
    let title: String
    private let pictureURL: String
    var pictureData: Data?
    let ingredients: String
    init(title: String, pictureURL: String, ingredients: [String], service: RecipeService) {
        self.title = title
        self.ingredients = "ingredients:\n\(ingredients.map({"- \($0)"}).joined(separator: "\n"))"
        self.pictureURL = pictureURL
        setPictureData(service)
    }
    func setPictureData(_ service: RecipeService) {
        guard let url = URL(string: pictureURL) else { return }
        service.getPictureData(url: url) { (data) in
            self.pictureData = data
        }
    }
}
