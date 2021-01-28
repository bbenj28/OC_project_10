//
//  Recipe.swift
//  Reciplease
//
//  Created by Benjamin Breton on 21/01/2021.
//

import Foundation
import CoreData
protocol Recipe {
    var title: String { get }
    var url: String { get }
    var imageURL: String { get }
    var yield: Int { get }
    var calories: Float { get }
    var totalWeight: Float { get }
    var totalTime: Float { get }
    var ingredients: String { get }
    var healthLabels: [String] { get }
    var cautions: [String] { get }
    var pictureData: Data? { get set }
}
protocol RecipePart {
    var name: String? { get set }
    var recipes: NSSet? { get set }
}
open class HealthLabel: NSManagedObject, RecipePart {
    var unwrappedName: String {
        guard let name = name else { return "" }
        return name
    }
}
open class Caution: NSManagedObject, RecipePart {
    var unwrappedName: String {
        guard let name = name else { return "" }
        return name
    }
}
