//
//  Alert.swift
//  BitCoin_App
//
//  Created by Camila Barros on 2020-03-20.
//  Copyright © 2020 Camila Barros. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    
    static func showBasicAlert(on vc: UIViewController, with title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {vc.present(alert, animated: true)}
    }
}
