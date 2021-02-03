//
//  RecipeActivityIndicator.swift
//  Reciplease
//
//  Created by Benjamin Breton on 21/01/2021.
//

import UIKit

class RecipeActivityIndicator: UIImageView {
    
    // MARK: - Operation
    
    /// Operation to do to substitute pictures.
    private enum Operation {
        case add, subtract
        /// Value to increase to step to modify picture, depending on operation's type.
        var valueToIncrease: Int { self == .add ? 1 : -1 }
        /// Max value of step depending on operation's type.
        var maxValue: Int { self == .add ? 5 : 1 }
        /// Change value of the step depending on operation's type.
        mutating func changeValue(_ step: Int) -> Int {
            step == maxValue ? changeSelf() : nil
            return step + valueToIncrease
        }
        mutating private func changeSelf() {
            self = self == .add ? .subtract : .add
        }
    }
    
    // MARK: - Properties
    
    /// Current operation used to change step's value.
    private var operation: Operation = .add
    /// Property used to substitute pictures.
    private var step: Int = 1 {
        didSet {
            setImage()
        }
    }
    /// Timer used to animate pictures.
    private var timer: Timer?
    
    // MARK: - Init
    
    /// Init activity indicator.
    /// - parameter superview: View in which the indicator has to be inserted.
    init(superview: UIView) {
        super.init(image: UIImage(named: "wait1"))
        isHidden = true
        superview.addSubview(self)
        let width = superview.frame.width
        let height = superview.frame.height
        frame.size = CGSize(width: width / 4, height: width / 4)
        frame.origin = CGPoint(x: width / 2 - width / 8, y: height / 2 - width / 8)
        setImage()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Animation
    
    /// Method used to animate.
    func animate() {
        isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 1/10, target: self, selector: #selector(changePicture), userInfo: nil, repeats: true)
    }
    /// Method used to stop animating.
    override func stopAnimating() {
        isHidden = true
        timer?.invalidate()
        timer = nil
    }
    private func setImage() {
        image = UIImage(named: "wait\(step)")
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
    @objc
    private func changePicture() { step = operation.changeValue(step) }

}
