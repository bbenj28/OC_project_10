//
//  HomeViewController.swift
//  Reciplease
//
//  Created by Benjamin Breton on 25/01/2021.
//

import UIKit

class HomeViewController: UITabBarController {
    let recipeGetter = RecipeGetter()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let controllers = viewControllers {
            for controller in controllers {
                if var controller = controller as? RecipeGetterProtocol {
                    controller.recipeGetter = recipeGetter
                }
            }
        }
    }
}
