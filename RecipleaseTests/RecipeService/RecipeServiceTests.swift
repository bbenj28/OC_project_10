//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by Benjamin Breton on 19/01/2021.
//

import XCTest
@testable import Reciplease

class RecipeServiceTests: XCTestCase {

    func testGivenResponseOkWithDataHasBeenSettenWhenAsksForRecipesThenRecipesAreReceived() {
        // Given
        let fakeResponse = FakeResponse.correctResponseWithData("Recipe")
        // When
        let recipeGetter = RecipeGetter(session: fakeResponse.fakeSession)
        let expectation = XCTestExpectation(description: "performs a request")
        recipeGetter.getRecipes(ingredients: ["chicken", "rice"]) { (result) in
            switch result {
            case .success(let recipes):
                // Then
                print(recipes[0].ingredients)
                print(recipes[0].cautions)
                print(recipes[0].healthLabels)
                XCTAssert(recipes.count == 10)
                XCTAssert(recipes[0].title == "Chicken & Rice Soup")
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 3)
    }
    func testGivenResponseOkWithDataWithoutRecipesHasBeenSettenWhenAsksForRecipesThenRecipesAreReceivedButWithANullCount() {
        // Given
        let fakeResponse = FakeResponse.correctResponseWithData("RecipeLess")
        // When
        let recipeGetter = RecipeGetter(session: fakeResponse.fakeSession)
        let expectation = XCTestExpectation(description: "performs a request")
        recipeGetter.getRecipes(ingredients: ["chicken", "rice"]) { (result) in
            switch result {
            case .success(let recipes):
                // Then
                XCTAssert(recipes.count == 0)
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 3)
    }
    func testGivenResponseOkWithoutDataHasBeenSettenWhenAsksForRecipesThenErrorOccures() {
        // Given
        let fakeResponse = FakeResponse.correctResponseWithoutData
        // When
        let recipeGetter = RecipeGetter(session: fakeResponse.fakeSession)
        let expectation = XCTestExpectation(description: "performs a request")
        recipeGetter.getRecipes(ingredients: ["chicken", "rice"]) { (result) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                // Then
                guard let error = error as? ApplicationErrors else {
                    XCTFail()
                    return
                }
                XCTAssert(error == .ncNoData)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3)
    }
    func testGivenResponseWithAWrongStatusCodeHasBeenSettenWhenAsksForRecipesThenErrorOccures() {
        // Given
        let fakeResponse = FakeResponse.incorrectResponse
        // When
        let recipeGetter = RecipeGetter(session: fakeResponse.fakeSession)
        let expectation = XCTestExpectation(description: "performs a request")
        recipeGetter.getRecipes(ingredients: ["chicken", "rice"]) { (result) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                // Then
                guard let error = error as? ApplicationErrors else {
                    XCTFail()
                    return
                }
                XCTAssert(error == .ncBadCode(500))
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3)
    }
    func testGivenNoResponseHasBeenSettenWhenAsksForRecipesThenErrorOccures() {
        // Given
        let fakeResponse = FakeResponse.noResponse
        // When
        let recipeGetter = RecipeGetter(session: fakeResponse.fakeSession)
        let expectation = XCTestExpectation(description: "performs a request")
        recipeGetter.getRecipes(ingredients: ["chicken", "rice"]) { (result) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                // Then
                guard let error = error as? ApplicationErrors else {
                    XCTFail()
                    return
                }
                XCTAssert(error == .ncNoResponse)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3)
    }
    
    

}
