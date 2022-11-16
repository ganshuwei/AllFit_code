

import UIKit
import FirebaseAuth
import Firebase

class profileViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    

    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var personalWorkOutsBtn: UIButton!
    
    @IBOutlet weak var savedWorkOutsBtn: UIButton!
    
    @IBOutlet weak var birthday: UILabel!
    var user = testUser
    var savedWorkOuts : [WorkOut] = []
    var personalWorkOuts : [WorkOut] = []
    var option: Bool = true // true means personal; false means saved
    var ifLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = Auth.auth().currentUser?.email
        // Do any additional setup after loading the view.
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.borderWidth = 2
        profilePhoto.layer.borderColor = UIColor.lightGray.cgColor
        profilePhoto.layer.cornerRadius = profilePhoto.frame.width/2.0
        profilePhoto.image = testUser.profilePhoto
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }

    
    @IBAction func logOutAction(_ sender: UIBarButtonItem) {
        let logOutAlert = UIAlertController(title: "Log Out", message: "Do you want to log out your account?", preferredStyle: UIAlertController.Style.alert)

        logOutAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            do{
                try Auth.auth().signOut()
                self.ifLogin = false
                let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogAndSign")
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            }catch let logOutError{
                let alert = UIAlertController(title: "Attention", message: logOutError.localizedDescription, preferredStyle: .alert)
                self.present(alert, animated: true)
            }
            

        }))

        logOutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))

        present(logOutAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func personalWorkOutsAction(_ sender: UIButton) {
        option = true
    }
    
    @IBAction func savedWorkOutsBtn(_ sender: UIButton) {
        option = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(option){
            return personalWorkOuts.count
        }else{
            return savedWorkOuts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workOutCollectionViewCell", for: indexPath) as! workOutCollectionViewCell
        
        return cell
    }
}
