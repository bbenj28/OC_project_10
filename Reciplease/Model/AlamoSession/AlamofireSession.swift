//
//  AlamofireSession.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/01/2021.
//

import Foundation
import Alamofire

protocol AlamofireSession {
    func request(url: URL, method: HTTPMethod, parameters: Parameters?, completionHandler: @escaping (AFDataResponse<Any>) -> Void)
}



final class FakeAlamofireSession: AlamofireSession {

    // MARK: - Properties

    var response: HTTPURLResponse?
    var data: Data?
    var error: Error?
    var pictureData: Data?

    // MARK: - Initializer

    init(response: HTTPURLResponse?, data: Data?, error: Error?, pictureData: Data?) {
        self.response = response
        self.data = data
        self.error = error
        self.pictureData = pictureData
    }

    // MARK: - Methods

    func request(url: URL, method: HTTPMethod, parameters: Parameters?, completionHandler: @escaping (AFDataResponse<Any>) -> Void) {
        let dataResponse = AFDataResponse<Any>(request: nil, response: response, data: data, metrics: nil, serializationDuration: 0, result: .success("OK"))
        completionHandler(dataResponse)
    }
}
enum FakeResponse {
    case correctResponseWithData(String), correctResponseWithoutData, incorrectResponse, error
    var pictureData: Data {
        guard let image = UIImage(named: "meal") else { fatalError() }
        guard let data = image.pngData() else { fatalError() }
        return data
    }
    var fakeSession: FakeAlamofireSession {
        switch self {
        case .correctResponseWithData(let dataName):
            let response = HTTPURLResponse(
                url: URL(string: "https://openclassrooms.com")!,
                statusCode: 200, httpVersion: nil, headerFields: [:])!
            let bundle = Bundle(for: FakeAlamofireSession.self)
            let url = bundle.url(forResource: dataName, withExtension: "json")!
            let data = try! Data(contentsOf: url)
            return FakeAlamofireSession(response: response, data: data, error: nil, pictureData: pictureData)
        case .correctResponseWithoutData:
            let response = HTTPURLResponse(
                url: URL(string: "https://openclassrooms.com")!,
                statusCode: 200, httpVersion: nil, headerFields: [:])!
            return FakeAlamofireSession(response: response, data: nil, error: nil, pictureData: nil)
        case .incorrectResponse:
            let response = HTTPURLResponse(
                url: URL(string: "https://openclassrooms.com")!,
                statusCode: 500, httpVersion: nil, headerFields: [:])!
            return FakeAlamofireSession(response: response, data: nil, error: nil, pictureData: nil)
        case .error:
            class FakeError: Error {}
            let error = FakeError()
            return FakeAlamofireSession(response: nil, data: nil, error: error, pictureData: nil)
        }
    }
}
