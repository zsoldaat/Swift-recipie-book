//
//  RecipleDetailViewController.swift
//  mealMe
//
//  Created by Zac Soldaat on 2020-04-29.
//  Copyright © 2020 Zac Soldaat. All rights reserved.
//

import UIKit
import RealmSwift

class RecipieDetailViewController: UIViewController {
    
    let realm = try! Realm()
    var ingredientArray: Results<Ingredient>?
    
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var ingredientTableView: UITableView!
    
    var selectedRecipie: Recipie? {
        didSet {
            ingredientArray = selectedRecipie?.ingredients.sorted(byKeyPath: "ingredientName", ascending: true)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self

        self.title = selectedRecipie?.recipieName
        instructionsTextView.text = selectedRecipie?.instructions

        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
}

extension RecipieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipieDetailViewCell", for: indexPath)
        cell.textLabel?.text = ingredientArray?[indexPath.row].ingredientName ?? ""
        cell.detailTextLabel?.text = String(ingredientArray?[indexPath.row].ammount ?? 0)
        
        return cell
    }

}
