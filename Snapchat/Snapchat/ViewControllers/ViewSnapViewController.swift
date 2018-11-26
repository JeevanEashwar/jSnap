//
//  ViewSnapViewController.swift
//  Snapchat
//
//  Created by Jeevan on 21/11/18.
//  Copyright © 2018 Jeevan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ViewSnapViewController: LoadingIndicatorViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var snapDescription: UILabel!
    var snap : DataSnapshot?
    var imageName : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.dropShadow()
        if let snap = snap {
            if let snapDictionary = snap.value as? NSDictionary {
                if let imageURL = snapDictionary["imageURL"] as? String {
                    if let url = URL(string: imageURL) {
                        imageView.downloadedFrom(url: url, contentMode: .scaleAspectFit)
                    }
                }
                if let snapDescription = snapDictionary["snapDescription"] as? String {
                    self.snapDescription.text = snapDescription
                }
                if let imageName = snapDictionary["imageName"] as? String {
                    self.imageName = imageName
                }
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let currentUserUid = Auth.auth().currentUser?.uid {
            if let key = snap?.key {
                Database.database().reference().child("users").child(currentUserUid).child("snaps").child(key).removeValue()
                Storage.storage().reference().child("snapImages").child(self.imageName).delete(completion: nil)
            }
            
        }
    }
}
