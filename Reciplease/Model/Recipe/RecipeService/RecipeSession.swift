//
//  RecipeSession.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/01/2021.
//

import Foundation
import Alamofire

final class RecipeSession: AlamofireSession {
    /// Request used to perform network calls.
    /// - parameter url: URL to call.
    /// - parameter method: Method used to perform the call.
    /// - parameter parameters: Call's parameters.
    /// - parameter completionHandler: Actions to do with the getted  response.
    func request(url: URL, method: HTTPMethod = .get, parameters: Parameters? = nil, completionHandler: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(url, method: method, parameters: parameters).responseJSON { (response) in
            completionHandler(response)
        }
    }
}
