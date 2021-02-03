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
