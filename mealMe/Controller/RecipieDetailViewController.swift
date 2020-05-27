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
    
    let mealTypes = ["Breakfast", "Lunch", "Dinner"]
    
    @IBOutlet weak var mealType: UISegmentedControl!
    @IBOutlet weak var preferenceSlider: UISlider!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var ingredientName: UITextField!
    @IBOutlet weak var amountPickerView: UIPickerView!
    @IBOutlet weak var addButton: UIButton!
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
        
        for i in 0...2 {
            mealType.setTitle(mealTypes[i], forSegmentAt: i)
        }

        self.title = selectedRecipie!.recipieName
        mealType.selectedSegmentIndex = mealTypes.firstIndex(of: (selectedRecipie!.mealType!))!
        preferenceSlider.value = selectedRecipie!.preference
        instructionsTextView.text = selectedRecipie!.instructions
        
        ingredientName.isHidden = true
        amountPickerView.isHidden = true
        addButton.isHidden = true

    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        ingredientName.isHidden = !ingredientName.isHidden
        amountPickerView.isHidden = !amountPickerView.isHidden
        addButton.isHidden = !addButton.isHidden
    }
    
    
}

extension RecipieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipieDetailViewCell", for: indexPath)
        cell.textLabel?.text = ingredientArray?[indexPath.row].ingredientName
        cell.detailTextLabel?.text = String((ingredientArray?[indexPath.row].ammount)!)
        
        return cell
    }

}
