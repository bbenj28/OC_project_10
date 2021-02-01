//
//  HomeViewController.swift
//  Reciplease
//
//  Created by Benjamin Breton on 25/01/2021.
//

import UIKit

class HomeViewController: UITabBarController {
    /// Property used by other controllers to get recipes.
    private let recipeGetter = RecipeGetter()
    override func viewDidLoad() {
        super.viewDidLoad()
        // recipegetter transmission
        if let controllers = viewControllers {
            for controller in controllers {
                if var controller = controller as? RecipeGetterProtocol {
                    controller.recipeGetter = recipeGetter
                }
            }
        }
    }
}
