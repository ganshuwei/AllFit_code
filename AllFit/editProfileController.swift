

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class editProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePhotoView: UIImageView!
    
    @IBOutlet weak var userEmailField: UITextField!
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var BirthdayField: UITextField!
    
    @IBOutlet weak var bioField: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    var curUser: User?
    
    var completionHandler: ((User) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userEmailField.isUserInteractionEnabled = false
        profilePhotoView.layer.masksToBounds = true
        profilePhotoView.layer.borderWidth = 2
        profilePhotoView.layer.borderColor = UIColor.lightGray.cgColor
        profilePhotoView.layer.cornerRadius = profilePhotoView.frame.width/2.0
        profilePhotoView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self,
                                                     action: #selector(didTapChangeProfilePic))
        profilePhotoView.addGestureRecognizer(gesture)
        
        guard let curUser = curUser else {return}
        profilePhotoView.image = curUser.profilePhoto
        userEmailField.text = curUser.userEmail
        userNameField.text = curUser.username
        firstNameField.text = curUser.firstName
        lastNameField.text = curUser.lastName
        BirthdayField.text = curUser.birthday
        bioField.text = curUser.bio
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        guard var curUser = curUser else {return}
        Database.database().reference().child("users").child(curUser.safeEmail).setValue(["username":userNameField.text!,"first_name":firstNameField.text!, "last_name": lastNameField.text!, "bio": bioField.text!, "birthday": BirthdayField.text!])
        
        // Upload the user's new profile photo
        guard let image = profilePhotoView.image, let data = image.pngData() else{return}
        let fileName = curUser.profilePhotoFileName
        StorageManager.share.uploadProfilePicture(with: data, fileName: fileName, completion: {result in
            switch result {
                case .success(let downloadUrl):
                    print(downloadUrl)
                case .failure(let error):
                    print("Firebase Storage Error: \(error)")
            }
        })
        curUser.username = userNameField.text ?? ""
        curUser.firstName = firstNameField.text ?? ""
        curUser.lastName =  lastNameField.text ?? ""
        curUser.birthday = BirthdayField.text ?? ""
        curUser.profilePhoto = profilePhotoView.image
        curUser.bio = bioField.text ?? ""
        completionHandler?(curUser)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
}


extension editProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How do you like to select a picture?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {[weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {[weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{return}
        self.profilePhotoView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
    }
}

