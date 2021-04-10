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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

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
                print("Error \(error)")
            }else{
                self.alert(title: "Inicio de Sesión", message: "Bienvenido \(result!.user.email)")
                print("Usuario autenticado: \(result!.user.uid)")
            }
        }
    }
}

