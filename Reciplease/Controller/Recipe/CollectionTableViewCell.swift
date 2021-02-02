//
//  CollectionTableViewCell.swift
//  Reciplease
//
//  Created by Benjamin Breton on 26/01/2021.
//

import UIKit

class CollectionTableViewCell: UITableViewCell, RecipeCell {
    
    // MARK: - Properties
    
    /// Recipe to display.
    var recipe: Recipe? = nil {
        didSet {
            guard let recipe = recipe else { return }
            if recipe.yield > 0 {
                informationsToDisplay.append((UIImage(named: "person"), "\(recipe.yield)"))
            }
            if recipe.totalTime > 0 {
                informationsToDisplay.append((UIImage(named: "timer"), "\(Int(recipe.totalTime)) min."))
            }
        }
    }
    /// Selected and formated nformations to display.
    private var informationsToDisplay: [(UIImage?, String?)] = []
    
    // MARK: - Outlet
    
    /// Collection in which informations have to be displayed.
    @IBOutlet weak private var collection: UICollectionView!
    
    // MARK: - Awake from nib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collection.dataSource = self
        collection.delegate = self
    }

}
extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Collection data source and delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return informationsToDisplay.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictoCell", for: indexPath) as? PictoCollectionViewCell else { return UICollectionViewCell() }
        cell.informations = informationsToDisplay[indexPath.row]
        return cell
    }
    
    
}
