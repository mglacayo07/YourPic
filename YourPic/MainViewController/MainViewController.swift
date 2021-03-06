//
//  MainViewController.swift
//  YourPic
//
//  Created by Maria Lacayo on 10/04/21.
//

import UIKit
import Firebase
import FirebaseRemoteConfig

class MainViewController: Utility, UINavigationControllerDelegate {
       
    @IBOutlet weak var collectionView: UICollectionView!
    
    let storage = Storage.storage()
    var images: [StorageReference] = []
    var idImage: Int = 0    
    
    var pageIndex: Int = 1
    var zoomRef: [StorageReference] = []
    var indexP: [Int] = []
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let nib = UINib.init(nibName: "imageCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "imageCellIdentifier")
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        downloadImages()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let zoomView = segue.destination as? ZoomViewController
        zoomView?.ref = zoomRef
        zoomView?.main = self
    }
    
    @IBAction func logout(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let logout = UIAlertAction(title: "Cerrar Sesión", style: UIAlertAction.Style.default) { (action) in
            
            let alertController = UIAlertController(title: "Confirmación", message: "Estas apunto de cerrar tu sesión ¿Deseas continuar?", preferredStyle: .alert)
            
            let logout = UIAlertAction(title: "Si", style: UIAlertAction.Style.default) { (action) in
                do {
                    try Auth.auth().signOut()
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }catch{
                }
            }
            
            let cancel = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel) { (action) in
            }
            
            alertController.addAction(logout)
            alertController.addAction(cancel)
            
            self.present(alertController, animated: true, completion: nil)
            
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
        let name = randomString(length: 10)
        
        let imageRef = storageRef.child("yourpic").child("feed").child("\(Auth.auth().currentUser!.uid)").child("\(name)\(idImage).jpeg")
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
                self.images.append(self.storage.reference(forURL: "\(imageRef)"))
                self.collectionView.reloadData()
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
                     print("item: \(item)")
                     self.images.append(self.storage.reference(forURL: "\(item)"))
                     self.collectionView.reloadData()
                 }
                 
             }
         }
    }
    

}
