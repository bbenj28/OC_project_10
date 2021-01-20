//
//  ResultsTableViewController.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/01/2021.
//

import UIKit

class ResultsTableViewController: UITableViewController {
    var choosenIngredients: [String] = []
    var recipes: [Recipe] = []
    var isSearching: Bool = false
    let service = RecipeService()
    //let service = RecipeService(session: FakeResponse.correctResponseWithData("RecipeJson").fakeSession)
    override func viewDidLoad() {
        super.viewDidLoad()
        print(recipes)
        tableView.tableFooterView = UIView()
        
        //if choosenIngredients.count > 0 {
            isSearching = true
            tableView.reloadData()
            service.searchRecipe(for: choosenIngredients) { (result) in
                DispatchQueue.main.async {
                    self.isSearching = false
                    switch result {
                    case .success(let recipes):
                        self.recipes = recipes
                        print(recipes)
                        self.tableView.reloadData()
                    case .failure(let error):
                        self.showAlert(error: error)
                        self.recipes = []
                    }
                }
            }
        //}
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return recipes.count > 0 ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = isSearching ? "searching ... please wait" : choosenIngredients.count == 0 ? "you have no ingredient in the list" : recipes.count == 0 ? "no results" : ""
        label.font = UIFont(name: "Chalkduster", size: 17)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        guard let resultCell = cell as? ResultTableViewCell else { return cell }
        let result = recipes[indexPath.row]
        guard let data = result.pictureData, let image = UIImage(data: data) else {
            resultCell.setCell(title: result.title, image: nil, persons: result.persons, time: result.time)
            return resultCell
        }
        // Configure the cell...
        resultCell.setCell(title: result.title, image: image, persons: result.persons, time: result.time)
        return resultCell
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
