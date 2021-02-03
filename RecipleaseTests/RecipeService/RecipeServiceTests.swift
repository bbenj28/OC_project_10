//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by Benjamin Breton on 19/01/2021.
//

import XCTest
@testable import Reciplease

class RecipeServiceTests: XCTestCase {

    func testGivenWhenThen() {
        let fakeResponse = FakeResponse.correctResponseWithData("Recipe")
        let recipeGetter = RecipeGetter(session: fakeResponse.fakeSession)
        recipeGetter.getRecipes(ingredients: ["chicken", "rice"]) { (result) in
            switch result {
            case .success(let recipes):
                XCTAssert(recipes.count == 10)
                XCTAssert(recipes[0].title == "Chicken & Rice Soup")
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
    }

}
