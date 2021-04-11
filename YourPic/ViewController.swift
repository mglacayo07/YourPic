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
            self.openMain()
        }
    }
    
    //IBAction functions
    @IBAction func login(_ sender: Any) {
        let mail = email.text!
        let pwd = password.text!
        if(mail.count==0){
            alert(title: "Error de credenciales", message: "Correo Invalido")
            return
        }
        if(pwd.count==0){
            alert(title: "Error de credenciales", message: "Contraseña Invalida")
            return
        }
        
        Auth.auth().signIn(withEmail: mail, password: pwd) { (result, error) in
            if let error = error{
                self.alert(title: "Error al autenticar", message: "Error en las credenciales. \"\(error.localizedDescription)\"")
            }else{
                //self.alert(title: "Inicio de Sesión", message: "Bienvenido \(result?.user.email)")
                print("LOGIN TRUE")
                self.openMain()
            }
        }
    }
    
    @IBAction func createAccount(_ sender: Any) {
        let createAccountView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "createAccountView") as? CreateAccountViewController
        present(createAccountView!, animated: true, completion: nil)
    }
    
    //My functions
    func openMain(){
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mainView") as? MainViewController
        present(mainView!, animated: true)
    }
}

