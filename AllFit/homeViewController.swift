import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import RealmSwift

class homeViewController: UIViewController {

    var allWorkouts : [WorkOut] = []
    
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collection.dataSource = self
        collection.delegate = self
        collection.collectionViewLayout = UICollectionViewFlowLayout()
        fetchAllWorkOuts()
        collection.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.collection.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateLogIn()
    }

    private func validateLogIn(){
        if FirebaseAuth.Auth.auth().currentUser == nil{
            let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogAndSign")
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    // ToDo: Add all the workouts into allWorkouts
    func fetchAllWorkOuts(){
        Database.database().reference().child("workouts").observeSingleEvent(of: .value, with: { snapshot in

            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    print("Error")
                    return
                }
                print("dict is ",dict)
                let userEmail = dict["userEmail"] as? String ?? ""
                let workOutStar = dict["workOutStar"] as? Double ?? 0.0
                let workOutStarNum = dict["workOutStarNum"] as? Int ?? 0
                let workOutName = dict["workOutName"]as? String ?? ""
                let workOutDifficulty = dict["workOutDifficulty"]as? String ?? ""
                let workOutDescription = dict["workOutDescription"]as? String ?? ""
                let workoutId = dict["workoutId"]as? Int ?? 0
                print("workout exercise is ",dict["workout_exercises"]!)
                
//                var workout_exercises = dict["workout_exercises"] as? [[String: Any]] ?? [[:]]
//
                var workout_exercises2 = dict["workout_exercises"] as? NSArray
                
                let objCArray = NSMutableArray(array: workout_exercises2!)

                let workout_exercises: [[String:Any]] = objCArray.compactMap({ $0 as? [String:Any] })

                print("swiftArray is ",workout_exercises)
                
//                workout_exercises.removeFirst()
                let workoutDate = dict[ "workoutDate"]as? String ?? ""
                let workoutTotalSeconds = dict["workoutTotalSeconds"]as? Int ?? 0
                let finishedWorkout = dict["finishedWorkout"]as? Bool ?? false
                
                print("workout exercises is ",workout_exercises)
                
                // Create the exercise list
                var exerciseList : [Exercise] = []
                for dic in workout_exercises{
                    let exerciseImageFile = dic["exercise_image"] as? String ?? ""
                    let exerciseId = dic["exerciseId"] as? String ?? ""
                    // Add the exercise image
                    let path = "images/" + exerciseImageFile
                    
                    var exerciseImage : UIImage?
                    StorageManager.share.fetchPicUrl(for: path, completion: {result in
                        switch result{
                        case .success(let url):
                            DispatchQueue.global().async {
                                // Fetch Image Data
                                print("url is ", url)
                                if let data = try? Data(contentsOf: url) {
                                    DispatchQueue.main.async {
                                        // Create Image and Update Image View
                                        exerciseImage = UIImage(data: data)
                                        print("exercise image is ",exerciseImage)
                                        print("exercise image! is ",exerciseImage!)

                                    }
                                }
                            }
                        case .failure(let error):
                            print("Fail to get the workout image: \(error)")
                        }
                    })
                    var image:UIImage!
                    if exerciseImage == nil{
                        return
                    }
                    else{
                        image=exerciseImage!
                    }
//                    guard let image = exerciseImage else {
//                        return
//                    }
                    
                    let exercise = Exercise(exercise_name: dic["exercise_name"] as? String ?? "", exercise_type: dic["exercise_type"]as? String ?? "", exercise_repOrTime: dic["exercise_repOrTime"]as? String ?? "", exercise_repOrTimeValue: dic["exercise_repOrTimeValue"]as? String ?? "", exercise_equipment: dic["exercise_equipment"] as? [String] ?? [], exercise_time: dic["exercise_time"] as? Int ?? 0, exercise_image: image)
                    exerciseList.append(exercise)
                }
                // Get the workout image
                let workoutImageFile = dict["workoutImage"] as? String ?? ""
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
                
                // Get the author's profile photo
                // Todo: change username to userSafeEmail
                let safeEmail = DatabaseManager.safeEmail(userEmail: userEmail)
                let profilePhotoFileName = "\(safeEmail)_workout_photo.png"
                let profilePhotoPath = "images/" + profilePhotoFileName
                var profilePhoto : UIImage?
                StorageManager.share.fetchPicUrl(for: profilePhotoPath, completion: {result in
                    switch result{
                    case .success(let url):
                        DispatchQueue.global().async {
                            // Fetch Image Data
                            if let data = try? Data(contentsOf: url) {
                                DispatchQueue.main.async {
                                    // Create Image and Update Image View
                                    profilePhoto = UIImage(data: data)
                                }
                            }
                        }
                    case .failure(let error):
                        print("Fail to get the user profile photo: \(error)")
                    }
                })
                guard let profilePhoto = profilePhoto else {
                    return
                }
                
                let workout = WorkOut(workOutStar: workOutStar, workOutStarNum: workOutStarNum, workOutImage: workoutImage, workOutName: workOutName, workOutDifficulty: workOutDifficulty, workOutDescription: workOutDescription, userName: userEmail, userPhoto: profilePhoto, workoutId: workoutId, workout_exercises: exerciseList, workoutDate: workoutDate, workoutTotalSeconds: workoutTotalSeconds, finishedWorkout: finishedWorkout)
                self.allWorkouts.append(workout)
            }
      }) { error in
        print(error.localizedDescription)
      }
    }
}

extension homeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allWorkouts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workOutCollectionViewCell", for: indexPath) as! workOutCollectionViewCell
        
        cell.setUp(with: allWorkouts[indexPath.row])
        
        cell.index = indexPath.row
        
        return cell
    }
}

extension homeViewController: UICollectionViewDelegateFlowLayout {
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

extension homeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(allWorkouts[indexPath.row].workOutName)
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailedVC = storyboard.instantiateViewController(withIdentifier: "detailedWorkoutVC") as! DetailedWorkoutController2

        //let detailedVC = DetailedWorkoutController()
        detailedVC.wkoutImage = allWorkouts[indexPath.row].workOutImage
        detailedVC.wkoutName=allWorkouts[indexPath.row].workOutName
        detailedVC.wkoutRating=allWorkouts[indexPath.row].workOutStar
        detailedVC.wkoutRatingNum=allWorkouts[indexPath.row].workOutStarNum
        detailedVC.wkoutExercises=allWorkouts[indexPath.row].workout_exercises

        //push nav controller
        navigationController?.pushViewController(detailedVC, animated: true)
    }
}
