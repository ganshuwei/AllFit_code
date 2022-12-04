//
//  myDropdownViewController.swift
//  MyDropdown
//
//  Created by Rajitha Gayashan on 2022-05-29.
//

import UIKit
import DropDown

class myDropdownViewController: UIViewController {

    @IBOutlet weak var myDropDownView: UIView!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var countryLabel: UILabel!
    
    let myDropDown = DropDown()
    let countryValuesArray = ["value1", "value2", "value3", "value4", "value5"]
    
    @IBAction func isTappeddropdownButton(_ sender: Any) {
        myDropDown.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myDropDown.anchorView = myDropDownView
        myDropDown.dataSource = countryValuesArray
        
        myDropDown.bottomOffset = CGPoint(x: 0, y: (myDropDown.anchorView?.plainView.bounds.height)!)
        myDropDown.topOffset = CGPoint(x: 0, y: -(myDropDown.anchorView?.plainView.bounds.height)!)
        myDropDown.direction = .bottom
        
        myDropDown.selectionAction = { (index: Int, item: String) in
            self.countryLabel.text = self.countryValuesArray[index]
            self.countryLabel.textColor = .black
        }
    }
}
