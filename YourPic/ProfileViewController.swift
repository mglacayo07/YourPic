//
//  ProfileViewController.swift
//  YourPic
//
//  Created by Maria Lacayo on 10/04/21.
//

import UIKit
import Firebase
import FirebaseUI

class ProfileViewController: Utility, UINavigationControllerDelegate{

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var picCouter: UILabel!
    @IBOutlet weak var starCounter: UILabel!
    
    let storage = Storage.storage()
    var profilePicName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ENTR")
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
        listRef = storageRef.child("yourpic/profile/\(Auth.auth().currentUser!.uid)/").listAll { (result, error) in
            if let error=error{
                print("Error \(error)")
            }else{
                if(result.items.count > 0){
                    self.profilePicName = "\(result.items[0].name)"
                    print("NAME: \(self.profilePicName)")
                    self.downloadProfileImage()
                }else{
                    self.profilePicName = ""
                }
            }
        }
        
    }
    
    @IBAction func updateImageProfile(_ sender: Any) {
        openGallery()
    }
        
    func downloadProfileImage(){
        print("downloadProfileImage")
        let storageRef = storage.reference()
        let imageDownloadUrlRef = storageRef.child("yourpic/profile/\(Auth.auth().currentUser!.uid)/\(profilePicName)")
        print(imageDownloadUrlRef)
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
        let newName = self.randomString(length: 5)
        let imageRef = storageRef.child("yourpic").child("profile").child("\(Auth.auth().currentUser!.uid)").child("\(newName).jpeg")
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        imageRef.putData(imageData,metadata: uploadMetaData){
            (metadata,error) in
            if let error=error{
                print("Error \(error)")
            }else{
                DispatchQueue.main.async {
                    //self.profileImage.sd_setImage(with: imageRef, placeholderImage: UIImage(named: "notfound.png"))
                    self.profileImage.image = UIImage(data: imageData)
                }
            }
        }
        
        if (profilePicName != ""){
            let startedDownloadUrlRef = storageRef.child("yourpic/profile/\(Auth.auth().currentUser!.uid)/\(profilePicName)")
            startedDownloadUrlRef.delete { error in
              if let error = error {
                print("Error startedDownloadUrlRef \(error)")
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
