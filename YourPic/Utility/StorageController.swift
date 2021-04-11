//
//  Storage.swift
//  YourPic
//
//  Created by Maria Lacayo on 10/04/21.
//

import UIKit
import Firebase
import FirebaseRemoteConfig

class StorageController: UIViewController, UINavigationControllerDelegate{
    
    let storage = Storage.storage()
    
    func alert(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertDismiss(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func uploadProfileImage(imageData: Data){
        print("Entre a uploadProfileImage")
        let storageRef = storage.reference()
        let imageRef = storageRef.child("yourpic").child("profile").child("userProfile.jpeg")
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        imageRef.putData(imageData,metadata: uploadMetaData){
            (metadata,error) in
            if let error=error{
                print("Error \(error)")
            }else{
                print("Image metadata: \(String(describing: metadata))")
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

extension StorageController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let optimizedImageData = userImage.jpegData(compressionQuality: 0.6){
            uploadProfileImage(imageData: optimizedImageData)
        }
        picker.dismiss(animated: true, completion: nil)
        //optimizedImageData de la imagen que acabo de escoger vamos a comprimirla a la calidad del 60%
    }
}
