//
//  CollectionTableViewCell.swift
//  Reciplease
//
//  Created by Benjamin Breton on 26/01/2021.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collection: UICollectionView!
    var informationsToDisplay: [(UIImage?, String?)] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        collection.dataSource = self
        collection.delegate = self
    }
    func setCell(_ recipe: Recipe) {
        if recipe.yield > 0 {
            informationsToDisplay.append((UIImage(named: "person"), "\(recipe.yield)"))
        }
        if recipe.totalTime > 0 {
            informationsToDisplay.append((UIImage(named: "timer"), "\(Int(recipe.totalTime))"))
        }
    }

}
extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return informationsToDisplay.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictoCell", for: indexPath) as? PictoCollectionViewCell else { return UICollectionViewCell() }
        cell.setCell(picto: informationsToDisplay[indexPath.row].0, text: informationsToDisplay[indexPath.row].1)
        return cell
    }
    
    
}
