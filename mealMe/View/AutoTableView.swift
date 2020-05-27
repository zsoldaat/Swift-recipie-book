//
//  AutoTableView.swift
//  mealMe
//
//  Created by Zac Soldaat on 2020-05-21.
//  Copyright © 2020 Zac Soldaat. All rights reserved.
//

import UIKit

class AutoTableView: UITableView {
  var maxHeight: CGFloat = UIScreen.main.bounds.size.height
  
  override func reloadData() {
    super.reloadData()
    self.invalidateIntrinsicContentSize()
    self.layoutIfNeeded()
  }
  
  override var intrinsicContentSize: CGSize {
    let height = min(contentSize.height, maxHeight)
    return CGSize(width: contentSize.width, height: height)
  }
}
