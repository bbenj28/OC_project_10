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
    private var ingredients: [String] = [] {
        didSet {
            searchButton.isHidden = ingredients.count == 0
            trashButton.isEnabled = ingredients.count > 0
        }
    }
    /// Loaded recipes to transmit to results controller.
    private var recipes: [Recipe] = []
    /// Activity indicator used during loading.
    lazy private var activityIndicator = RecipeActivityIndicator(superview: view)
    /// Property used to know if the controller is searching, and if an activity indicator has to be shown.
    private var isSearching: Bool = false {
        didSet {
            isSearching ? exit(view: allStackView, direction: .left) : returnIdentity(allStackView)
            !isSearching ? activityIndicator.stopAnimating() : activityIndicator.animate()
        }
    }
    /// Gesture used to close keyboard.
    private var gesture: UITapGestureRecognizer?
    
    // MARK: - Outlets
    
    /// Stackview containing search form.
    @IBOutlet weak private var allStackView: UIStackView!
    /// Button used to launch a research.
    @IBOutlet weak private var searchButton: UIButton!
    /// Textfield used to enter ingredients.
    @IBOutlet weak private var ingredientTextField: UITextField!
    /// Tableview used to display choosen ingredients.
    @IBOutlet weak private var tableView: UITableView!
    /// Button used to clear ingredients.
    @IBOutlet weak private var trashButton: UIButton!
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredients = []
        tableView.tableFooterView = UIView()
        setTextfield()
        // set gesture to dismiss keyboard
        gesture = UITapGestureRecognizer(target: self, action: #selector(removeKeyboard))
    }
    private func setTextfield() {
        ingredientTextField.delegate = self
        let toolbar = setToolBarForTextField()
        ingredientTextField.inputAccessoryView = toolbar
    }
    private func setToolBarForTextField() -> UIToolbar {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(removeKeyboard))
        button.tintColor = UIColor(named: "DoneButton")
        let item = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolbar = UIToolbar()
        toolbar.items = [item, button]
        toolbar.sizeToFit()
        return toolbar
    }
    
    // MARK: - view will appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // set search button
        searchButton.isHidden = ingredients.count == 0
        // add gesture to close keyboard
        guard let gesture = gesture else { return }
        navigationController?.view.addGestureRecognizer(gesture)
    }
    
    // MARK: - view will disappear
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // remove gesture to close keyboard
        guard let gesture = gesture else { return }
        navigationController?.view.removeGestureRecognizer(gesture)
    }
}

extension SearchViewController {
    
    // MARK: - Ingredient modification
    
    /// Add ingredient choosen by user.
    @IBAction private func addIngredient(_ sender: Any) {
        guard let name = ingredientTextField.text, !name.isEmpty else { return }
        for ingredient in ingredients {
            if ingredient == name {
                return
            }
        }
        ingredients.insert(name, at: 0)
        ingredientTextField.text = ""
        tableView.reloadData()
    }
    /// Clear all ingredients from tableview.
    @IBAction private func clearIngredients(_ sender: Any) {
        ingredients = []
        tableView.reloadData()
    }
    
    // MARK: - Search
    
    /// Action to do when Search button has been hitten.
    @IBAction private func search(_ sender: Any) {
        guard ingredients.count > 0 else {
            showAlert(title: "No ingredients", message: "You have to write at least one ingredient.", style: .alert, yesNoActions: false)
            return
        }
        getRecipes()
    }
    /// Get recipes with a network call using recipe getter.
    private func getRecipes() {
        isSearching = true
        recipeGetter?.getRecipes(ingredients: ingredients, completionHandler: weakify({ (strongSelf, result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    if recipes.count == 0 {
                        strongSelf.showAlert(title: "No recipes", message: "No recipes has been found with the choosen ingredients.")
                        strongSelf.isSearching = false
                        return
                    }
                    strongSelf.recipes = recipes
                    strongSelf.isSearching = false
                    strongSelf.performSegue(withIdentifier: "ResultsSegue", sender: self)
                case .failure(let error):
                    strongSelf.isSearching = false
                    strongSelf.showAlert(error: error)
                }
            }
        }))
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

    // MARK: - Ingredients tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
            cell.textLabel?.text = "- \(ingredients[indexPath.row])"
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Add ingredients instructions
    
    /// Tableview's footer used to display instructions when tableview is empty.
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // if no ingredients have been added yet, display instructions to add ingredients
        return getInstructionsView(
            title: "no ingredients so far",
            instructions: """
            > to add ingredients:
            - enter its name in the textfield;
            - hit return on the keyboard or the plus button.
            
            > when it's done:
            - hit done or anywhere on the screen to close keyboard;
            - hit search button.
            """,
            isHidden: ingredients.count > 0)
    }
    /// Tableview's sections footer's height depending on tableview's emptyness.
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ingredients.count > 0 ? 0 : tableView.frame.height
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
