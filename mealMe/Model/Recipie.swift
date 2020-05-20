//
//  Recipie.swift
//  mealMe
//
//  Created by Zac Soldaat on 2020-05-04.
//  Copyright © 2020 Zac Soldaat. All rights reserved.
//

import Foundation
import RealmSwift

class Recipie: Object {
    @objc dynamic var recipieName: String = ""
    @objc dynamic var instructions: String? = nil
    
    let ingredients = List<Ingredient>()
    
}
