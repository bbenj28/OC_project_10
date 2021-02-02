//
//  PictureCellTableViewCell.swift
//  Reciplease
//
//  Created by Benjamin Breton on 21/01/2021.
//

import UIKit

class PictureCellTableViewCell: UITableViewCell, RecipeCell {
    
    // MARK: - Recipe
    
    /// Recipe to display.
    var recipe: Recipe? {
        didSet {
            guard let recipe = recipe, let data = recipe.pictureData, let image = UIImage(data: data) else {
                pictureView.image = UIImage(named: "default2")
                return
            }
            pictureView.image = image
            pictureView.layer.cornerRadius = 20
        }
    }
    
    // MARK: - Outlet
    
    @IBOutlet weak private var pictureView: UIImageView!

}
