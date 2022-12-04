//
//  workOutCollectionCell.swift
//  test
//
//  Created by Jiecheng on 11/11/22.
//

import UIKit
import Firebase
import FirebaseAuth
class workOutCollectionViewCell : UICollectionViewCell{

        
    @IBOutlet weak var workOutImageView: UIImageView!
    
    @IBOutlet weak var workOutNameLabel: UILabel!
    
    @IBOutlet weak var addToFavouriteBtn: UIButton!
    
    @IBOutlet weak var starsLabel: UILabel!
    
    @IBOutlet weak var starImage: UIImageView!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var authorPhoto: UIImageView!

    var curWorkOut : WorkOut?
    
    var completionHandler: ((UIImage) -> Void)?
    
    
    
    @IBAction func addToFavAction(_ sender: UIButton) {
        guard let curWorkOut = curWorkOut else {
            return
        }
        guard let user = Auth.auth().currentUser else {return}
        guard let email = user.email else {return}
        let safeEmail = DatabaseManager.safeEmail(userEmail: email)
        let workoutID = DatabaseManager.safeEmail(userEmail: curWorkOut.userName) + "_" + curWorkOut.workOutName
        
        Database.database().reference().child("users/\(safeEmail)").child("favWorkOuts").observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            var workOutIdList = snapshot.value as? [String] ?? []
            

            if(workOutIdList.contains(workoutID)){
                // Exist in the favList, So Remove
                workOutIdList = workOutIdList.filter{$0 != workoutID}
                sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
                sender.tintColor = .black
            }else{
                workOutIdList.append(workoutID)
                sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                sender.tintColor = self.starImage.tintColor
            }
            Database.database().reference().child("users/\(safeEmail)/favWorkOuts").setValue(workOutIdList)


          }) { error in
            print(error.localizedDescription)
          }

    }

    
    func setUp(with workOut: WorkOut){
        workOutImageView.image = workOut.workOutImage
        workOutNameLabel.text = workOut.workOutName
        starsLabel.text = String(workOut.workOutStar)
        authorNameLabel.text = workOut.userName
        let safeEmail = DatabaseManager.safeEmail(userEmail: workOut.userName)
        let fileName = safeEmail + "_profile_photo.png"
        let path = "images/" + fileName
        if(workOut.userPhoto == UIImage(systemName: "person.crop.circle.fill")){
            StorageManager.share.fetchPicUrl(for: path, completion: {result in
                switch result{
                case .success(let url):
                    self.authorPhoto.sd_setImage(with: url, completed: nil)
                    guard let image = self.authorPhoto.image else {return}
                    self.completionHandler?(image)
                case .failure(let error):
                    print("Fail to get the user profile photo: \(error)")
                }
            })
        }
        authorPhoto.circleImageView()
        curWorkOut = workOut
        checkFav()
    }
    
    func checkFav(){
        guard let curWorkOut = curWorkOut else {
            return
        }
        guard let user = Auth.auth().currentUser else {return}
        guard let email = user.email else {return}
        let safeEmail = DatabaseManager.safeEmail(userEmail: email)
        let workoutID = DatabaseManager.safeEmail(userEmail: curWorkOut.userName) + "_" + curWorkOut.workOutName
        
        Database.database().reference().child("users/\(safeEmail)").child("favWorkOuts").observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let workOutIdList = snapshot.value as? [String] ?? []
            

            if(workOutIdList.contains(workoutID)){
                // Exist in the favList, So Remove
                self.addToFavouriteBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                self.addToFavouriteBtn.tintColor = self.starImage.tintColor

            }else{
                self.addToFavouriteBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
                self.addToFavouriteBtn.tintColor = .black

            }

          }) { error in
            print(error.localizedDescription)
          }
    }
}

extension UIImageView {

    func circleImageView() {
//       layer.borderColor = UIColor.white.cgColor
       layer.borderWidth = 0
       contentMode = .scaleAspectFill
       layer.cornerRadius = self.frame.height / 2
       layer.masksToBounds = false
       clipsToBounds = true
    }
}
