//
//  ResultTableViewCell.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/01/2021.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultTitleLabel: UILabel!
    @IBOutlet weak var resultPictureView: UIImageView!
    @IBOutlet weak var resultIngredientsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        /*
        let maskPath = UIBezierPath(roundedRect: resultView.bounds,
                                    byRoundingCorners: [.bottomLeft, .bottomRight, .topLeft, .topRight],
                    cornerRadii: CGSize(width: 10.0, height: 10.0))

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        resultView.layer.mask = shape
 */
        // Initialization code
    }

    func setCell(title: String, image: UIImage?, ingredients: String) {
        resultTitleLabel.text = title
        resultPictureView.isHidden = image == nil
        if let image = image {
            resultPictureView.image = image
        }
        resultIngredientsLabel.text = ingredients
    }

}
