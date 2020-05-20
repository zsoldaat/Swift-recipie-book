//
//  AddRecipieBrain.swift
//  mealMe
//
//  Created by Zac Soldaat on 2020-05-02.
//  Copyright © 2020 Zac Soldaat. All rights reserved.
//

import Foundation

class AddRecipieBrain {
    
    func ingredientStringtoDouble (string:String) -> Double {
        
        switch string {
            case "1/4":
                return 0.25
            case "1/2":
                return 0.5
            case "1":
                return 1
            case "2":
                return 2
            case "3":
                return 3
            case "4":
                return 4
            default:
                return 0
        }
    }
    
}
