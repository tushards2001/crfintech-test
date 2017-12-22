//
//  ViewController.swift
//  crfintech-test
//
//  Created by MacBookPro on 12/21/17.
//  Copyright © 2017 basicdas. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, HorizontalMenuDelegate {
    
    
    
    let menuItems: [String] = ["White", "Purple", "Red",  "Orange", "Magenta", "Cyan", "Brown", "Blue"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let yPos: CGFloat = (self.navigationController?.navigationBar.frame.origin.y)! + (self.navigationController?.navigationBar.frame.size.height)!
        let hzMenu: HorizontalMenu = HorizontalMenu(frame: CGRect(x: 0.0, y: yPos, width: self.view.frame.size.width, height: 50.0), items: self.menuItems)
        self.view.addSubview(hzMenu)
        hzMenu.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "recipe_plist_parsed") {
            print("parsed")
        } else {
            print("no defaults saved")
            readPLIST()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintAdjustmentMode = .normal
        self.navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showRecipes(_ sender: UIBarButtonItem) {
        print("showRecipes")
        self.performSegue(withIdentifier: "show_recipes", sender: nil)
    }
    
    
    func menuSelected(bgColor: UIColor) {
        self.view.backgroundColor = bgColor
    }
    
    func readPLIST() {
        print("readPLIST")
        
        var recipes: [[String: Any]] = []
        if let path = Bundle.main.path(forResource: "recipes", ofType: "plist") {
            guard let recipesPlist = NSDictionary(contentsOfFile: path) else { return }
            if let recipesArray = recipesPlist.value(forKey: "recipes") as? [Any] {
                for recipe in recipesArray{
                    let dic: [String: Any] = recipe as! [String: Any]
                    //print(dic["name"]!)
                    recipes.append(recipe as! [String : AnyObject])
                    
                    let recipesClassName:String = String(describing: Recipes.self)
                    
                    let recipes:Recipes = NSEntityDescription.insertNewObject(forEntityName: recipesClassName, into: DatabaseController.getContext()) as! Recipes
                    recipes.recipeName = String(describing: dic["name"]!)
                    recipes.recipeDuration = Int16(dic["duration"] as! String)!
                    recipes.image = String(describing: dic["image"]!)
                    
                    DatabaseController.saveContext()
                    
                    let defaults = UserDefaults.standard
                    defaults.set(true, forKey: "recipe_plist_parsed")
                }
            }
        }
    }
    
    
}



