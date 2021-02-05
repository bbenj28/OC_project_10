//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by Benjamin Breton on 19/01/2021.
//

import XCTest
@testable import Reciplease

class RecipeDataTests: XCTestCase {
    
    var recipeGetter: RecipeGetter?
    let recipe = RecipeDetailsJSONStructure(uri: "TestRecipe", title: "TestRecipe", url: "TestRecipe", imageURL: "TestRecipe", yield: 5, calories: 5, totalWeight: 5, totalTime: 5, ingredientsArray: ["TestRecipe"], healthLabelsArray: ["TestRecipe"], cautionsArray: ["TestRecipe"], pictureData: nil)
    
    override func setUp() {
        let fakeStack = FakeCoreDataStack()
        recipeGetter = RecipeGetter(coreDataStack: fakeStack)
        recipeGetter?.method = .manager
        print(recipeGetter!.method.title)
        
    }
    override func tearDown() {
        recipeGetter = nil
    }
    
    func testGivenRecipeHasBeenAddedToFavoritesWhenLoadItThenRecipeIsLoaded() {
        // Given
        recipeGetter?.addToFavorites(recipe)
        // When
        recipeGetter?.getRecipes(completionHandler: { (result) in
            switch result {
            case .success(let recipes):
                // Then
                XCTAssert(recipes.count == 1)
                XCTAssert(recipes[0].uri == "TestRecipe")
                XCTAssert(recipes[0].title == "TestRecipe")
                XCTAssert(recipes[0].url == "TestRecipe")
                XCTAssert(recipes[0].imageURL == "TestRecipe")
                XCTAssert(recipes[0].yield == 5)
                XCTAssert(recipes[0].calories == 5)
                XCTAssert(recipes[0].totalTime == 5)
                XCTAssert(recipes[0].totalWeight == 5)
                XCTAssert(recipes[0].cautions == "- TestRecipe")
                XCTAssert(recipes[0].healthLabels == "- TestRecipe")
                XCTAssert(recipes[0].ingredients == "- TestRecipe")
                XCTAssert(recipes[0].pictureData == nil)
            case .failure(_):
                XCTFail()
            }
        })
    }
    
    func testGivenRecipeHasBeenAddedToFavoritesWhenCheckIfIsFavoriteThenAnswerIsTrue() {
        // Given
        recipeGetter?.addToFavorites(recipe)
        // When
        recipeGetter?.checkIfIsFavorite(recipe, completionHandler: { (isFavorite) in
            // Then
            XCTAssert(isFavorite)
        })
    }
    func testNoRecipeHasBeenAddedToFavoritesWhenCheckIfIsFavoriteThenAnswerIsFalse() {
        // Given
        // When
        recipeGetter?.checkIfIsFavorite(recipe, completionHandler: { (isFavorite) in
            // Then
            XCTAssert(!isFavorite)
        })
    }
    
    func testGivenRecipeHasBeenAddedToFavoritesWhenRemoveItThenRecipeIsRemoved() {
        // Given
        recipeGetter?.addToFavorites(recipe)
        // When
        recipeGetter?.removeFromFavorites(recipe)
        recipeGetter?.getRecipes(completionHandler: { (result) in
            switch result {
            case .success(let recipes):
                // Then
                XCTAssert(recipes.count == 0)
            default:
                XCTFail()
            }
        })
    }
    
    
    

}
