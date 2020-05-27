//
//  AddRecipieViewController.swift
//  mealMe
//
//  Created by Zac Soldaat on 2020-04-30.
//  Copyright © 2020 Zac Soldaat. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import IQKeyboardManager

class AddRecipieViewController: UIViewController{
    
    let realm = try! Realm()
    
    var newRecipie: Recipie?
    var ingredientArray = [Ingredient]()
    var hiddenIngredientArray = [Ingredient]()
    var addRecipieBrain = AddRecipieBrain()
    
    let pickerViewOptions = ["1/4","1/3", "1/2", "1", "2", "3", "4"]
    let mealTypes = ["Breakfast", "Lunch", "Dinner"]
    var pickerViewSelectedValue: String = "1"
    
    var ingredientsTableIsOpen = true
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var ingredientTableViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var preferenceSlider: UISlider!
    @IBOutlet weak var mealType: UISegmentedControl!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var addIngredientsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientTableView.dataSource = self
        ingredientTableView.delegate = self
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(3, inComponent: 0, animated: false)
        addIngredientsTextField.delegate = self
        
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        self.hideKeyboardWhenTappedAround()
        
        for i in 0...2 {
            mealType.setTitle(mealTypes[i], forSegmentAt: i)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        instructionsTextView.layer.borderWidth = 0.5
        instructionsTextView.layer.borderColor = UIColor.gray.cgColor
        instructionsTextView.layer.cornerRadius = 5.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentHeight = instructionsTextView.frame.height
        instructionsTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: currentHeight).isActive = true
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        addIngredientToTable()
    }
    
    
    @IBAction func doneButton(_ sender: UIButton) {
        if (ingredientArray.count > 0 || hiddenIngredientArray.count > 0) && recipeNameTextField.text != ""{
            if let safeRecipieName = recipeNameTextField.text {
                newRecipie = Recipie()
                newRecipie?.recipieName = safeRecipieName
                newRecipie?.mealType = mealTypes[mealType.selectedSegmentIndex]
                newRecipie?.preference = preferenceSlider.value
                
                
                if ingredientsTableIsOpen == false {
                    ingredientArray = hiddenIngredientArray
                }
                
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
        } else {
            let alert = UIAlertController(title: "Make sure your recipie has ingredients and a name.", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(action)
            present(alert, animated: true)
        }
        
    }
    
    
    
    
    func updateTableViewSize() {
        DispatchQueue.main.async {
            self.ingredientTableViewHeightContraint.constant = self.ingredientTableView.contentSize.height
            self.view.layoutIfNeeded()
        }
        ingredientTableView.reloadData()
    }
    
    func addIngredientToTable() {
        if addIngredientsTextField.text != "" {
            
            let newIngredient = Ingredient()
            newIngredient.ingredientName = addIngredientsTextField.text!
            newIngredient.ammount = addRecipieBrain.ingredientStringtoDouble(string: pickerViewSelectedValue)
            
            pickerView.selectRow(3, inComponent: 0, animated: true)
            pickerViewSelectedValue = "1"

            if ingredientsTableIsOpen == true {
                ingredientArray.append(newIngredient)
                scrollView.scrollToBottom(additionalOffset: ingredientTableView.rowHeight)
            } else {
                hiddenIngredientArray.append(newIngredient)
            }
            
            addIngredientsTextField.text = ""
            updateTableViewSize()
            
        } else {
            let alert = UIAlertController(title: "Add a name for your ingredient.", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(action)
            present(alert, animated: true)
        }

    }
}

//MARK: - TableView DataSource/DelegateMethods
extension AddRecipieViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let button = UIButton(type: .system)
        button.setTitle("Ingredients", for: .normal)
        button.backgroundColor = UIColor.red
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(openClose), for: .touchUpInside)
        
        return button
    }
    
    
    @objc func openClose() {
        if ingredientsTableIsOpen == true {
            
            scrollView.scrollToBottom(additionalOffset: -(CGFloat(ingredientArray.count*50)))
            self.hiddenIngredientArray = self.ingredientArray
            self.ingredientArray.removeAll()
            
        } else if ingredientsTableIsOpen == false {
            ingredientArray = hiddenIngredientArray
            hiddenIngredientArray.removeAll()
            scrollView.scrollToBottom(additionalOffset:CGFloat(ingredientArray.count)*ingredientTableView.rowHeight)
            self.updateTableViewSize()
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            self.updateTableViewSize()
        }
        ingredientsTableIsOpen = !ingredientsTableIsOpen

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
//MARK: - PickerView DataSource/Delegate Methods
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

//MARK: - AddIngredientTextfield Delegate Methods
extension AddRecipieViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addIngredientToTable()
        return true
    }
}


//MARK: - Dismiss Keyboard methods
extension AddRecipieViewController: UIGestureRecognizerDelegate {
    
    func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(AddRecipieViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
}

