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
    
    var ingredientContainer = IngredientContainer()
    var addRecipieBrain = AddRecipieBrain()
    
    let pickerViewOptions = ["1/16", "1/8", "1/4","1/3", "1/2", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    let mealTypes = ["Breakfast", "Lunch", "Dinner"]
    var pickerViewSelectedValue: String = "1"
    
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
        pickerView.selectRow(5, inComponent: 0, animated: false)
        addIngredientsTextField.delegate = self
        
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        self.hideKeyboardWhenTappedAround()
        
        setMealTypeLabels()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        instructionsTextView.layer.borderWidth = 0.5
        instructionsTextView.layer.borderColor = UIColor.gray.cgColor
        instructionsTextView.layer.cornerRadius = 5.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Locks the instructionsTextView to it's size upon loading
        let currentHeight = instructionsTextView.frame.height
        instructionsTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: currentHeight).isActive = true
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        addIngredientToTable()
    }
    
    
    @IBAction func doneButton(_ sender: UIButton) {
        if ingredientContainer.hasIngredients && recipeNameTextField.text != ""{
            let newRecipie = Recipie()
            newRecipie.recipieName = recipeNameTextField.text!
            newRecipie.mealType = mealTypes[mealType.selectedSegmentIndex]
            newRecipie.preference = preferenceSlider.value
            newRecipie.instructions = instructionsTextView.text ?? ""
            
            for ingredient in ingredientContainer.getIngredients() {
                newRecipie.ingredients.append(ingredient)
            }
            
            do {
                try realm.write {
                    realm.add(newRecipie)
                }
            } catch {
                print("Error writing data to local storage: \(error)")
            }
            
            navigationController?.popViewController(animated: true)
            
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
    
    func setMealTypeLabels() {
        for i in 0...2 {
            mealType.setTitle(mealTypes[i], forSegmentAt: i)
        }
    }
    
    func addIngredientToTable() {
        if addIngredientsTextField.text != "" {
            
            let newIngredient = Ingredient()
            newIngredient.ingredientName = addIngredientsTextField.text!
            newIngredient.ammount = addRecipieBrain.ingredientStringtoDouble(string: pickerViewSelectedValue)
            
            pickerView.selectRow(pickerViewOptions.firstIndex(of: "1")!, inComponent: 0, animated: true)
            pickerViewSelectedValue = "1"
            
            if ingredientContainer.isOpen {
                scrollView.scrollDown(tableView: ingredientTableView)
            }
            ingredientContainer.addIngredient(newIngredient)
            
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
        if ingredientContainer.isOpen {
            scrollView.scrollUp(tableView: ingredientTableView, visibleIngredients: ingredientContainer.ingredientArray.count)
            self.ingredientContainer.close()

        } else if !ingredientContainer.isOpen{
            ingredientContainer.open()
            //reload data here so scrollDown has accurate info to work with
            ingredientTableView.reloadData()
            scrollView.scrollDown(tableView: ingredientTableView, visibleIngredients: ingredientContainer.ingredientArray.count)
        }
        
        //The 0.25 is to wait for the closing animation before abruptly changing the tableview size. Could be reworked
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            self.updateTableViewSize()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientContainer.ingredientArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddRecipieCell", for: indexPath)
        
        cell.textLabel?.text = ingredientContainer.ingredientArray[indexPath.row].ingredientName
        cell.detailTextLabel?.text = String(Int(ingredientContainer.ingredientArray[indexPath.row].ammount))
        
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

