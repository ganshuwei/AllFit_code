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
    
    var saved = false
    
    var curWorkOut : WorkOut?
    
    @IBAction func addToFavAction(_ sender: UIButton) {
        if(saved){
            sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
            sender.tintColor = .black
            saved = false
            if let removeItem = curWorkOut{
                favourite = favourite.filter{$0.workoutId != removeItem.workoutId}
            }
            print("remove from favourite")
        }else{
            sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            sender.tintColor = starImage.tintColor
            saved = true
            if let addItem = curWorkOut{
                favourite.append(addItem)
            }
            print("Added to favourite")
        }
        

    
    }
    
    func setUp(with workOut: WorkOut){
        workOutImageView.image = workOut.workOutImage
        workOutNameLabel.text = workOut.workOutName
        starsLabel.text = String(workOut.workOutStar)
        authorNameLabel.text = workOut.userName
        authorPhoto.image = workOut.userPhoto
        curWorkOut = workOut
    }
}
