//
//  SnapsTableViewController.swift
//  Snapchat
//
//  Created by Jeevan on 21/11/18.
//  Copyright © 2018 Jeevan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapsTableViewController: UITableViewController {
    var snaps : [DataSnapshot] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentUserId = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(currentUserId).child("snaps").observe(.childAdded) { (snapshot) in
                self.snaps.append(snapshot)
                self.tableView.reloadData()
            }
            Database.database().reference().child("users").child(currentUserId).child("snaps").observe(.childRemoved) { (snapshot) in
                var index = 0
                for snap in self.snaps {
                    if snap.key == snapshot.key {
                        self.snaps.remove(at: index)
                    }
                    index += 1
                }
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return snaps.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        // Configure the cell...
        let snap = snaps[indexPath.row]
        if let snapDictionary = snap.value as? NSDictionary {
            if let fromEmail = snapDictionary["from"] as? String {
                cell.textLabel?.text = fromEmail
            }else{
                cell.textLabel?.text = ""
            }
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "viewSnapSegue", sender: snap)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSnapSegue" {
            if let viewSnapVC = segue.destination as? ViewSnapViewController {
                if let snap = sender as? DataSnapshot {
                    viewSnapVC.snap = snap
                }
            }
        }
    }
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        }
        catch  {
            Utils.showAlert(message: error.localizedDescription, title: "Alert!", viewController: self)
        }
    }
}
