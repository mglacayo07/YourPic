//
//  MainVireController+CollectionView.swift
//  YourPic
//
//  Created by Maria Lacayo on 10/04/21.
//

import UIKit

extension MainViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("IMAGES \(images.count)")
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCellIdentifier", for: indexPath) as! imageCollectionViewCell
        
        let ref = images[indexPath.item]
        
        cell.imageView.sd_setImage(with: ref, placeholderImage: UIImage(named: "notfound.png"))
        
        ref.downloadURL { (url, error) in
            if let error=error{
                print("Error \(error)")
            }else{
                print("URL \(url)")
            }
        }
        return cell
    }
    
}

extension MainViewController: UICollectionViewDelegate{
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
