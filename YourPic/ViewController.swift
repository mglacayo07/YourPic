//
//  ViewController.swift
//  YourPic
//
//  Created by Maria Lacayo on 10/04/21.
//

import UIKit
import Firebase

class ViewController: Utility {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    //override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil{
            self.performSegue(withIdentifier: "mainIdentifier", sender: self)
        }
    }
    
    //IBAction functions
    @IBAction func login(_ sender: Any) {

        guard let mail = email.text, mail != "", let pwd = password.text, pwd != "" else{
            //self.removeSpinner()
            alert(title: "Error de credenciales", message: "Datos Invalidos")
            return
        }
        
        Auth.auth().signIn(withEmail: mail, password: pwd) { (result, error) in
            if let error = error{
                self.alert(title: "Error al autenticar", message: "Error en las credenciales. \"\(error.localizedDescription)\"")
            }else{
                self.performSegue(withIdentifier: "mainIdentifier", sender: self)
            }
        }
    }
    
    @IBAction func createAccount(_ sender: Any) {
        //let createAccountView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "createAccountView") as? CreateAccountViewController
        //present(createAccountView!, animated: true, completion: nil)
        self.performSegue(withIdentifier: "mainIdentifier", sender: self)
    }
}

