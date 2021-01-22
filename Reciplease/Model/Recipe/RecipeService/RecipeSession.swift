//
//  RecipeSession.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/01/2021.
//

import Foundation
import Alamofire

final class RecipeSession: AlamofireSession {
    func request(url: URL, method: HTTPMethod = .get, parameters: Parameters? = nil, completionHandler: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(url, method: method, parameters: parameters).responseJSON { (response) in
            completionHandler(response)
        }
    }
}
