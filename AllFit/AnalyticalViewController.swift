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
import CoreMedia
import DropDown
import Charts




class AnalyticalViewController: UIViewController {
    @IBOutlet weak var bgViewOfBar: UIView!
    @IBOutlet weak var bgViewOfLine: UIView!
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var preBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var preY: UIButton!
    @IBOutlet weak var nextY: UIButton!
    @IBOutlet weak var yearL: UILabel!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var dropDownView1: UIView!
    @IBOutlet weak var weekChartType: UILabel!
    @IBOutlet weak var yearChartType: UILabel!
    @IBOutlet weak var downClickOfWeek: UIButton!
    @IBOutlet weak var downClickOfYear: UIButton!
    let myDropDownWeek = DropDown()
    let myDropDownYear = DropDown()
    let typeArray = ["Bar Chart","Line Chart"]
    let typeArray1 = ["Bar Chart","Line Chart"]
    let upperColorOfBar = Color("u")
    let lowerColorOfBar = Color("d")
    let upperColorOfLine = Color("2")
    let lowerColorOfLine = Color("1")
    let upperColorOfBar1 = Color("2-1")
    let lowerColorOfBar1 = Color("1-1")
    var currentWeek:[Date]!
    var currentYear:String!
    let thisWeek = Date.today().currentWeek()
    var dayDict:[String:Int]=[:]
    var yearDict:[String:Int]=[:]
    var chartStyleOfLine:ChartStyle?
    var chartStyleOfBar:ChartStyle?
    var chartStyleOfBar1:ChartStyle?
    var ifWeekBarChart=true
    var ifYearBarChart=true
    var weekView:UIView?
    var yearView:UIView?

    
    
    

    
    override func viewWillAppear(_ animated: Bool)  {
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentWeek = thisWeek
        currentYear = getYear()
        yearL.text = currentYear
        setUpChartSytle()
        fetchData()
        setupDropDown()
        
        let barchartView = BarChartView(data: ChartData(values: [("Mon",63150),("Tue",77550), ("Wed",79600), ("Thu",92550),("Fri",92550),("Sat",92550),("Sun",92550)]),title:"Week Exercise Time(h)",style: chartStyleOfBar!,form: ChartForm.extraLarge)

        let linechartView =  LineChartView(data: [8,23,54,80,12,37,7,23,43,12,31,23], title: "Year Exercise Time(h)", style: chartStyleOfBar!,form: ChartForm.extraLarge,dropShadow: false) // legend is optional

        let barChart = UIHostingController(rootView: barchartView)
        barChart.view.translatesAutoresizingMaskIntoConstraints = false
        barChart.view.frame = bgViewOfBar.bounds
        barChart.view.center=bgViewOfBar.center
        bgViewOfBar.addSubview(barChart.view)
        weekView = barChart.view

//        // First, add the view of the child to the view of the parent
//        bgViewOfBar.addSubview(barChart.view)
//        // Then, add the child to the parent
//        //self.addChild(child)
//
        let lineChart = UIHostingController(rootView: linechartView)
        lineChart.view.translatesAutoresizingMaskIntoConstraints = false
        lineChart.view.frame = bgViewOfLine.bounds
        lineChart.view.center=bgViewOfLine.center
        bgViewOfLine.addSubview(lineChart.view)
        yearView = lineChart.view
        
        
        
        
        

        

        
        
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
        var showList1 = [Double(0),Double(0),Double(0),Double(0),Double(0),Double(0),Double(0)]
        var index = 0
        for date in currentWeek{
            let dateStr = dateToStr(date: date, ifnum: true)
            if dayDict[dateStr] != nil{
                if ifWeekBarChart{
                    showList[index].1 = dayDict[dateStr]!
                }else{
                    showList1[index] = Double(dayDict[dateStr]!)
                }
                
            }
            index+=1
        }
        //remove subview
        if ifWeekBarChart{
            let chartView = BarChartView(data: ChartData(values: showList),title:"Week Exercise Time(s)",style: self.chartStyleOfBar!,form: ChartForm.extraLarge,dropShadow: false)
            let chart = UIHostingController(rootView: chartView)
            chart.view.translatesAutoresizingMaskIntoConstraints = false
            chart.view.frame = self.bgViewOfBar.bounds
            chart.view.center=self.bgViewOfBar.center
            
            self.bgViewOfBar.addSubview(chart.view)
            weekView?.removeFromSuperview()
            weekView = chart.view
            
        }else{
            let chartView = LineChartView(data: showList1, title: "Week Exercise Time(s)", style: self.chartStyleOfLine!, form: ChartForm.extraLarge,rateValue:nil,dropShadow: false)
            let chart = UIHostingController(rootView: chartView)
            chart.view.translatesAutoresizingMaskIntoConstraints = false
            chart.view.frame = self.bgViewOfBar.bounds
            chart.view.center=self.bgViewOfBar.center
            self.bgViewOfBar.addSubview(chart.view)
            yearView?.removeFromSuperview()
            yearView = chart.view
        }

        
    }
    
    func showYearChart(){
        var showList1:[Double]=[]
        var showList2:[(String,Int)]=[]
        let helper = ["/01","/02","/03","/04","/05","/06","/07","/08","/09","/10","/11","/12"]
        var index = 1
        for month in helper{
            let yearStr = String(currentYear.suffix(2)) + month
            if yearDict[yearStr] != nil{
                if ifYearBarChart{
                    let added = (String(index),yearDict[yearStr]!)
                    showList2.append(added)
                }else{
                    showList1.append(Double(yearDict[yearStr]!))
                }
            }else{
                if ifYearBarChart{
                    let added = (String(index),0)
                    showList2.append(added)
                }else{
                    showList1.append(Double(0))
                }
                
            }
            index += 1
        }

        if ifYearBarChart{
            let chartView = BarChartView(data: ChartData(values: showList2),title:"Year Exercise Time(s)",style: self.chartStyleOfBar1!,form: ChartForm.extraLarge,dropShadow: false)
            let chart = UIHostingController(rootView: chartView)
            chart.view.translatesAutoresizingMaskIntoConstraints = false
            chart.view.frame = self.bgViewOfLine.bounds
            chart.view.center=self.bgViewOfLine.center
            self.bgViewOfLine.addSubview(chart.view)
            
        }else{
            let chartView = LineChartView(data: showList1, title: "Year Exercise Time(s)", style: self.chartStyleOfLine!, form: ChartForm.extraLarge,rateValue:nil,dropShadow: false)
            let chart = UIHostingController(rootView: chartView)
            chart.view.translatesAutoresizingMaskIntoConstraints = false
            chart.view.frame = self.bgViewOfLine.bounds
            chart.view.center=self.bgViewOfLine.center
            self.bgViewOfLine.addSubview(chart.view)
        }
        
        
 // legend is optional
            
            

        

        
        
    }
    
    
    func setUpChartSytle(){
        chartStyleOfLine = ChartStyle(backgroundColor: Color.white, accentColor: upperColorOfLine, secondGradientColor:lowerColorOfLine , textColor: Color.gray, legendTextColor: Color.gray, dropShadowColor: Color.gray)
        
        chartStyleOfBar = ChartStyle(backgroundColor: Color.white, accentColor: upperColorOfBar, secondGradientColor:lowerColorOfBar , textColor: Color.gray, legendTextColor: Color.gray, dropShadowColor: Color.gray)
        
        chartStyleOfBar1 = ChartStyle(backgroundColor: Color.white, accentColor: upperColorOfBar1, secondGradientColor:lowerColorOfBar1 , textColor: Color.gray, legendTextColor: Color.gray, dropShadowColor: Color.gray)
        
    }
    
    
    @IBAction func preWeek(_ sender: Any) {
        preWeekBtn()
    }
    
    func preWeekBtn(){
        let thisMon = currentWeek[0]
        let preMon = thisMon.perviousMonday()
        currentWeek = preMon.currentWeek()
        showDate()
        showWeekChart()
    }
    
    func nextWeekBtn(){
        let thisSun = currentWeek.last!
        let nextMon = thisSun.nextWeekMonday()
        currentWeek = nextMon.currentWeek()
        showDate()
        showWeekChart()
    }
    
    
    @IBAction func nextWeek(_ sender: Any) {
        nextWeekBtn()
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
    
    @IBAction func chooseChartTypeOfWeek(_ sender: Any) {
        myDropDownWeek.show()
    }
    
    
    @IBAction func chooseChartTypeOfYear(_ sender: Any) {
        myDropDownYear.show()
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
    
    func setupDropDown(){
        myDropDownWeek.anchorView = dropDownView
        myDropDownWeek.dataSource = typeArray
        
        myDropDownWeek.bottomOffset = CGPoint(x: 0, y: (myDropDownWeek.anchorView?.plainView.bounds.height)!)
        myDropDownWeek.topOffset = CGPoint(x: 0, y: -(myDropDownWeek.anchorView?.plainView.bounds.height)!)
        myDropDownWeek.direction = .bottom
        
        myDropDownWeek.selectionAction = { (index: Int, item: String) in
            self.weekChartType.text = self.typeArray[index]
            
            if index == 0{
                self.ifWeekBarChart = true
            }else{
                self.ifWeekBarChart = false
            }
            self.showWeekChart()
        }
        myDropDownYear.anchorView = dropDownView1
        myDropDownYear.dataSource = typeArray
        
        myDropDownYear.bottomOffset = CGPoint(x: 0, y: (myDropDownYear.anchorView?.plainView.bounds.height)!)
        myDropDownYear.topOffset = CGPoint(x: 0, y: -(myDropDownYear.anchorView?.plainView.bounds.height)!)
        myDropDownYear.direction = .bottom
        
        myDropDownYear.selectionAction = { (index: Int, item: String) in
            self.yearChartType.text = self.typeArray[index]
            
            if index == 0{
                self.ifYearBarChart = true
            }else{
                self.ifYearBarChart = false
            }
            self.showYearChart()
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
