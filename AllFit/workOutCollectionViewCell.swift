//
//  workOutCollectionCell.swift
//  test
//
//  Created by Jiecheng on 11/11/22.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftUI
class workOutCollectionViewCell : UICollectionViewCell{

    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var workOutImageView: UIImageView!
    
    @IBOutlet weak var workOutNameLabel: UILabel!
    
    @IBOutlet weak var workOutTimeLabel: UILabel!
    @IBOutlet weak var addToFavouriteBtn: UIButton!
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var starsLabel: UILabel!
    
    @IBOutlet weak var starImage: UIImageView!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var authorPhoto: UIImageView!

    var curWorkOut : WorkOut?
    
    var completionHandler: ((UIImage) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //shadowView.layer.shadowColor = UIColor(red:0/255.0,green: 0/255.0,blue: 0/255.0,alpha: 1.0).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowColor = #colorLiteral(red: 0.7947373986, green: 0.7969929576, blue: 0.9504011273, alpha: 0.8013245033)
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.cornerRadius = 10
        workOutImageView.layer.cornerRadius = 10
        rateView.layer.cornerRadius = 5
        timeView.layer.cornerRadius = 5
        workOutNameLabel.clipsToBounds = true
        workOutNameLabel.layer.cornerRadius = 10
    }
    
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
                sender.tintColor = .opaqueSeparator
            }else{
                workOutIdList.append(workoutID)
                sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                sender.tintColor = UIColor(named: "Color")
            }
            Database.database().reference().child("users/\(safeEmail)/favWorkOuts").setValue(workOutIdList)


          }) { error in
            print(error.localizedDescription)
          }

    }

    
    func setUp(with workOut: WorkOut){
        workOutImageView.image = workOut.workOutImage
        workOutNameLabel.text = "  "+workOut.workOutName+"  "
        workOutTimeLabel.text = String( workOut.workoutTotalSeconds/60)+"min"
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
                self.addToFavouriteBtn.tintColor = UIColor(named: "Color")

            }else{
                self.addToFavouriteBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
                self.addToFavouriteBtn.tintColor = .opaqueSeparator

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
