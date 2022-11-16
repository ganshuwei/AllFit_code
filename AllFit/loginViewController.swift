//
//  loginViewController.swift
//  AllFit
//
//  Created by 甘书玮 on 2022/11/10.
//

import UIKit
import FirebaseAuth

class loginViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var pwText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pwText.isSecureTextEntry = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
                
        guard let email=emailText.text,!email.isEmpty else{
            errorLabel.text="You don't input email"
            return
        }
        guard let pw=pwText.text,!pw.isEmpty else{
            errorLabel.text="You don't input password"
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: pw){[weak self] authResult,err in
            guard let strongSelf = self else{return}
            // Fail to log in return and print the error
            if let e = err{
                self?.errorLabel.text=e.localizedDescription
                return
            }
            // Suceessfully log in, go dismiss this view and go back to the home screen
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
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
