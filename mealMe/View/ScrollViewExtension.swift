//
//  ScrollViewExtension.swift
//  mealMe
//
//  Created by Zac Soldaat on 2020-05-21.
//  Copyright © 2020 Zac Soldaat. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func scrollUp(tableView: UITableView, visibleIngredients: Int = 1) {
        
        let additionalOffset = CGFloat(visibleIngredients)*tableView.rowHeight

        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom - additionalOffset)
        setContentOffset(bottomOffset, animated: true)
    }
    
    func scrollDown(tableView: UITableView, visibleIngredients: Int = 1) {
        
        let additionalOffset = CGFloat(visibleIngredients)*tableView.rowHeight
        
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom + additionalOffset)
        setContentOffset(bottomOffset, animated: true)
    }
    
    
}
