//
//  MainViewController+ImagePicker.swift
//  YourPic
//
//  Created by Maria Lacayo on 10/04/21.
//

import UIKit

extension MainViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let optimizedImageData = userImage.jpegData(compressionQuality: 0.6){
            uploadImage(imageData: optimizedImageData)
        }
        picker.dismiss(animated: true, completion: nil)
        //optimizedImageData de la imagen que acabo de escoger vamos a comprimirla a la calidad del 60%
    }
}

