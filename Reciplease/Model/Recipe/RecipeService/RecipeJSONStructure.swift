//
//  CurrencyResultStructure.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/10/2020.
//

import Foundation
// Structure of the fixer's JSON file
struct RecipeJSONStructure {
    let count: Int
    let hits: [HitJSONStructure]
}
extension RecipeJSONStructure: Decodable {
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case hits = "hits"
    }
}
struct HitJSONStructure {
    let recipe: RecipeDetailsJSONStructure
}
extension HitJSONStructure: Decodable {
    enum CodingKeys: String, CodingKey {
        case recipe = "recipe"
    }
}
struct RecipeDetailsJSONStructure: Recipe {
    var uri: String
    var title: String
    var url: String
    var imageURL: String
    var yield: Int
    var calories: Float
    var totalWeight: Float
    var totalTime: Float
    var ingredientsArray: [String]
    var healthLabelsArray: [String]
    var cautionsArray: [String]
    var pictureData: Data?
    var ingredients: String {
        guard ingredientsArray.count > 0 else { return "" }
        return ingredientsArray.map({ "- \($0)" }).joined(separator: "\n")
    }
    var cautions: String {
        guard cautionsArray.count > 0 else { return "" }
        return cautionsArray.map({ "- \($0)" }).joined(separator: "\n")
    }
    var healthLabels: String {
        guard healthLabelsArray.count > 0 else { return "" }
        return healthLabelsArray.map({ "- \($0)" }).joined(separator: "\n")
    }
}
extension RecipeDetailsJSONStructure: Decodable {
    enum CodingKeys: String, CodingKey {
        case uri = "uri"
        case title = "label"
        case url = "url"
        case imageURL = "image"
        case yield = "yield"
        case calories = "calories"
        case totalWeight = "totalWeight"
        case ingredientsArray = "ingredientLines"
        case totalTime = "totalTime"
        case healthLabelsArray = "healthLabels"
        case cautionsArray = "cautions"
    }
}
