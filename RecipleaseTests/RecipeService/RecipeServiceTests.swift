//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by Benjamin Breton on 19/01/2021.
//

import XCTest
@testable import Reciplease

// MARK: - Service's tests

class RecipeServiceTests: XCTestCase {
    func testGivenResponseOkWithDataHasBeenSettenWhenAsksForRecipesThenRecipesAreReceived() {
        // Given
        let recipeGetter = getRecipeGetter(with: .correctResponseWithData("Recipe"))
        // When
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
        let recipeGetter = getRecipeGetter(with: .correctResponseWithData("RecipeLess"))
        // When
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
        let recipeGetter = getRecipeGetter(with: .correctResponseWithoutData)
        // When
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
        let recipeGetter = getRecipeGetter(with: .incorrectResponse)
        // When
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
        let recipeGetter = getRecipeGetter(with: .noResponse)
        // When
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

// MARK: - Supporting methods

extension RecipeServiceTests {
    func getRecipeGetter(with fakeResponse: FakeResponse) -> RecipeGetter {
        let session = fakeResponse.fakeSession
        let getter = RecipeGetter(session: session)
        getter.method = .service
        print(getter.method.title)
        return getter
    }
}
