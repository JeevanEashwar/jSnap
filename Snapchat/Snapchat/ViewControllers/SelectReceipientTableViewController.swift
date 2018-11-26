//
//  SelectReceipientTableViewController.swift
//  Snapchat
//
//  Created by Jeevan on 21/11/18.
//  Copyright © 2018 Jeevan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SelectReceipientTableViewController: UITableViewController {
    var downloadURL : String = ""
    var users : [User] = []
    var snapDescription : String = ""
    var imageName : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("users").observe(.childAdded)
        { (snapshot) in
            let user = User()
            if let userDictionary = snapshot.value as? NSDictionary {
                if let email = userDictionary["email"] as? String {
                    user.email = email
                    user.uid = snapshot.key
                    self.users.append(user)
                    self.tableView.reloadData()
                }
            }
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        cell.textLabel?.text = user.email
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        if let fromEmail = Auth.auth().currentUser?.email {
            let snap = ["from":fromEmail,"snapDescription":snapDescription,"imageURL":downloadURL, "imageName":imageName]
            Database.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
            navigationController?.popToRootViewController(animated: true)
        }
        
    }
}
