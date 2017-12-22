//
//  RecipesViewController.swift
//  crfintech-test
//
//  Created by MacBookPro on 12/22/17.
//  Copyright © 2017 basicdas. All rights reserved.
//

import UIKit
import CoreData

class RecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var isSearching = false
    
    var navBar = UINavigationBar(frame: CGRect.zero)
    let cellIdentifier = "RecipeCell"
    var recipeArray: [Recipe] = []

    @IBOutlet weak var recipeTableView: UITableView!
    @IBOutlet weak var recipeSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //self.navigationController?.navigationBar.topItem?.title = "Recipes"
        setNavigationBarTitleText(text: "Recipes")
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        self.recipeTableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        
        //let recipe: Recipe = Recipe(recipeName: "Egg Biryani", recipeDuration: 20)
        //print(recipe.durationString())
        
        fetchRecipes()
    }
    
    // MARK:- CoreData
    
    func fetchRecipes (keyword:String?=nil) {
        let fetchRequest: NSFetchRequest<Recipes> = Recipes.fetchRequest()
        
        if keyword != nil {
            let predicate = NSPredicate(format: "recipeName contains[c] %@", keyword!)
            fetchRequest.predicate = predicate
        }
        
        let sortDescriptor = NSSortDescriptor(key: "recipeName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let fetchResult = try DatabaseController.getContext().fetch(fetchRequest)
            //print("Number of recipes: \(fetchResult.count)")
            
            if fetchResult.count == 0 {
                let defaults = UserDefaults.standard
                defaults.set(false, forKey: "recipe_plist_parsed")
            }
            
            recipeArray.removeAll()
            
            for recipe in fetchResult as [Recipes] {
                //print("\(recipe.recipeName!) : \(String(describing: recipe.recipeDuration)) : \(recipe.image!)")
                let recipe:Recipe = Recipe(recipeName: recipe.recipeName!, recipeDuration: Int(recipe.recipeDuration), image: recipe.image!)
                recipeArray.append(recipe)
            }
            
            self.recipeTableView.reloadData()
            
            
        } catch let err as NSError {
            print("Error: \(err.localizedDescription)")
        }
    }
    
    func deleteRecipe(recipe: Recipe) {
        let fetchRequest: NSFetchRequest<Recipes> = Recipes.fetchRequest()
        
        let predicate = NSPredicate(format: "recipeName = %@ AND recipeDuration = %@ AND image = %@", argumentArray: [recipe.recipeName!, recipe.recipeDuration!, recipe.image!])
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try DatabaseController.getContext().fetch(fetchRequest)
            
            for recipe in fetchResult as [Recipes] {
                DatabaseController.getContext().delete(recipe)
            }
            
            DatabaseController.saveContext()
            fetchRecipes()
        } catch let err as NSError {
            print("Error: \(err.localizedDescription)")
        }
    }
    
    func setNavigationBarTitleText(text: String) {
        let titleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width - 120, height: 44))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.systemFont(ofSize: 17.0)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.text = text.uppercased()
        self.navBar.topItem?.titleView = titleLabel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RecipeCell
        
        let recipe:Recipe = recipeArray[indexPath.row]
        cell.recipeNameLabel.text = recipe.recipeName
        cell.durationLabel.text = recipe.durationString()
        cell.recipeImageView.image = UIImage(named: recipe.image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("remove recipe at \(indexPath.row)")
            let recipe:Recipe = self.recipeArray[indexPath.row]
            self.recipeArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
            
            deleteRecipe(recipe: recipe)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //self.recipeSearchBar.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    // MARK:- UISearchBar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //self.recipeSearchBar.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            self.view.endEditing(true)
            fetchRecipes()
        } else {
            isSearching = true
            fetchRecipes(keyword: searchText)
        }
    }
    
    
}
