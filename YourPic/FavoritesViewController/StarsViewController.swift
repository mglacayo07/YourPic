//
//  StarsViewController.swift
//  YourPic
//
//  Created by Maria Lacayo on 11/04/21.
//

import UIKit
import Firebase
import FirebaseRemoteConfig

class StarsViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let storage = Storage.storage()
    var images: [StorageReference] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
        
        let nib = UINib.init(nibName: "imageCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "imageCellIdentifier")

        downloadImages()
    }
 
    
    func downloadImages(){
        
        let storageRef = storage.reference()
        
        let listRef = storageRef.child("yourpic/stars/\(Auth.auth().currentUser!.uid)/").listAll { (result, error) in
             if let error=error{
                 print("Error \(error)")
             }else{
                 for item in result.items {
                     self.images.append(self.storage.reference(forURL: "\(item)"))
                     self.collectionView.reloadData()
                 }
                 
             }
         }
    }
}

