//
//  MainViewController.swift
//  YourPic
//
//  Created by Maria Lacayo on 10/04/21.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let logout = UIAlertAction(title: "Cerrar Sesión", style: UIAlertAction.Style.default) { (action) in
            print("ME CIERRO")
            do {
                try Auth.auth().signOut()
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }catch{
                print("MURIO")
            }
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel) { (action) in
            print("CAncelar")
            
        }
        
        actionSheet.addAction(logout)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func addImage(_ sender: Any) {
        
    }
    

}
