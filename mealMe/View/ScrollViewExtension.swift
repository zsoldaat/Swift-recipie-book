//
//  ScrollViewExtension.swift
//  mealMe
//
//  Created by Zac Soldaat on 2020-05-21.
//  Copyright © 2020 Zac Soldaat. All rights reserved.
//

import UIKit

extension UIScrollView {

    func scrollToBottom(additionalOffset: CGFloat) {
        
        //This additional offset parameter is needed because the scrolling behaviour is affected by the tableview's header. The value returned should be a multiple of the table's row height. 
        
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom + additionalOffset)
        setContentOffset(bottomOffset, animated: true)
    }
}
