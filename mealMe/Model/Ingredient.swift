//
//  Ingredient.swift
//  mealMe
//
//  Created by Zac Soldaat on 2020-05-04.
//  Copyright © 2020 Zac Soldaat. All rights reserved.
//

import Foundation
import RealmSwift

class Ingredient: Object {
    @objc dynamic var ingredientName: String = ""
    @objc dynamic var ammount: Double = 1
    
    let parentRecipie = LinkingObjects(fromType: Recipie.self, property: "ingredients")
}
