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
    func weakify<T>(_ code: @escaping (Self, T) -> Void) -> (T) -> Void {
        return { [weak self] (data) in
            guard let self = self else { return }
            code(self, data)
        }
    }
}
