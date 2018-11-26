//
//  Utils.swift
//  Snapchat
//
//  Created by Jeevan on 21/11/18.
//  Copyright © 2018 Jeevan. All rights reserved.
//

import Foundation
import UIKit
class Utils {
    static func showAlert(message:String,title:String,viewController:UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
}
