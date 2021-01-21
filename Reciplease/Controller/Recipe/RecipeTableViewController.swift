//
//  RecipeTableViewController.swift
//  Reciplease
//
//  Created by Benjamin Breton on 21/01/2021.
//

import UIKit

class RecipeTableViewController: UITableViewController {
    
    var recipe: RecipeService.RecipeDetails?
    var digests: [(DigestJSONStructure, Bool)] = []
    var numberOfLines: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if let recipe = recipe {
            let initialCount: Int = 5
            let digests = recipe.0.digest
            if digests.count > 0 {
                for digest in digests {
                    self.digests.append((digest, true))
                    if let subDigests = digest.sub, subDigests.count > 0 {
                        for subDigest in subDigests {
                            self.digests.append((subDigest, false))
                        }
                    }
                }
            }
            
            numberOfLines =  initialCount + self.digests.count + 2
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfLines
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath)
        if indexPath.row == 0, let recipe = recipe {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
            cell.textLabel?.text = recipe.0.title
            return cell
        }
        if indexPath.row == 1, let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell", for: indexPath) as? PictureCellTableViewCell, let recipe = recipe {
            let details = recipe.0
            let pictureData = recipe.1
            guard let data = pictureData, let image = UIImage(data: data) else {
                guard let image = UIImage(named: "meal") else { fatalError() }
                cell.setCell(details: details, picture: image)
                return cell
            }
            cell.setCell(details: details, picture: image)
            return cell
        }
        if indexPath.row == 2, let recipe = recipe {
            cell.textLabel?.text = "Ingredients:"
            cell.detailTextLabel?.text = recipe.0.ingredients.map({"- \($0)"}).joined(separator: "\n")
        }
        if indexPath.row == 3, let recipe = recipe {
            cell.textLabel?.text = "Health indications:"
            cell.detailTextLabel?.text = recipe.0.healthLabels.map({"- \($0)"}).joined(separator: "\n")
        }
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DigestTitleCell", for: indexPath)
            cell.textLabel?.text = "Digest:"
            return cell
        }
        if indexPath.row == 5 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DigestCell", for: indexPath) as? DigestCellTableViewCell {
                cell.setLegend()
                return cell
            }
        }
        if indexPath.row > 5 && indexPath.row < numberOfLines - 1 {
            let initialRow = 6
            let digest = digests[indexPath.row - initialRow].0
            let isPrincipalDigest = digests[indexPath.row - initialRow].1
            let cellName = isPrincipalDigest ? "DigestCell":"DigestSubCell"
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? DigestCellTableViewCell {
                cell.setCell(details: digest)
                return cell
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? DigestSubCellTableViewCell {
                cell.setCell(details: digest)
                return cell
            }
        }
        if indexPath.row == numberOfLines - 1 {
            return tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath)
        }
        
        // Configure the cell...
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
