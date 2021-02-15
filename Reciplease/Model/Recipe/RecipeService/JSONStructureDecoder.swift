//
//  JSONStructureDecoder.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/01/2021.
//

import Foundation
import Alamofire

class JSONStructureDecoder {
    /// Deal with alamofire response, and try to return data in the choosen format.
    /// - parameter response: Response returned by alamofire.
    /// - parameter completionHandler: Closure to perform with this method's result.
    func decode<T: Decodable>(_ response: AFDataResponse<Any>, completionHandler: (Result<T, Error>) -> Void) {
        // check if an error occured
        guard response.error == nil else {
            guard let error = response.error else { return }
            print(error)
            completionHandler(.failure(ApplicationErrors.ncAFError))
            return
        }
        // check if a reponses exists
        guard let httpresponse = response.response else {
            completionHandler(.failure(ApplicationErrors.ncNoResponse))
            return
        }
        // check response's status code
        guard httpresponse.statusCode == 200 else {
            completionHandler(.failure(ApplicationErrors.ncBadCode(httpresponse.statusCode)))
            return
        }
        // check if data exists
        guard let data = response.data else {
            completionHandler(.failure(ApplicationErrors.ncNoData))
            return
        }
        // try to convert data in the choosen format
        guard let dataJson = try? JSONDecoder().decode(T.self, from: data) else {
            completionHandler(.failure(ApplicationErrors.ncDataConformityLess))
            return
        }
        completionHandler(.success(dataJson))
    }
}
