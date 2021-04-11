//
//  FavoritesViewController+CollectionView.swift
//  YourPic
//
//  Created by Maria Lacayo on 11/04/21.
//

import UIKit

extension FavoritesViewController: UICollectionViewDataSource{
    
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
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.zoomRef.removeAll()
        self.zoomRef.append(images[indexPath.item])
        self.performSegue(withIdentifier: "zoomFavorite", sender: self)
    }
    
}

extension FavoritesViewController: UICollectionViewDelegate{
    
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
