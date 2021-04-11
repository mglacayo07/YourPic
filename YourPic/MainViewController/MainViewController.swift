//
//  MainViewController.swift
//  YourPic
//
//  Created by Maria Lacayo on 10/04/21.
//

import UIKit
import Firebase
import FirebaseStorage


class MainViewController: UIViewController, UINavigationControllerDelegate {
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let logout = UIAlertAction(title: "Cerrar Sesión", style: UIAlertAction.Style.default) { (action) in
            do {
                try Auth.auth().signOut()
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }catch{
                
            }
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel) { (action) in
            
        }
        
        actionSheet.addAction(logout)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func addImage(_ sender: Any) {
        
        let userImagePicker = UIImagePickerController()
        
        userImagePicker.delegate = self
        userImagePicker.sourceType = .photoLibrary
        userImagePicker.mediaTypes = ["public.image"]
        present(userImagePicker, animated: true, completion: nil)
    }
    
    func uploadImage(imageData: Data){
        print("Entre a uploadImage")
        //let storageRef = storage.reference()
        
    }

}


