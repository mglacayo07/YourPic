//
//  ZoomViewController.swift
//  YourPic
//
//  Created by Maria Lacayo on 11/04/21.
//

import UIKit
import Firebase

class ZoomViewController: UIViewController {

    @IBOutlet weak var zoomImage: UIImageView!
    @IBOutlet weak var starButton: UIButton!
    
    let storage = Storage.storage()
    var name: String = ""
    var ref: [StorageReference] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Imagen seleccionada
        zoomImage.sd_setImage(with: ref[0], placeholderImage: UIImage(named: "notfound.png"))
        let reference = storage.reference(forURL: "\(ref[0])")
        self.name = "\(reference.name)"
        print("\(reference.name)")
        
        //Stars
        let storageRef = storage.reference()
        let imageDownloadUrlRef = storageRef.child("yourpic/stars/\(Auth.auth().currentUser!.uid)/\(reference.name)")
        
        imageDownloadUrlRef.downloadURL { (url, error) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                print("URL:  \(String(describing: url!))")
                self.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }
        }
    }
    
    @IBAction func starImage(_ sender: Any) {
        let storageRef = storage.reference()
        let imageDownloadUrlRef = storageRef.child("yourpic/stars/\(Auth.auth().currentUser!.uid)/\(name)")
        
        imageDownloadUrlRef.downloadURL { (url, error) in
            if let error = error{
                print(error.localizedDescription)
                let imageRef = storageRef.child("yourpic").child("stars").child("\(Auth.auth().currentUser!.uid)").child("\(self.name)")
               
                
                let uploadMetaData = StorageMetadata()
                uploadMetaData.contentType = "image/jpeg"
                
                let uploadImage = self.zoomImage.image?.jpegData(compressionQuality: 0.6)
       
                imageRef.putData(uploadImage!,metadata: uploadMetaData){
                    (metadata,error) in
                    if let error=error{
                        print("Error \(error)")
                    }else{
                        print("Image metadata: \(String(describing: metadata))")
                        
                    }
                }
            } else {
                print("URL:  \(String(describing: url!))")
                self.starButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }        
    }
    
}
