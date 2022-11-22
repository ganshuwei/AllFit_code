//
//  DetailedWorkoutController.swift
//  AllFit
//
//  Created by user on 11/22/22.
//

import Foundation
import UIKit

class DetailedWorkoutController : UIViewController,UIScrollViewDelegate{

    var wkoutImage: UIImage!
    var wkoutName: String!
//    var wkoutCreator: String!
    var wkoutRating: Double!
//    var wkoutDuration: String!
//    var wkoutDifficulty: String!
//    var wkoutEquipment: String!
//    var wkoutDescription: String!
    var wkoutExercises: [Exercise] = []
    
    
    @IBOutlet weak var workoutImage: UIImageView!
    @IBOutlet weak var workoutName: UILabel!
    @IBOutlet weak var workoutCreator: UILabel!
    @IBOutlet weak var workoutRating: UILabel!
    @IBOutlet weak var workoutDuration: UILabel!
    @IBOutlet weak var workoutDifficulty: UILabel!
    @IBOutlet weak var workoutEquipment: UILabel!
    @IBOutlet weak var workoutDescription: UILabel!
    @IBOutlet weak var exerciseTable: UITableView!
   
    lazy var scrollView: UIScrollView = {
            let scroll = UIScrollView()
            scroll.translatesAutoresizingMaskIntoConstraints = false
            scroll.delegate = self
            scroll.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
            return scroll
        }()
    
    override func viewDidLoad() {
        print("in detailed view controller")
        super.viewDidLoad()
        print(wkoutName!)
        print(wkoutRating!)
        print(wkoutImage!)

        view.backgroundColor = UIColor.white

        view.addSubview(scrollView)
        
        let theImageFrame = CGRect(x: view.frame.midX - wkoutImage.size.width/8, y: 120, width: wkoutImage.size.width/4, height: wkoutImage.size.height/4)
        let imageView = UIImageView(frame:theImageFrame)
        imageView.image = wkoutImage
        scrollView.addSubview(imageView)
        
        let theTitleFrame = CGRect(x: 0, y: wkoutImage.size.height/4 + 150, width: view.frame.width, height: 40)
        let titleView = UILabel(frame: theTitleFrame)
        titleView.text = wkoutName
        titleView.textAlignment = .center
        
        let theButtonFrame = CGRect(x: view.frame.width/4, y: wkoutImage.size.height/4 + 270 + titleView.frame.height, width: view.frame.width/2, height: 40)
        let startBtn = UIButton(frame: theButtonFrame)
        startBtn.backgroundColor=UIColor.systemBlue
        startBtn.setTitle("Add to favorites", for: .normal)
        startBtn.addTarget(self, action: #selector(openPlayWorkout), for: .touchUpInside)
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(titleView)
        scrollView.addSubview(startBtn)

//        workoutImage.image=wkoutImage
//        workoutName.text=wkoutName!
//        workoutRating.text=String(wkoutRating!)
//        workoutDuration.text=wkoutDuration
//        workoutEquipment.text=wkoutEquipment
//        workoutDescription.text=wkoutDescription
//        setupTableView()
    }
    @objc func openPlayWorkout(){
        print("in open play workout")
        let playWorkoutVC = playWorkoutController()
        
        navigationController?.pushViewController(playWorkoutVC, animated: true)
    }
    
//    func setupTableView(){
//        exerciseTable.dataSource = self
//        exerciseTable.delegate = self
//        exerciseTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return wkoutExercises.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
//        cell.textLabel!.text = wkoutExercises[indexPath.row].exercise_name
//        return cell
//    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = view.safeAreaLayoutGuide
        scrollView.centerXAnchor.constraint(equalTo: layout.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: layout.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: layout.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: layout.heightAnchor).isActive = true
    }
}

