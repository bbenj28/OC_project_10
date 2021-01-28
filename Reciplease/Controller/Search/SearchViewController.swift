//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Benjamin Breton on 20/01/2021.
//

import UIKit

class SearchViewController: UIViewController, RecipeGetterProtocol {
    
    // MARK: - Properties
    
    /// Property used by other controllers to get recipes.
    var recipeGetter: RecipeGetter?
    /// Ingredients choosen by user.
    var ingredients: [String] = [] {
        didSet {
            searchButton.isHidden = ingredients.count == 0
        }
    }
    var recipes: [Recipe] = []
    var activityIndicator: RecipeActivityIndicator? {
        didSet {
            activityIndicator?.removeFromSuperview()
            guard let indicator = activityIndicator else { return }
            view.addSubview(indicator)
        }
    }
    var isSearching: Bool = false {
        didSet {
            isSearching ? exit(view: allStackView, direction: .left) : returnIdentity(allStackView)
            !isSearching ? activityIndicator?.stopAnimating() : nil
            activityIndicator?.isHidden = !isSearching
            activityIndicator = isSearching ? RecipeActivityIndicator() : nil
            isSearching ? activityIndicator?.animate() : nil
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var allStackView: UIStackView!
    /// Button used to launch a research.
    @IBOutlet weak var searchButton: UIButton!
    /// Textfield used to enter ingredients.
    @IBOutlet weak var ingredientTextField: UITextField!
    /// Tableview used to display choosen ingredients.
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - ViewDidLoad and willAppear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tableview footer
        tableView.tableFooterView = UIView()
        // textfield
        ingredientTextField.delegate = self
        // gesture to dismiss keyboard
        let gesture = UITapGestureRecognizer(target: self, action: #selector(removeKeyboard))
        view.addGestureRecognizer(gesture)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchButton.isHidden = ingredients.count == 0
    }
    
    // MARK: - Ingredient modification
    
    /// Add ingredient choosen by user.
    @IBAction func addIngredient(_ sender: Any) {
        guard let name = ingredientTextField.text, !name.isEmpty else { return }
        if didAddIngredient(name) {
            ingredientTextField.text = ""
        }
    }
    /// Clear all ingredients from tableview.
    @IBAction func clearIngredients(_ sender: Any) {
        ingredients = []
        tableView.reloadData()
    }
    
    // MARK: - Search
    
    /// Action to do when Search button has been hitten.
    @IBAction func search(_ sender: Any) {
        guard ingredients.count > 0 else {
            showAlert(title: "No ingredients", message: "You have to write at least one ingredient.", style: .alert, yesNoActions: false)
            return
        }
        isSearching = true
        recipeGetter?.getRecipes(ingredients: ingredients, completionHandler: { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    if recipes.count == 0 {
                        self.showAlert(title: "No recipes", message: "No recipes has been found with the choosen ingredients.")
                        self.isSearching = false
                        return
                    }
                    self.recipes = recipes
                    self.isSearching = false
                    self.performSegue(withIdentifier: "ResultsSegue", sender: self)
                case .failure(let error):
                    self.isSearching = false
                    self.showAlert(error: error)
                }
            }
        })
        
    }
    /// Prepare segue to transmit informations to the results controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultsSegue", let controller = segue.destination as? ResultsTableViewController {
            controller.recipeGetter = recipeGetter
            controller.recipes = recipes
        }
    }
}

extension SearchViewController:  UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Ingredients
    
    /**
     Checks if an ingredient already exists, and eventually adds it in the list.
     - parameter name: Ingredient's name to add.
     - returns: *True* if the ingredient has been added.
     */
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
    
    // MARK: - Ingredients data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
            cell.textLabel?.text = "- \(ingredients[indexPath.row])"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ingredients.count > 0 ? 0 : tableView.frame.height
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.isHidden = ingredients.count > 0
        let label = UILabel()
        label.text = "no ingredient so far"
        label.font = UIFont(name: "Chalkduster", size: 17)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let labelInstructions = UILabel()
        labelInstructions.numberOfLines = 0
        labelInstructions.font = UIFont(name: "Palatino", size: 15)
        labelInstructions.textAlignment = .center
        labelInstructions.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        labelInstructions.text = "\nto add ingredients :\n- enter its name in the textfield;\n- hit return on the keyboard\nor the plus button.\n\nwhen it's done:\n- hit return or anywhere on the screen\nto close keyboard;\nhit search button."
        
        stackview.addArrangedSubview(label)
        stackview.addArrangedSubview(labelInstructions)
        let constraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: stackview, attribute: .height, multiplier: 0.2, constant: 0)
        stackview.addConstraint(constraint)
        return stackview
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    // MARK: - Textfield
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            textField.resignFirstResponder()
            return true
        }
        addIngredient(textField)
        return true
    }
    @objc
    private func removeKeyboard() {
        ingredientTextField.resignFirstResponder()
    }
}
