//
//  workOutCollectionCell.swift
//  test
//
//  Created by Jiecheng on 11/11/22.
//

import UIKit
class workOutCollectionViewCell : UICollectionViewCell{

        
    @IBOutlet weak var workOutImageView: UIImageView!
    
    @IBOutlet weak var workOutNameLabel: UILabel!
    
    @IBOutlet weak var addToFavouriteBtn: UIButton!
    
    @IBOutlet weak var starsLabel: UILabel!
    
    @IBOutlet weak var starImage: UIImageView!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var authorPhoto: UIImageView!
    
    var index : Int = 0
    
    var curWorkOut : WorkOut?
    
    
    
    @IBAction func addToFavAction(_ sender: UIButton) {
        if var item = curWorkOut{
            print(item.favor)
            if(item.favor){
                sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
                sender.tintColor = .black
                item.favor = false
                curWorkOut?.favor = false
                workOuts[index].favor = false
                favourite = favourite.filter{$0.workoutId != item.workoutId}
                print("remove from favourite")
            }else{
                sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                sender.tintColor = starImage.tintColor
                workOuts[index].favor = true
                item.favor = true
                curWorkOut?.favor = true
                favourite.append(item)
                print("Added to favourite")
                print(index)
                print(item.favor)
            }
        }
    }
    
    func setUp(with workOut: WorkOut){
        workOutImageView.image = workOut.workOutImage
        workOutNameLabel.text = workOut.workOutName
        starsLabel.text = String(workOut.workOutStar)
        authorNameLabel.text = workOut.userName
        authorPhoto.image = workOut.userPhoto
        curWorkOut = workOut
        if(workOut.favor){
            addToFavouriteBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            addToFavouriteBtn.tintColor = starImage.tintColor
        }else{
            addToFavouriteBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
            addToFavouriteBtn.tintColor = .black
        }
        
        if let row = workOuts.firstIndex(where: {$0.workoutId == workOut.workoutId}) {
            index = row
        }
    }
}
