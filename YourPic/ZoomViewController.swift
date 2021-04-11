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
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var main: MainViewController?
    
    let storage = Storage.storage()
    var name: String = ""
    var ref: [StorageReference] = []
    var started: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.main?.indexP == nil){
            print("Vengo de favorite")
            deleteButton.isEnabled = false
       }
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
                
                self.started = true
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
                        self.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                        self.started = true
                    }
                }
            } else {
                print("URL:  \(String(describing: url!))")
                self.started = false
                self.starButton.setImage(UIImage(systemName: "star"), for: .normal)
                
            }
        }        
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Alerta", message: "¿Seguro que desea eliminar la imagen?", preferredStyle: .alert)
        
        let logout = UIAlertAction(title: "Si", style: UIAlertAction.Style.default) { (action) in
            self.deleteImage()
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel) { (action) in
        }
        
        alertController.addAction(logout)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteImage(){
        print("DEBERIA BORRAR")
        
        let storageRef = storage.reference()
        
        if(started){
            let startedDownloadUrlRef = storageRef.child("yourpic/stars/\(Auth.auth().currentUser!.uid)/\(name)")
            startedDownloadUrlRef.delete { error in
              if let error = error {
                print("Error startedDownloadUrlRef \(error)")
              }
            }
        }
        
        let imageDownloadUrlRef = storageRef.child("yourpic/feed/\(Auth.auth().currentUser!.uid)/\(name)")
        imageDownloadUrlRef.delete { error in
          if let error = error {
            print("Error imageDownloadUrlRef \(error)")
          }else{
            if(self.main?.idImage != nil){
                print("Vengo de main")
                self.main?.images.remove(at: (self.main?.indexP[0])!)
                self.main?.collectionView.reloadData()
            }
            
          }
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
}
