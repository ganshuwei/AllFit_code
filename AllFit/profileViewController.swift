

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import SDWebImage
import AVFoundation

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
    var ifLogin = false
    var displayWorkOuts : [WorkOut] = []
    
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
            self.getWorkOutList(targetNode: "favWorkOuts")
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
        collectionView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if control.selectedSegmentIndex == 0{
            // Display the user favourite workouts
            displayWorkOuts = []
            collectionView.reloadData()
            getWorkOutList(targetNode: "favWorkOuts")
        
        }
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
        displayWorkOuts = []
        collectionView.reloadData()
        if sender.selectedSegmentIndex == 0{
            // Display the user favourite workouts
            getWorkOutList(targetNode: "favWorkOuts")
        
        }else if sender.selectedSegmentIndex == 1{
            // Display the user created workout
            displayWorkOuts = []
            getWorkOutList(targetNode: "createdWorkouts")
        }else if sender.selectedSegmentIndex == 2{
            // Display the user finished workout
            
            getWorkOutList(targetNode: "finishedWorkouts")
        }
    }
    
    func getWorkoutInfo(workoutID : String){
        Database.database().reference().child("workouts").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? NSDictionary else {return}
            guard let dict = value[workoutID] as? [String: Any] else {return}
            let userEmail = dict["userEmail"] as? String ?? ""
            let workOutStar = dict["workOutStar"] as? Double ?? 0.0
            let workOutStarNum = dict["workOutStarNum"] as? Int ?? 0
            let workOutName = dict["workOutName"]as? String ?? ""
            let workOutDifficulty = dict["workOutDifficulty"]as? String ?? ""
            let workOutDescription = dict["workOutDescription"]as? String ?? ""
            let workoutId = dict["workoutId"]as? String ?? ""
            let workoutDate = dict[ "workoutDate"]as? String ?? ""
            let workoutTotalSeconds = dict["workoutTotalSeconds"]as? Int ?? 0
            let finishedWorkout = dict["finishedWorkout"]as? Bool ?? false
            let workout_exercises2 = dict["workout_exercises"] as? NSArray
            
            let objCArray = NSMutableArray(array: workout_exercises2 ?? [])
            let workout_exercises: [[String:Any]] = objCArray.compactMap({ $0 as? [String:Any] })
            
            var exerciseList : [Exercise] = []
            for dic in workout_exercises{
                // Add the exercise image
                let exerciseImageFile = dic["exercise_image"] as? String ?? ""
                let exercise = Exercise(exercise_name: dic["exercise_name"] as? String ?? "", exercise_type: dic["exercise_type"]as? String ?? "", exercise_repOrTime: dic["exercise_repOrTime"]as? String ?? "", exercise_repOrTimeValue: dic["exercise_repOrTimeValue"]as? String ?? "", exercise_equipment: dic["exercise_equipment"] as? [String] ?? [], exercise_time: dic["exercise_time"] as? Int ?? 0, exercise_image_path: exerciseImageFile,exercise_image: UIImage(systemName: "person"))
                exerciseList.append(exercise)
            }
            let workoutImageFile = dict["workOutImage"] as? String ?? ""
            let path = "images/" + workoutImageFile
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
                                guard let workoutImage = workoutImage else {
                                    return
                                }
                                let workout = WorkOut(workOutStar: workOutStar, workOutStarNum: workOutStarNum, workOutImage: workoutImage, workOutName: workOutName, workOutDifficulty: workOutDifficulty, workOutDescription: workOutDescription, userName: userEmail, userPhoto: UIImage(systemName: "person"), workoutId: workoutId, workout_exercises: exerciseList, workoutDate: workoutDate, workoutTotalSeconds: workoutTotalSeconds, finishedWorkout: finishedWorkout)
                                self.displayWorkOuts.append(workout)
                                self.collectionView.reloadData()
                            }
                        }
                    }
                case .failure(let error):
                    print("Fail to get the workout image: \(error)")
                }
            })
          }) { error in
            print(error.localizedDescription)
          }
    }
    
    func getWorkOutList(targetNode: String){
        print("target node is ",targetNode)
                
        guard let user = user else {
            return
        }
        
        let safeEmail = user.safeEmail
        Database.database().reference().child("users/\(safeEmail)").child(targetNode).observeSingleEvent(of: .value, with: { snapshot in

            for case let child as DataSnapshot in snapshot.children {
                if(targetNode == "finishedWorkouts"){
                    guard let workout = child.value as? [String : Any] else{
                        return
                    }
                    let workoutId = workout["workoutId"] as? String ?? ""
                    print("workoutID: \(workoutId)")
                    
                    //get workout info from workouts
                    self.getWorkoutInfo(workoutID: workoutId)
                    
                }else{
                    guard let workoutId = child.value as? String else {
                        print("Error")
                        return
                    }
                    print("workoutID: \(workoutId)")
                    
                    //get workout info from workouts
                    self.getWorkoutInfo(workoutID: workoutId)
                }

            }
      }) { error in
        print(error.localizedDescription)
      }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayWorkOuts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workOutCollectionViewCell", for: indexPath) as! workOutCollectionViewCell
        cell.curWorkOut = displayWorkOuts[indexPath.row]
        cell.setUp(with: displayWorkOuts[indexPath.row])
        cell.authorPhoto.image = profilePhoto.image
        return cell
    }
    
    // Open the workout detial page
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailedVC = storyboard.instantiateViewController(withIdentifier: "detailedWorkoutVC") as! DetailedWorkoutController2
        
        //Check whether finish this workout before
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        guard let email = user.email else{return}
        let safeEmail = DatabaseManager.safeEmail(userEmail: email)
        let workoutId = displayWorkOuts[indexPath.row].workoutId
        Database.database().reference().child("users/\(safeEmail)").child("finishedWorkouts").observeSingleEvent(of: .value, with: { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                let finishedWorkout = child.value as? [String:Any] ?? [:]

                let finishedWorkoutId = finishedWorkout["workoutId"] as? String ?? ""
                if(finishedWorkoutId == workoutId){
                    detailedVC.checkFinished.text = "You have finished this workout before."
                    detailedVC.checkFinished.textColor = .red
                }
            }
      }) { error in
        print(error.localizedDescription)
      }

        //let detailedVC = DetailedWorkoutController()
        detailedVC.wkoutId = displayWorkOuts[indexPath.row].workoutId
        detailedVC.wkoutImage = displayWorkOuts[indexPath.row].workOutImage
        detailedVC.wkoutName=displayWorkOuts[indexPath.row].workOutName
        detailedVC.wkoutRating=displayWorkOuts[indexPath.row].workOutStar
        detailedVC.wkoutRatingNum=displayWorkOuts[indexPath.row].workOutStarNum
        detailedVC.wkoutExercises=displayWorkOuts[indexPath.row].workout_exercises
        detailedVC.creatorName=displayWorkOuts[indexPath.row].userName
        detailedVC.wkoutDifficulty=displayWorkOuts[indexPath.row].workOutDifficulty
        detailedVC.wkoutDescription=displayWorkOuts[indexPath.row].workOutDescription
        detailedVC.currWorkout = displayWorkOuts[indexPath.row]

        //push nav controller
        navigationController?.pushViewController(detailedVC, animated: true)
       
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

