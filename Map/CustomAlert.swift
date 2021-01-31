//
//  CustomAlert.swift
//  Map
//
//  Created by Alexander Romanenko on 10.09.2020.
//  Copyright © 2020 Alexander Romanenko. All rights reserved.
//

import Foundation

import UIKit

extension UIAlertController {
    
    //Set background color of UIAlertController
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
        
 
        
}

}
