//
//  MainViewController.swift
//  YourPic
//
//  Created by Maria Lacayo on 10/04/21.
//

import UIKit
import Firebase
import FirebaseRemoteConfig

class MainViewController: UIViewController, UINavigationControllerDelegate {
       
    @IBOutlet weak var collectionView: UICollectionView!
    
    let storage = Storage.storage()
    var images: [StorageReference] = []
    var idImage: Int = 0
    
    var pageIndex: Int = 1
    var zoomRef: [StorageReference] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let nib = UINib.init(nibName: "imageCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "imageCellIdentifier")

        downloadImages()
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
        
        let activityIndicator = UIActivityIndicatorView.init(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        let storageRef = storage.reference()
        
        let imageRef = storageRef.child("yourpic").child("feed").child("\(Auth.auth().currentUser!.uid)").child("\(idImage).jpeg")
        idImage+=1
        print("idImage: \(idImage)")
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        imageRef.putData(imageData,metadata: uploadMetaData){
            (metadata,error) in
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            if let error=error{
                print("Error \(error)")
            }else{
                print("Image metadata: \(String(describing: metadata))")
                //self.collectionView.reloadData()
            }
        }
        
    }
    
    func downloadImages(){
        
        let storageRef = storage.reference()
        
        let listRef = storageRef.child("yourpic/feed/\(Auth.auth().currentUser!.uid)/").listAll { (result, error) in
             if let error=error{
                 print("Error \(error)")
             }else{
                 self.idImage = result.items.count
                 for item in result.items {
                     self.images.append(self.storage.reference(forURL: "\(item)"))
                     self.collectionView.reloadData()
                 }
                 
             }
         }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let zoomView = segue.destination as! ZoomViewController
        zoomView.ref = zoomRef
        
    }
}
