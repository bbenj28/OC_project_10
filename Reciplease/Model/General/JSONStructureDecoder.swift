//
//  JSONStructureDecoder.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/01/2021.
//

import Foundation
class JSONStructureDecoder {
    func decode<T: Decodable>(_ data: Data?, completionHandler: (Result<T, Error>) -> Void) {
        guard let data = data else {
            completionHandler(.failure(ApplicationErrors.nodata))
            return
        }
        guard let dataJson = try? JSONDecoder().decode(T.self, from: data) else {
            completionHandler(.failure(ApplicationErrors.dataConformityLess))
            return
        }
        completionHandler(.success(dataJson))
    }
}
