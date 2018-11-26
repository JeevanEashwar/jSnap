//
//  LoadingIndicatorViewController.swift
//  Snapchat
//
//  Created by Jeevan on 21/11/18.
//  Copyright © 2018 Jeevan. All rights reserved.
//

import Foundation
import UIKit

class LoadingIndicatorViewController: UIViewController {
    public var loadingIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        self.addActivityIndicator()
    }
    func addActivityIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        var centerPoint = self.view.center
        centerPoint.x = UIScreen.main.bounds.width / 2
        loadingIndicator.center = centerPoint
        loadingIndicator.hidesWhenStopped = true
        self.view.addSubview(loadingIndicator)
    }
}
