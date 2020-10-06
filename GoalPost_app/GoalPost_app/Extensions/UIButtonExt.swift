//
//  UIButtonExt.swift
//  GoalPost_app
//
//  Created by Camila Barros on 2020-04-21.
//  Copyright © 2020 Camila Barros. All rights reserved.
//

import UIKit

extension UIButton {
    func setSelectedColor() {
        self.backgroundColor = #colorLiteral(red: 0.4274509804, green: 0.737254902, blue: 0.3882352941, alpha: 1)
    }
    
    func setDeselectedColor() {
        self.backgroundColor = #colorLiteral(red: 0.6980392157, green: 0.8588235294, blue: 0.6862745098, alpha: 1)
    }
}
