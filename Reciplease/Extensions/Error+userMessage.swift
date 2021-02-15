//
//  Error+userMessage.swift
//  Reciplease
//
//  Created by Benjamin Breton on 17/11/2020.
//

import Foundation
extension Error {
    /// Message to display to users if an error occured.
    var userMessage: String {
        if let error = self as? ApplicationErrors {
            switch error {
            // network call
            case .ncNoData, .ncBadCode(_), .ncNoResponse, .ncDataConformityLess, .ncAFError:
                return "An error occurred concerning the network call. Please check your connexion."
            }
        } else {
            return "An error occurred."
        }
    }
}
