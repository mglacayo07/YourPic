//
//  FavoritesViewController.swift
//  YourPic
//
//  Created by Maria Lacayo on 11/04/21.
//

import UIKit
import Firebase
import FirebaseRemoteConfig

class FavoritesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let storage = Storage.storage()
    var images: [StorageReference] = []
    var zoomRef: [StorageReference] = []
    
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
