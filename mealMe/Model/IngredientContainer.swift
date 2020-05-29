//
//  IngredientContainer.swift
//  mealMe
//
//  Created by Zac Soldaat on 2020-05-27.
//  Copyright © 2020 Zac Soldaat. All rights reserved.
//

import Foundation

class IngredientContainer {
    
    var ingredientArray = [Ingredient]()
    var hiddenIngredientArray = [Ingredient]()
    
    var isOpen = true
    
    var hasIngredients: Bool = false
    
    func addIngredient(_ ingredient: Ingredient) {
        if self.isOpen {
            ingredientArray.append(ingredient)
        } else {
            hiddenIngredientArray.append(ingredient)
        }
        
        hasIngredients = true
    }
    
    func getIngredients() -> [Ingredient] {
        if self.isOpen {
            return ingredientArray
        } else {
            return hiddenIngredientArray
        }
    }
    
    func close() {
        self.hiddenIngredientArray = self.ingredientArray
        self.ingredientArray.removeAll()
        
        self.isOpen = false

    }
    
    func open() {
        ingredientArray = hiddenIngredientArray
        hiddenIngredientArray.removeAll()
        
        isOpen = true
    }
    
    
}
