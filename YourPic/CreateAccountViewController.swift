//
//  CreateAccountViewController.swift
//  YourPic
//
//  Created by Maria Lacayo on 10/04/21.
//

import UIKit
import Firebase

class CreateAccountViewController: Utility {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccount(_ sender: Any) {
        let mail = email.text!
        let pass = password.text!
        let cpass = confirmPassword.text!
        if((!mail.contains("@")) || (!mail.contains("."))){
            alert(title: "Error", message: "Ingrese un correo electrónico valido")
        }
        if (pass.count<6){
            alert(title: "Alerta de Seguridad", message: "Debes crear una contraseña de al menos 6 caracteres para progeter tu cuenta")
        }
        if (pass != cpass){
            alert(title: "Error", message: "Las contraseñas no coinciden")
        }
        
        Auth.auth().createUser(withEmail: mail, password: pass) { (result, error) in
            if let error=error{
                self.alert(title: "Error", message: "Error al crear usuario. \"\(error.localizedDescription)\"")
            }else{
                self.alertDismiss(title: "Registro Exitoso", message: "")
                //self.dismiss(animated: true, completion: nil)
            }
        }
    }

}
