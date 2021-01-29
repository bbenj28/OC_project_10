//
//  UIViewController+tableviewInstructions.swift
//  Reciplease
//
//  Created by Benjamin Breton on 29/01/2021.
//

import Foundation
import UIKit
extension UIViewController {
    func getInstructionsView(title: String, instructions: [String], isHidden: Bool) -> UIView {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.isHidden = isHidden
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "Chalkduster", size: 17)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let labelInstructions = UILabel()
        labelInstructions.numberOfLines = 0
        labelInstructions.font = UIFont(name: "Palatino", size: 15)
        labelInstructions.textAlignment = .left
        labelInstructions.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        labelInstructions.text = "\n \(instructions.joined(separator: "\n")) \n"
        stackview.addArrangedSubview(label)
        stackview.addArrangedSubview(labelInstructions)
        let constraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: stackview, attribute: .height, multiplier: 0.2, constant: 0)
        stackview.addConstraint(constraint)
        return stackview
    }
}
