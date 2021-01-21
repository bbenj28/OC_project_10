//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/01/2021.
//

import UIKit

class SearchViewController: UIViewController {
    var ingredients: [String] = []
    var useFakeSession: Bool = false
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func addIngredient(_ sender: Any) {
        guard let name = ingredientTextField.text, !name.isEmpty else { return }
        if addIngredient(name) {
            ingredientTextField.text = ""
        }
    }
    @IBAction func clearIngredients(_ sender: Any) {
        clearIngredients()
    }
    @IBAction func search(_ sender: Any) {
        if !useFakeSession {
            guard ingredients.count > 0 else {
                showAlert(title: "No ingredients", message: "You have to write at least one ingredient.", style: .alert, yesNoActions: false)
                return
            }
        }
        performSegue(withIdentifier: "ResultsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultsSegue", let controller = segue.destination as? ResultsTableViewController {
            controller.choosenIngredients = ingredients
            controller.useFakeSession = useFakeSession
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchViewController:  UITableViewDataSource, UITableViewDelegate {

    
    func addIngredient(_ name: String) -> Bool {
        for ingredient in ingredients {
            if ingredient == name {
                return false
            }
        }
        ingredients.insert(name, at: 0)
        tableView.reloadData()
        return true
    }
    func clearIngredients() {
        ingredients = []
        tableView.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ingredients.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
            cell.textLabel?.text = "- \(ingredients[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = ingredients.count == 0 ?"you have no ingredient so far" : ""
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

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
