//
//  RecipeActivityIndicator.swift
//  Reciplease
//
//  Created by Benjamin Breton on 21/01/2021.
//

import UIKit

class RecipeActivityIndicator: UIImageView {
    enum Operation {
        case add, substract
        mutating func changeValue(_ step: Int) -> Int {
            switch self {
            case .add:
                if step + 1 == 6 {
                    self = .substract
                    return 4
                } else {
                    return step + 1
                }
            case .substract:
                if step - 1 == 0 {
                    self = .add
                    return 2
                } else {
                    return step - 1
                }
            }
        }
    }
    var operation: Operation = .add
    var step: Int = 1 {
        didSet {
            image = UIImage(named: "wait\(step)")
            layer.cornerRadius = frame.height / 2
            clipsToBounds = true
        }
    }
    var timer: Timer?
    func animate() {
        timer = Timer.scheduledTimer(timeInterval: 1/10, target: self, selector: #selector(changePicture), userInfo: nil, repeats: true)
    }
    override func stopAnimating() {
        timer?.invalidate()
        timer = nil
    }
    @objc
    private func changePicture() { step = operation.changeValue(step) }

}
