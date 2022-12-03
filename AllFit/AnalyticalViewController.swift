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
    var dayDict:[String:Int]=[:]
    var yearDict:[String:Int]=[:]
    var chartStyleOfLine:ChartStyle?
    var chartStyleOfBar:ChartStyle?

    
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentWeek = thisWeek
        currentYear = getYear()
        yearL.text = currentYear
        setUpChartSytle()
        fetchData()
        
        
        

        

        
        
        // Do any additional setup after loading the view.
        
        
    }
    
    
    func fetchData(){
        guard let userEmail = Auth.auth().currentUser?.email else{
            return
        }
        
        var safeEmail = userEmail.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        Database.database().reference().child("users/\(safeEmail)").child("finishedWorkouts").observeSingleEvent(of:.value,
                                                                                       with:{snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let finishedWorkout = child.value as? [String:Any] else {
                    print("Error")
                    return
                }
                let date = finishedWorkout["date"] as! String
                let totalTime = finishedWorkout["totalTime"] as? Int ?? 0
                let dateExists = self.dayDict[date] != nil
                if dateExists{
                    var existTime = self.dayDict[date]!
                    existTime += totalTime
                    self.dayDict[date] = existTime
                }else{
                    self.dayDict[date] = totalTime
                }
                let yearStr = String(date.prefix(5))
                let yearExists = self.yearDict[yearStr] != nil
                if yearExists{
                    var existTime = self.yearDict[yearStr]!
                    existTime += totalTime
                    self.yearDict[yearStr] = existTime
                }else{
                    self.yearDict[yearStr] = totalTime
                }
                
                
                //get workout info from workouts
                //self.getWorkoutInfo(workoutID: workoutId)
            }
        
        self.showWeekChart()
        self.showYearChart()
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
    
    func showWeekChart(){
        var showList = [("Mon",0),("Tue",0), ("Wed",0),("Thu",0),("Fri",0),("Sat",0),("Sun",0)]
        var index = 0
        for date in currentWeek{
            let dateStr = dateToStr(date: date, ifnum: true)
            if dayDict[dateStr] != nil{
                showList[index].1 = dayDict[dateStr]!
            }
            index+=1
        }
        //remove subview
        for view in bgViewOfBar.subviews{
            view.removeFromSuperview()
        }
        
        let barchartView = BarChartView(data: ChartData(values: showList),title:"Week Exercise Time(h)",style: chartStyleOfBar!,form: ChartForm.extraLarge)
        let barChart = UIHostingController(rootView: barchartView)
        barChart.view.translatesAutoresizingMaskIntoConstraints = false
        barChart.view.frame = bgViewOfBar.bounds
        barChart.view.center=bgViewOfBar.center
        bgViewOfBar.addSubview(barChart.view)
        
    }
    
    func showYearChart(){
        var showList:[Double]=[]
        let helper = ["/01","/02","/03","/04","/05","/06","/07","/08","/09","/10","/11","/12"]
        for month in helper{
            let yearStr = String(currentYear.suffix(2)) + month
            if yearDict[yearStr] != nil{
                showList.append(Double(yearDict[yearStr]!))
            }else{
                showList.append(Double(0))
            }
        }
        for view in bgViewOfLine.subviews{
            view.removeFromSuperview()
        }
        let linechartView =  LineChartView(data: showList, title: "Year Exercise Time(h)", style: chartStyleOfBar!,form: ChartForm.extraLarge,rateValue: nil) // legend is optional
        
        
        let lineChart = UIHostingController(rootView: linechartView)
        lineChart.view.translatesAutoresizingMaskIntoConstraints = false
        lineChart.view.frame = bgViewOfLine.bounds
        lineChart.view.center=bgViewOfLine.center
        bgViewOfLine.addSubview(lineChart.view)
        
        
    }
    
    func setUpChartSytle(){
        chartStyleOfLine = ChartStyle(backgroundColor: Color.white, accentColor: upperColorOfLine, secondGradientColor:lowerColorOfLine , textColor: Color.gray, legendTextColor: Color.gray, dropShadowColor: Color.gray)
        
        chartStyleOfBar = ChartStyle(backgroundColor: Color.white, accentColor: upperColorOfBar, secondGradientColor:lowerColorOfBar , textColor: Color.gray, legendTextColor: Color.gray, dropShadowColor: Color.gray)
    }
    
    
    @IBAction func preWeek(_ sender: Any) {
        let thisMon = currentWeek[0]
        let preMon = thisMon.perviousMonday()
        currentWeek = preMon.currentWeek()
        showDate()
        showWeekChart()
        
    }
    
    
    @IBAction func nextWeek(_ sender: Any) {
        let thisSun = currentWeek.last!
        let nextMon = thisSun.nextWeekMonday()
        currentWeek = nextMon.currentWeek()
        showDate()
        showWeekChart()
    }
    
    @IBAction func preYear(_ sender: Any) {
        let yearN = Int(currentYear)
        currentYear = String(yearN!-1)
        yearL.text = currentYear
        showYearChart()
    }
    
    
    @IBAction func nextYear(_ sender: Any) {
        let yearN = Int(currentYear)
        currentYear = String(yearN!+1)
        yearL.text = currentYear
        showYearChart()
    }
    
    
    
    func dateToStr(date:Date,ifnum:Bool) -> String{
        let dateFormatter = DateFormatter()
        if ifnum{
            dateFormatter.dateFormat = "YY/MM/dd"
        }else{
            dateFormatter.dateFormat = "y,MMM d"
        }
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
        let end = currentWeek.last
        if currentWeek == thisWeek{
            test.text = "This Week"
        }else{
            test.text = dateToStr(date: start,ifnum: false)+" - "+dateToStr(date: end!,ifnum: false)
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
