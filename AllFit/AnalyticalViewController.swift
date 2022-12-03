//
//  AnalyticalViewController.swift
//  AllFit
//
//  Created by 甘书玮 on 2022/11/30.
//

import UIKit
import SwiftUICharts
import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseDatabase




class AnalyticalViewController: UIViewController {
    @IBOutlet weak var bgViewOfBar: UIView!
    @IBOutlet weak var bgViewOfLine: UIView!
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var preBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var preY: UIButton!
    @IBOutlet weak var nextY: UIButton!
    @IBOutlet weak var yearL: UILabel!
    let upperColorOfBar = Color("u")
    let lowerColorOfBar = Color("d")
    let upperColorOfLine = Color("2")
    let lowerColorOfLine = Color("1")
    var currentWeek:[Date]!
    var currentYear:String!
    let thisWeek = Date.today().currentWeek()
    var finishedList:[FinishedWorkout]=[]
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
        
        
        
        
        currentWeek = thisWeek
        currentYear = getYear()
        yearL.text = currentYear
        let chartStyleOfLine = ChartStyle(backgroundColor: Color.white, accentColor: upperColorOfLine, secondGradientColor:lowerColorOfLine , textColor: Color.gray, legendTextColor: Color.gray, dropShadowColor: Color.gray)
        
        let chartStyleOfBar = ChartStyle(backgroundColor: Color.white, accentColor: upperColorOfBar, secondGradientColor:lowerColorOfBar , textColor: Color.gray, legendTextColor: Color.gray, dropShadowColor: Color.gray)
        
        let barchartView = BarChartView(data: ChartData(values: [("Mon",63150),("Tue",77550), ("Wed",79600), ("Thu",92550),("Fri",92550),("Sat",92550),("Sun",92550)]),title:"Week Exercise Time(h)",style: chartStyleOfBar,form: ChartForm.extraLarge)
        
        let linechartView =  LineChartView(data: [8,23,54,80,12,37,7,23,43,12,31,23], title: "Year Exercise Time(h)", style: chartStyleOfBar,form: ChartForm.extraLarge,rateValue: nil) // legend is optional
        
        let barChart = UIHostingController(rootView: barchartView)
        barChart.view.translatesAutoresizingMaskIntoConstraints = false
        barChart.view.frame = bgViewOfBar.bounds
        barChart.view.center=bgViewOfBar.center
        
        
        // First, add the view of the child to the view of the parent
        bgViewOfBar.addSubview(barChart.view)
        // Then, add the child to the parent
        //self.addChild(child)
        
        let lineChart = UIHostingController(rootView: linechartView)
        lineChart.view.translatesAutoresizingMaskIntoConstraints = false
        lineChart.view.frame = bgViewOfLine.bounds
        lineChart.view.center=bgViewOfLine.center
        bgViewOfLine.addSubview(lineChart.view)

        
        
        // Do any additional setup after loading the view.
        
        
    }
    
    
    func fetchData(){
        guard let userEmail = Auth.auth().currentUser?.email else{
            return
        }
        
        var safeEmail = userEmail.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        Database.database().reference().child("users/\(safeEmail)").child("createdWorkouts").observeSingleEvent(of:.value,
                                                                                       with:{snapshot in
            print("1")
//            for case let child as DataSnapshot in snapshot.children{
//                guard let finishedWorkout = child.value as? FinishedWorkout else{
//                    print("Error")
//                    return
//                }
//                self.finishedList.append(finishedWorkout)
//            }
            
        }){error in
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func preWeek(_ sender: Any) {
        let thisMon = currentWeek[0]
        let preMon = thisMon.perviousMonday()
        let preSun = thisMon.perviousSunday()
        currentWeek = [preMon,preSun]
        showDate()
        
    }
    
    
    @IBAction func nextWeek(_ sender: Any) {
        let thisSun = currentWeek[1]
        let nextMon = thisSun.nextWeekMonday()
        let nextSun = thisSun.nextWeekSunday()
        currentWeek = [nextMon,nextSun]
        showDate()
    }
    
    @IBAction func preYear(_ sender: Any) {
        let yearN = Int(currentYear)
        currentYear = String(yearN!-1)
        yearL.text = currentYear
    }
    
    
    @IBAction func nextYear(_ sender: Any) {
        let yearN = Int(currentYear)
        currentYear = String(yearN!+1)
        yearL.text = currentYear
    }
    
    
    
    func dateToStr(date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y,MMM d"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    func getYear() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let formattedDate = dateFormatter.string(from: Date())
        return formattedDate
    }
    
    
    func showDate(){
        let start = currentWeek[0]
        let end = currentWeek[1]
        if currentWeek == thisWeek{
            test.text = "This Week"
        }else{
            test.text = dateToStr(date: start)+" - "+dateToStr(date: end)
        }

    }
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
