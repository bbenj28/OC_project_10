//
//  JSONStructureDecoder.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/01/2021.
//

import Foundation
import Alamofire

class JSONStructureDecoder {
    func decode<T: Decodable>(_ response: AFDataResponse<Any>, completionHandler: (Result<T, Error>) -> Void) {
        guard let httpresponse = response.response else {
            completionHandler(.failure(ApplicationErrors.ncNoResponse))
            return
        }
        guard httpresponse.statusCode == 200 else {
            completionHandler(.failure(ApplicationErrors.ncBadCode(httpresponse.statusCode)))
            return
        }
        guard let data = response.data else {
            completionHandler(.failure(ApplicationErrors.ncNoData))
            return
        }
        guard let dataJson = try? JSONDecoder().decode(T.self, from: data) else {
            completionHandler(.failure(ApplicationErrors.ncDataConformityLess))
            return
        }
        completionHandler(.success(dataJson))
    }
}
