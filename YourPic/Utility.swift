//
//  Utility.swift
//  YourPic
//
//  Created by Maria Lacayo on 10/04/21.
//

import UIKit

class Utility: UIViewController{
    
    func alert(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
