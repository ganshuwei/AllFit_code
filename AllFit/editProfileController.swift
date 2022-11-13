

import UIKit

class editProfileViewController: UIViewController {
    
    var user : User?
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var userEmailField: UITextField!
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var BirthdayField: UITextField!
    
    @IBOutlet weak var bioField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.borderWidth = 2
        profilePhoto.layer.borderColor = UIColor.lightGray.cgColor
        profilePhoto.layer.cornerRadius = profilePhoto.frame.width/2.0
        profilePhoto.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self,
                                                     action: #selector(didTapChangeProfilePic))
        profilePhoto.addGestureRecognizer(gesture)
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
        self.profilePhoto.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
    }
}

