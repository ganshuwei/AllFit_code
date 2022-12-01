

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import SDWebImage

class profileViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    

    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var userEmailField: UILabel!
    
    @IBOutlet weak var personalWorkOutsBtn: UIButton!
    
    @IBOutlet weak var savedWorkOutsBtn: UIButton!
    
    @IBOutlet weak var birthday: UILabel!
    var user: User?
    var savedWorkOuts : [WorkOut] = []
    var personalWorkOuts : [WorkOut] = []
    var option: Bool = true // true means personal; false means saved
    var ifLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let email = Auth.auth().currentUser?.email
        userEmailField.text = email
        // Do any additional setup after loading the view.
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.borderWidth = 2
        profilePhoto.layer.borderColor = UIColor.lightGray.cgColor
        profilePhoto.layer.cornerRadius = profilePhoto.frame.width/2.0
        
        // Get current user personal information
        guard let email = email else{
            return
        }
        print(email)
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        Database.database().reference().child("users").child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
          let value = snapshot.value as? NSDictionary
            self.usernameLabel.text = value?["username"] as? String ?? ""
            self.bioLabel.text = value?["bio"] as? String ?? ""
            self.birthday.text = value?["birthday"] as? String ?? ""
            self.user = User(userEmail: email, username: value?["username"] as? String ?? "", firstName: value?["first_name"] as? String ?? "", lastName: value?["last_name"] as? String ?? "", bio: value?["bio"] as? String ?? "", birthday: value?["birthday"] as? String ?? "", profilePhoto: self.profilePhoto.image)
        }) { error in
          print(error.localizedDescription)
        }


        
        // Get the user's profile photo
        let fileName = safeEmail + "_profile_photo.png"
        let path = "images/" + fileName
        StorageManager.share.fetchPicUrl(for: path, completion: {result in
            switch result{
            case .success(let url):
                self.profilePhoto.sd_setImage(with: url, completed: nil)
                self.user?.profilePhoto = self.profilePhoto.image
            case .failure(let error):
                print("Fail to get the user profile photo: \(error)")
            }
        })

    }
    
    @IBAction func settingAction(_ sender: UIBarButtonItem) {
        if(user != nil){
            let editVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "edit") as! editProfileViewController
            editVC.curUser = user
            editVC.curUser?.profilePhoto = profilePhoto.image
            editVC.completionHandler = { newUser in
                self.usernameLabel.text =  newUser.username
                self.birthday.text = newUser.birthday
                self.bioLabel.text = newUser.bio
                self.profilePhoto.image = newUser.profilePhoto
                
            }
            self.navigationController?.pushViewController(editVC, animated: true)
        }
    }

    
    @IBAction func logOutAction(_ sender: UIBarButtonItem) {
        let logOutAlert = UIAlertController(title: "Log Out", message: "Do you want to log out your account?", preferredStyle: UIAlertController.Style.alert)

        logOutAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            do{
                try Auth.auth().signOut()
                self.ifLogin = false
                UserDefaults.standard.setValue(nil, forKey: "email")
                UserDefaults.standard.setValue(nil, forKey: "name")
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
