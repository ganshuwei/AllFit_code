//
//  Extension.swift
//  AllFit
//
//  Created by 甘书玮 on 2022/12/1.
//

import Foundation

//reference:https://stackoverflow.com/questions/33397101/how-to-get-mondays-date-of-the-current-week-in-swift

extension Date{
    static func today() -> Date {
        return Date()
    }
    
    func currentWeek() -> [Date] {
        var endDate = self.nextWeekSunday()
        var startDate = self.perviousMonday()
        if getTodayWeekDay() == "Monday"{
            startDate = self
        }
        else if getTodayWeekDay() == "Sunday"{
            endDate = self
        }
        let Tues = startDate.next(.tuesday)
        let Wed = startDate.next(.wednesday)
        let Thur = startDate.next(.thursday)
        let Fri = startDate.next(.friday)
        let Sat = startDate.next(.saturday)
        return [startDate,Tues,Wed,Thur,Fri,Sat,endDate]
        
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
      return get(.next,
                 weekday,
                 considerToday: considerToday)
    }
    
    func nextWeekMonday() -> Date {
        return get(.next,.monday)
    }
    
    func nextWeekSunday() -> Date{
        return get(.next,.sunday)
    }
    
    func perviousMonday() -> Date {
        return get(.previous,.monday)
    }
    
    func perviousSunday() -> Date {
        return get(.previous,.sunday)
    }
    
    
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {

      let dayName = weekDay.rawValue

      let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

      assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

      let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

      let calendar = Calendar(identifier: .gregorian)

      if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
        return self
      }

      var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
      nextDateComponent.weekday = searchWeekdayIndex

      let date = calendar.nextDate(after: self,
                                   matching: nextDateComponent,
                                   matchingPolicy: .nextTime,
                                   direction: direction.calendarSearchDirection)

      return date!
    }
}

//helper
extension Date{
    func getWeekDaysInEnglish() -> [String] {
      var calendar = Calendar(identifier: .gregorian)
      calendar.locale = Locale(identifier: "en_US_POSIX")
      return calendar.weekdaySymbols
    }
    
    func getTodayWeekDay()-> String{
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "EEEE"
           let weekDay = dateFormatter.string(from: self)
           return weekDay
     }

    enum Weekday: String {
      case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }

    enum SearchDirection {
      case next
      case previous

      var calendarSearchDirection: Calendar.SearchDirection {
        switch self {
        case .next:
          return .forward
        case .previous:
          return .backward
        }
      }
    }
}



