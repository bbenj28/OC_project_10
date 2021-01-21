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
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var personsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        resultView.layer.cornerRadius = 10
        resultPictureView.layer.cornerRadius = 10
        resultPictureView.layer.maskedCorners = [.layerMinXMaxYCorner]
    }

    func setCell(title: String, image: UIImage?, persons: Int, time: Int) {
        resultTitleLabel.text = title
        resultPictureView.isHidden = image == nil
        if let image = image {
            resultPictureView.image = image
        }
        personsLabel.text = "\(persons)"
        timeLabel.text = "\(time)"
    }

}
