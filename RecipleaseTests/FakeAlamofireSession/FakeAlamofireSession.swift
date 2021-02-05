//
//  FakeAlamofireSession.swift
//  RecipleaseTests
//
//  Created by Benjamin Breton on 03/02/2021.
//

import Foundation
import Alamofire
@testable import Reciplease


class FakeAlamofireSession: AlamofireSession {

    // MARK: - Properties

    var response: HTTPURLResponse?
    var data: Data?
    var error: AFError?

    // MARK: - Initializer

    init(response: HTTPURLResponse?, data: Data?, error: AFError?) {
        self.response = response
        self.data = data
        self.error = error
    }

    // MARK: - Methods

    func request(url: URL, method: HTTPMethod, parameters: Parameters?, completionHandler: @escaping (AFDataResponse<Any>) -> Void) {
        if let error = self.error {
            let dataResponse = AFDataResponse<Any>(request: nil, response: response, data: data, metrics: nil, serializationDuration: 0, result: .failure(error))
            completionHandler(dataResponse)
        } else {
            let dataResponse = AFDataResponse<Any>(request: nil, response: response, data: data, metrics: nil, serializationDuration: 0, result: .success("OK"))
            
            completionHandler(dataResponse)
        }
        
    }
}
enum FakeResponse {
    case correctResponseWithData(String), correctResponseWithoutData, incorrectResponse(Int), error, noResponse
    var fakeSession: FakeAlamofireSession {
        switch self {
        case .correctResponseWithData(let dataName):
            let response = HTTPURLResponse(
                url: URL(string: "https://openclassrooms.com")!,
                statusCode: 200, httpVersion: nil, headerFields: [:])!
            let bundle = Bundle(for: FakeAlamofireSession.self)
            let url = bundle.url(forResource: dataName, withExtension: "json")!
            let data = try! Data(contentsOf: url)
            return FakeAlamofireSession(response: response, data: data, error: nil)
        case .correctResponseWithoutData:
            let response = HTTPURLResponse(
                url: URL(string: "https://openclassrooms.com")!,
                statusCode: 200, httpVersion: nil, headerFields: [:])!
            return FakeAlamofireSession(response: response, data: nil, error: nil)
        case .incorrectResponse(let code):
            let response = HTTPURLResponse(
                url: URL(string: "https://openclassrooms.com")!,
                statusCode: code, httpVersion: nil, headerFields: [:])!
            return FakeAlamofireSession(response: response, data: nil, error: nil)
        case .noResponse:
            return FakeAlamofireSession(response: nil, data: nil, error: nil)
        case .error:
            
            let error: AFError = AFError.explicitlyCancelled
            return FakeAlamofireSession(response: nil, data: nil, error: error)
        }
    }
}
