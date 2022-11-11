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
        
        Auth.auth().signIn(withEmail: email, password: pw)            {[weak self] authResult,err in
            guard let strongSelf=self else{
                return
            }
            if let e = err{
                self?.errorLabel.text=e.localizedDescription
            }
        }
        if Auth.auth().currentUser != nil{
            if let rootVC = navigationController?.viewControllers.first as? ViewController {
                rootVC.userEmail = Auth.auth().currentUser?.email
                rootVC.loginBtn.configuration?.title = "logout"
                rootVC.ifLogin=true
            }
            navigationController?.popToRootViewController(animated: true)
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
