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
    func testGivenResponseOkWithDataWithoutConformityHasBeenSettenWhenAsksForRecipesThenErrorsOccures() {
        // Given
        let recipeGetter = getRecipeGetter(with: .correctResponseWithData("RecipeConformityLess"))
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
                XCTAssert(error == .ncDataConformityLess)
                print(error)
                print(error.userMessage)
                expectation.fulfill()
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
                print(error)
                print(error.userMessage)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3)
    }
    func testGivenResponseWithAWrongStatusCodeHasBeenSettenWhenAsksForRecipesThenErrorOccures() {
        for code in 100...527 {
            if code != 200 {
                errorCodesTesting(code)
            }
        }
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
                print(error)
                print(error.userMessage)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3)
    }
    func testGivenErrorHasBeenSettenWhenAsksForRecipesThenErrorOccures() {
        // Given
        let recipeGetter = getRecipeGetter(with: .error)
        // When
        let expectation = XCTestExpectation(description: "performs a request")
        recipeGetter.getRecipes(ingredients: ["chicken", "rice"]) { (result) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                // Then
                XCTAssertNotNil(error)
                print("ERREUR ////// \(error)")
                print(error.userMessage)
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
    func errorCodesTesting(_ code: Int) {
        // Given
        let recipeGetter = getRecipeGetter(with: .incorrectResponse(code))
        // When
        let expectation = XCTestExpectation(description: "performs a request")
        recipeGetter.getRecipes(ingredients: ["chicken", "rice"]) { (result) in
            switch result {
            case .success(_):
                XCTAssert(code == 200)
            case .failure(let error):
                // Then
                guard let error = error as? ApplicationErrors else {
                    XCTFail()
                    return
                }
                XCTAssert(error == .ncBadCode(code))
                print(error)
                print(error.userMessage)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3)
    }
}
