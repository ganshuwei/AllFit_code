//
//  registerViewController.swift
//  AllFit
//
//  Created by 甘书玮 on 2022/11/10.
//

import UIKit
import FirebaseAuth
import Firebase

class registerViewController: UIViewController {
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var confirmPwInput: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var errorText: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func didTapBtn(_ sender: Any) {
        guard let email = emailInput.text,!email.isEmpty else{
            errorText.text="Please input correct email"
            return
        }
        guard let pw=passwordInput.text,let pwc=confirmPwInput.text,!pw.isEmpty,!pwc.isEmpty,pw==pwc else{
            errorText.text="Password doesn't match"
            return
        }
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: pw){
            (authResult,error) in
            guard let result = authResult,error == nil else{
                print(error ?? "")
                return
            }
            
            let user = result.user
            print("Created User:\(user)")
            
        }
        
        Auth.auth().signIn(withEmail: email, password: pw){[weak self] authResult,err in
            if let e = err{
                self?.errorText.text=e.localizedDescription
            }
        }
        if Auth.auth().currentUser != nil{
            print("log in successfully!")
            let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserMain")
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
        errorText.text=""
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
