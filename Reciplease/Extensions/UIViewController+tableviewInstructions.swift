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
        // main stack view
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.isHidden = isHidden
        // title label
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "Chalkduster", size: 17)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        // instructions stack view
        let instructionsStackview = UIStackView()
        instructionsStackview.axis = .horizontal
        instructionsStackview.distribution = .fill
        let emptyInstructionsView = UIView()
        let labelInstructions = UILabel()
        labelInstructions.numberOfLines = 0
        labelInstructions.font = UIFont(name: "Palatino", size: 15)
        labelInstructions.textAlignment = .left
        labelInstructions.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        labelInstructions.text = "\n \(instructions.joined(separator: "\n")) \n"
        instructionsStackview.addArrangedSubview(emptyInstructionsView)
        instructionsStackview.addArrangedSubview(labelInstructions)
        let emptyConstraint = NSLayoutConstraint(item: emptyInstructionsView, attribute: .width, relatedBy: .equal, toItem: instructionsStackview, attribute: .width, multiplier: 0.1, constant: 0)
        instructionsStackview.addConstraint(emptyConstraint)
        // stick all together
        let emptyTopView = UIView()
        let emptyBottomView = UIView()
        stackview.addArrangedSubview(emptyTopView)
        stackview.addArrangedSubview(label)
        stackview.addArrangedSubview(instructionsStackview)
        stackview.addArrangedSubview(emptyBottomView)
        let titleConstraint = NSLayoutConstraint(item: emptyTopView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: stackview, attribute: .height, multiplier: 0.05, constant: 0)
        stackview.addConstraint(titleConstraint)
        return stackview
    }
}
