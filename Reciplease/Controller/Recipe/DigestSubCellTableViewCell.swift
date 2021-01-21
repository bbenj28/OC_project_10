//
//  DigestSubCellTableViewCell.swift
//  Reciplease
//
//  Created by Benjamin Breton on 21/01/2021.
//

import UIKit

class DigestSubCellTableViewCell: UITableViewCell {

    @IBOutlet weak var stack: UIStackView!
    @IBOutlet var cellLabels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stack.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(details: DigestJSONStructure) {
        cellLabels[0].text = details.label
        cellLabels[1].text = "\(Int(details.total)) \(details.unit)"
        cellLabels[2].text = "\(Int(details.daily)) \(details.unit)"
    }
}
