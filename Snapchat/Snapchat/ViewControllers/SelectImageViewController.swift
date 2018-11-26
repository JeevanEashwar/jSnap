//
//  SelectImageViewController.swift
//  Snapchat
//
//  Created by Jeevan on 21/11/18.
//  Copyright © 2018 Jeevan. All rights reserved.
//

import UIKit
import FirebaseStorage

class SelectImageViewController: LoadingIndicatorViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var imagePicker : UIImagePickerController?
    var imageHasBeenPicked = false
    var imageName : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageName = "\(NSUUID().uuidString).jpg"
        imageView.dropShadow()
        nextButton.dropShadow()
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
    }
    @IBAction func pickFromCameraClicked(_ sender: Any) {
        if imagePicker != nil {
            imagePicker!.sourceType = .camera
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    @IBAction func pickFromFilesClicked(_ sender: Any) {
        if imagePicker != nil {
            imagePicker!.sourceType = .photoLibrary
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        //FOR DEVELOPMENT PURPOSE ONLY - delete next two lines after use
        messageTextField.text = "Hi there!"
        imageHasBeenPicked = true
        
        if let message = messageTextField.text {
            if message.count > 0 && imageHasBeenPicked {
                //upload the image
                self.loadingIndicator.startAnimating()
                let imagesFolder = Storage.storage().reference().child("snapImages")
                if let image = imageView.image {
                    if let imageData = image.jpegData(compressionQuality: 0.1) {
                        imagesFolder.child(self.imageName).putData(imageData, metadata: nil) { (metaData, error) in
                            self.loadingIndicator.stopAnimating()
                            if let error = error {
                                Utils.showAlert(message: error.localizedDescription, title: "Alert!", viewController: self)
                            }else{
                                //go to next
                                self.loadingIndicator.startAnimating()
                                imagesFolder.child(self.imageName).downloadURL(completion: { (url, error) in
                                    self.loadingIndicator.stopAnimating()
                                    if let error = error {
                                        Utils.showAlert(message: error.localizedDescription, title: "Alert!", viewController: self)
                                    }else{
                                        if let downloadURL = url {
                                            self.performSegue(withIdentifier: "selectReceiverFromFriends", sender: downloadURL)
                                        }
                                    }
                                })
                                
                                
                            }
                        }
                    }
                }
                
            }else{
                Utils.showAlert(message: "Please provide an image and message for the snap", title: "Alert!",viewController: self)
            }
        }else{
            Utils.showAlert(message: "Please provide an image and message for the snap", title: "Alert!",viewController: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let downloadURL = sender as? URL {
            if let selectRecepientVC = segue.destination as? SelectReceipientTableViewController {
                selectRecepientVC.downloadURL = downloadURL.absoluteString
                selectRecepientVC.snapDescription = messageTextField.text!
                selectRecepientVC.imageName = self.imageName
            }
        }
    }
}
extension SelectImageViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            imageHasBeenPicked = true
        }
        dismiss(animated: true, completion: nil)
    }
}
