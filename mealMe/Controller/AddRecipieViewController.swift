//
//  AddRecipieViewController.swift
//  mealMe
//
//  Created by Zac Soldaat on 2020-04-30.
//  Copyright © 2020 Zac Soldaat. All rights reserved.
//

import UIKit
import RealmSwift

class AddRecipieViewController: UIViewController {
    
    let realm = try! Realm()
    
    var newRecipie: Recipie?
    var ingredientArray = [Ingredient]()
    var addRecipieBrain = AddRecipieBrain()
    
    let pickerViewOptions = ["1/4", "1/2", "1", "2", "3", "4"]
    var pickerViewSelectedValue: String = "1"
    
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var addIngredientsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientTableView.dataSource = self
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(2, inComponent: 0, animated: false)
        
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addButton(_ sender: UIButton) {
        if addIngredientsTextField.text != "" {
            
            let newIngredient = Ingredient()
            newIngredient.ingredientName = addIngredientsTextField.text!
            newIngredient.ammount = addRecipieBrain.ingredientStringtoDouble(string: pickerViewSelectedValue)
            
            pickerView.selectRow(2, inComponent: 0, animated: true)
            pickerViewSelectedValue = "1"
            
            ingredientArray.append(newIngredient)
        }
        
        addIngredientsTextField.text = ""
        
        ingredientTableView.reloadData()
        
    }
    
    
    @IBAction func doneButton(_ sender: UIButton) {
        if ingredientArray.count > 0 {
            if let safeRecipieName = recipeNameTextField.text {
                newRecipie = Recipie()
                newRecipie?.recipieName = safeRecipieName
                
                for ingredient in ingredientArray {
                    newRecipie?.ingredients.append(ingredient)
                }

                if let safeInstructions = instructionsTextView.text {
                    newRecipie?.instructions = safeInstructions
                }
                
                navigationController?.popViewController(animated: true)
                
                do {
                    try realm.write {
                        realm.add(newRecipie!)
                    }
                } catch {
                    
                }
            }
        }
    }
}

extension AddRecipieViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddRecipieCell", for: indexPath)
        
        cell.textLabel?.text = ingredientArray[indexPath.row].ingredientName
        cell.detailTextLabel?.text = String(ingredientArray[indexPath.row].ammount)
        
        return cell
    }
}

extension AddRecipieViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    //DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerViewOptions.count
    }
    
    //Delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerViewSelectedValue = pickerViewOptions[row]
    }
}

extension AddRecipieViewController {
    
    func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(AddRecipieViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
}
