//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/01/2021.
//

import UIKit

class SearchViewController: UIViewController, RecipeGetterProtocol {
    
    // MARK: - Properties
    
    var recipeGetter: RecipeGetter?
    var ingredients: [String] = [] {
        didSet {
            searchButton.isHidden = ingredients.count == 0
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - ViewDidLoad and willAppear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchButton.isHidden = ingredients.count == 0
    }
    
    // MARK: - Ingredient modification
    
    @IBAction func addIngredient(_ sender: Any) {
        guard let name = ingredientTextField.text, !name.isEmpty else { return }
        if didAddIngredient(name) {
            ingredientTextField.text = ""
        }
    }
    @IBAction func clearIngredients(_ sender: Any) {
        ingredients = []
        tableView.reloadData()
    }
    
    // MARK: - Search
    
    @IBAction func search(_ sender: Any) {
        guard ingredients.count > 0 else {
            showAlert(title: "No ingredients", message: "You have to write at least one ingredient.", style: .alert, yesNoActions: false)
            return
        }
        performSegue(withIdentifier: "ResultsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultsSegue", let controller = segue.destination as? ResultsTableViewController {
            controller.choosenIngredients = ingredients
            controller.recipeGetter = recipeGetter
        }
    }
}

extension SearchViewController:  UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Ingredients table
    
    func didAddIngredient(_ name: String) -> Bool {
        for ingredient in ingredients {
            if ingredient == name {
                return false
            }
        }
        ingredients.insert(name, at: 0)
        tableView.reloadData()
        return true
    }

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
        label.font = UIFont(name: "Chalkduster", size: 17)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
