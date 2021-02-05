//
//  Data+initWithString.swift
//  Reciplease
//
//  Created by Benjamin Breton on 05/02/2021.
//

import Foundation
extension Data {
    init?(contentsOfUrlString url: String) {
        guard let urlOk = URL(string: url) else { return nil }
        try? self.init(contentsOf: urlOk)
    }
}
