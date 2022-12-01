

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import SDWebImage

class profileViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var profileInfoBackground: UIImageView!
    @IBOutlet weak var userEmailField: UILabel!
    
    @IBOutlet weak var control: UISegmentedControl!
    var user: User?
    var savedWorkOuts : [WorkOut] = favourite
    var personalWorkOuts : [WorkOut] = personal
    var option: Bool = true // true means personal; false means saved
    var ifLogin = false
    var displayList : [WorkOut] = []
    var ref: DatabaseReference! = Database.database().reference()
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let email = Auth.auth().currentUser?.email
        userEmailField.text = email
        // Do any additional setup after loading the view.
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.borderWidth = 0
        profilePhoto.layer.cornerRadius = profilePhoto.frame.width/2.0
        
        profileInfoBackground.layer.cornerRadius = 20
        profileInfoBackground.layer.masksToBounds = false
        profileInfoBackground.layer.shadowColor = #colorLiteral(red: 0.7947373986, green: 0.7969929576, blue: 0.9504011273, alpha: 0.8013245033)
        profileInfoBackground.layer.shadowOffset = CGSize.zero
        profileInfoBackground.layer.shadowOpacity = 0.5
        profileInfoBackground.layer.shadowRadius = 5.0
        
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
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        savedWorkOuts = favourite
        personalWorkOuts = personal
        collectionView.reloadData()
    }
    
    @IBAction func settingAction(_ sender: UIBarButtonItem) {
        if(user != nil){
            let editVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "edit") as! editProfileViewController
            editVC.curUser = user
            editVC.curUser?.profilePhoto = profilePhoto.image
            editVC.completionHandler = { newUser in
                self.usernameLabel.text =  newUser.username
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
    
    @IBAction func controlAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            // Display the user favourite workouts
//            if let workoutList = getWorkOutList(targetNode: "favWorkOuts"){
//                savedWorkOuts = workoutList
//            }
            option = false
        
        }else if sender.selectedSegmentIndex == 1{
            // Display the user created workout
//            if let workoutList = getWorkOutList(targetNode: "createdWorkOuts"){
//                personalWorkOuts = workoutList
//            }
            option = true
        }
        collectionView.reloadData()
    }
    
    func getWorkOutList(targetNode: String) -> [WorkOut]?{
        guard let user = user else {return nil}
        var targetList : [WorkOut] = []
        ref.child("users").child("\(user.safeEmail)/\(targetNode)").observeSingleEvent(of: .value, with: { snapshot in
          // Get current user's favourite workouts
          let workoutsIdList = snapshot.value as? [Int]
          guard let idList = workoutsIdList else {return}
                
          for id in idList {
                self.ref.child("workouts").child("\(id)").observeSingleEvent(of: .value, with: { snapshot2 in
                    let workoutDic = snapshot2.value as? [String : Any]
//                        let exerciseList = workoutDic?["workout_exercises"] as? [[String:Any]] ?? [[:]]
                    
                    let workoutImageFileName = "\(id)_workout_photo.png"
                    let path = "images/" + workoutImageFileName
                    
                    // Get the workout image
                    var workoutImage : UIImage?
                    StorageManager.share.fetchPicUrl(for: path, completion: {result in
                        switch result{
                        case .success(let url):
                            DispatchQueue.global().async {
                                // Fetch Image Data
                                if let data = try? Data(contentsOf: url) {
                                    DispatchQueue.main.async {
                                        // Create Image and Update Image View
                                       workoutImage = UIImage(data: data)
                                    }
                                }
                            }
                        case .failure(let error):
                            print("Fail to get the workout image: \(error)")
                        }
                    })
                    guard let workoutImage = workoutImage else {
                        return
                    }
                    // Create the exercise list
                    let workout_exercises = workoutDic?["workout_exercises"] as? [[String:Any]] ?? [[:]]
                    var exerciseList : [Exercise] = []

                    for dic in workout_exercises{
                        let exerciseId = dic["exerciseId"] as? String ?? ""
                        // Add the exercise image
                        let exerciseImageFileName = "\(exerciseId)_exercise_photo.png"
                        let path = "images/" + exerciseImageFileName

                        var exerciseImage : UIImage?
                        StorageManager.share.fetchPicUrl(for: path, completion: {result in
                            switch result{
                            case .success(let url):
                                DispatchQueue.global().async {
                                    // Fetch Image Data
                                    if let data = try? Data(contentsOf: url) {
                                        DispatchQueue.main.async {
                                            // Create Image and Update Image View
                                            exerciseImage = UIImage(data: data)
                                        }
                                    }
                                }
                            case .failure(let error):
                                print("Fail to get the workout image: \(error)")
                            }
                        })
                        guard let exerciseImage = exerciseImage else {
                            return
                        }
                        let exercise = Exercise(exercise_name: dic["exercise_name"] as? String ?? "", exercise_type: dic["exercise_type"]as? String ?? "", exercise_repOrTime: dic["exercise_repOrTime"]as? String ?? "", exercise_repOrTimeValue: dic["exercise_repOrTimeValue"]as? String ?? "", exercise_equipment: dic["exercise_equipment"] as? [String] ?? [], exercise_time: dic["exercise_time"] as? Int ?? 0, exercise_image: exerciseImage)
                        exerciseList.append(exercise)
                    }

                    let workout = WorkOut(workOutStar: workoutDic?["workOutStar"] as? Double ?? 0.0, workOutStarNum: workoutDic?["workOutStarNum"] as? Int ?? 0, workOutImage: workoutImage, workOutName: workoutDic?["workOutName"] as? String ?? "", workOutDifficulty: workoutDic?["workOutDifficulty"] as? String ?? "", workOutDescription: workoutDic?["workOutDescription"] as? String ?? "", userName: workoutDic?["userName"] as? String ?? "", userPhoto: self.profilePhoto.image, workoutId: workoutDic?["workoutId"] as? Int ?? 0, workout_exercises: exerciseList, favor: workoutDic?["favor"] as? Bool ?? false, workoutDate: workoutDic?["workoutDate"] as? String ?? "", workoutTotalSeconds: workoutDic?["workoutTotalSeconds"] as? Int ?? 0, finishedWorkout: workoutDic?["finishedWorkout"] as? Bool ?? false)
                    
                    targetList.append(workout)
                })
            }

        }) { error in
          print(error.localizedDescription)
        }

        return targetList
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
        if(option){
            cell.setUp(with: personalWorkOuts[indexPath.row])
        }else{
            cell.setUp(with: savedWorkOuts[indexPath.row])
        }
        cell.authorPhoto.image = profilePhoto.image
        return cell
    }
    
    // Open the workout detial page
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(option){
            print(personalWorkOuts[indexPath.row].workOutName)
        }else{
            print(savedWorkOuts[indexPath.row].workOutName)
        }
       
    }
}

extension profileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 194, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 1, bottom: 10, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
