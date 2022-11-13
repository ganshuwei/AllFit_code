

import UIKit

class editProfileViewController: UIViewController {
    
    var user : User?
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var ChangePhotoBtn: UIButton!
    
    @IBOutlet weak var userEmailField: UITextField!
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var BirthdayField: UITextField!
    
    @IBOutlet weak var bioField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ChangePhotoAction(_ sender: UIButton) {
        
    }
    

}

