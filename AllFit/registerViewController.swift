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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordInput.isSecureTextEntry = true
        confirmPwInput.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func didTapBtn(_ sender: Any) {
        guard let email = emailInput.text,!email.isEmpty else{
            alertUserSignUp(message: "Please input correct email")
            return
        }
        guard let pw=passwordInput.text,let pwc=confirmPwInput.text,!pw.isEmpty,!pwc.isEmpty,pw==pwc else{
            alertUserSignUp(message: "Password doesn't match")
            return
        }
        
        // Check existing user
        DatabaseManager.shared.checkExistUser(with: email, completion: {[weak self] exists in
            guard let strongSelf = self else{return}
            guard !exists else{
                // user already exist in the real database
                print("This user has already existed.")
                return
            }
            // Create a new user account
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: pw){
                (authResult,error) in
                guard error == nil, authResult != nil else{
                    strongSelf.alertUserSignUp(message: error?.localizedDescription ?? "Unknown Error")
                    return
                }
                
                // Add the new user to the real database
            
                let user = User(userEmail: email)
                UserDefaults.standard.set("\(user.username)", forKey: "name")
                UserDefaults.standard.set("\(user.userEmail)", forKey: "email")
                DatabaseManager.shared.addNewUser(with: user, completion: {success in
                    if(success){
                        // Suceessfully log in, go to the home screen

                        let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserMain")
                        navigationController.modalPresentationStyle = .fullScreen
                        strongSelf.present(navigationController, animated: true, completion: nil)
                    }
                })

            }
        })
        
    }
    
    func alertUserSignUp(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
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
