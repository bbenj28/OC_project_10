//
//  Weakifiable.swift
//  Reciplease
//
//  Created by Benjamin Breton on 01/02/2021.
//

import Foundation
protocol Weakifiable: class { }
extension NSObject: Weakifiable { }
extension Weakifiable {
    /// Used in a completion handler parameter to turn weak the object who sets it.
    /// - parameter code: Closure which takes for parameters the weakifiable object who sets the completion handler, and the parameter used by the closure to return.
    /// - returns : The closure used by the completion handler.
    func weakify<T>(_ code: @escaping (Self, T) -> Void) -> (T) -> Void {
        return { [weak self] (data) in
            guard let self = self else { return }
            code(self, data)
        }
    }
}
