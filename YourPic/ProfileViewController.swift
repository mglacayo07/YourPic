//
//  ProfileViewController.swift
//  YourPic
//
//  Created by Maria Lacayo on 10/04/21.
//

import UIKit
import Firebase
import FirebaseUI

class ProfileViewController: UIViewController, UINavigationControllerDelegate{

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var picCouter: UILabel!
    @IBOutlet weak var starCounter: UILabel!
    
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userEmail.text = Auth.auth().currentUser?.email
        let storageRef = storage.reference()
        var listRef = storageRef.child("yourpic/feed/\(Auth.auth().currentUser!.uid)/").listAll { (result, error) in
            if let error=error{
                print("Error \(error)")
            }else{
                self.picCouter.text = "\(result.items.count)"
            }
        }
        listRef = storageRef.child("yourpic/stars/\(Auth.auth().currentUser!.uid)/").listAll { (result, error) in
            if let error=error{
                print("Error \(error)")
            }else{
                self.starCounter.text = "\(result.items.count)"
            }
        }
        downloadProfileImage()
    }
    
    @IBAction func updateImageProfile(_ sender: Any) {
        openGallery()
    }
        
    func downloadProfileImage(){
        
        let storageRef = storage.reference()
        let imageDownloadUrlRef = storageRef.child("yourpic/profile/userProfile.jpeg")
        
        profileImage.sd_setImage(with: imageDownloadUrlRef, placeholderImage: UIImage(named: "notfound.png"))
        
        imageDownloadUrlRef.downloadURL { (url, error) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                print("URL:  \(String(describing: url!))")
            }
        }
    }
    
    func uploadProfileImage(imageData: Data){
        let storageRef = storage.reference()
        let imageRef = storageRef.child("yourpic").child("profile").child("userProfile.jpeg")
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        imageRef.putData(imageData,metadata: uploadMetaData){
            (metadata,error) in
            if let error=error{
                print("Error \(error)")
            }else{
                DispatchQueue.main.async {
                    self.downloadProfileImage()
                }
            }
        }
    }
    
    func openGallery(){
        let userImagePicker = UIImagePickerController()
        userImagePicker.delegate = self
        userImagePicker.sourceType = .photoLibrary
        userImagePicker.mediaTypes = ["public.image"]
        present(userImagePicker, animated: true, completion: nil)
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let optimizedImageData = userImage.jpegData(compressionQuality: 0.6){
            
            uploadProfileImage(imageData: optimizedImageData)
        }
        picker.dismiss(animated: true, completion: nil)
        //optimizedImageData de la imagen que acabo de escoger vamos a comprimirla a la calidad del 60%
    }
}
