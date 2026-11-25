//
//  CalendarHelper.swift
//  NuresDev
//
//  Created by Mahmoud Elzaiady on 16/10/2022.
//

import Foundation
import UIKit

var currentDate = Date()

class CalendarHelper {
    static var displayLocale: Locale {
        Locale(identifier: LanguageManger.shared.currentLanguage == .ar ? "ar" : "en_GB")
    }

    static func displayDate(_ value: String, format: String = "EEEE، d MMMM yyyy") -> String {
        let parser = DateFormatter()
        parser.locale = Locale(identifier: "en_US_POSIX")
        parser.calendar = Calendar(identifier: .gregorian)
        parser.dateFormat = "yyyy-MM-dd"
        parser.isLenient = false
        guard let date = parser.date(from: value) else { return value }
        let formatter = DateFormatter()
        formatter.locale = displayLocale
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }

    static func displayTime(_ value: String) -> String {
        let normalized = value.replacingOccurrences(of: "ص", with: "AM")
            .replacingOccurrences(of: "م", with: "PM")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let parser = DateFormatter()
        parser.locale = Locale(identifier: "en_US_POSIX")
        parser.calendar = Calendar(identifier: .gregorian)
        parser.isLenient = false
        for format in ["HH:mm:ss", "HH:mm", "h:mm a", "h:mm:ss a", "yyyy-MM-dd h:mm a"] {
            parser.dateFormat = format
            if let date = parser.date(from: normalized) {
                let formatter = DateFormatter()
                formatter.locale = displayLocale
                formatter.calendar = Calendar(identifier: .gregorian)
                formatter.dateFormat = "h:mm a"
                formatter.amSymbol = LanguageManger.shared.currentLanguage == .ar ? "ص" : "AM"
                formatter.pmSymbol = LanguageManger.shared.currentLanguage == .ar ? "م" : "PM"
                return formatter.string(from: date)
            }
        }
        return value
    }

    let calendar = Calendar.current
    
    func plusMonth(date: Date) -> Date {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func minusMonth(date: Date) -> Date {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func monthString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }
    
    func monthNumberString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: date)
    }
    
    func yearString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    func dayString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }
    
    func dateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: date)
    }
   
    func timeString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a"
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: date)
    }
    
    func hourString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh"
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: date)
    }
    
    func minuteString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: date)
    }
    
    func daysInMonth(date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func dayOfMonth(date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func firstOfMonth(date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func weekDay(date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
    
    func addDays(date: Date, days: Int) -> Date {
        return calendar.date(byAdding: .day, value: days, to: date)!
    }
    
    func sundayForDate(date: Date) -> Date {
        var current = date
        let oneWeekAgo = addDays(date: current, days: -7)
        
        while current > oneWeekAgo {
            let currentWeekDay = calendar.dateComponents([.weekday], from: current).weekday
            if currentWeekDay == 1 {
                return current
            }
            current = addDays(date: current, days: -1)
        }
        return current
    }
    
    //بتباصي لها الشهر والسنة ترجع لك الشهر دا فيه كا يوم والسنة دي فيها كام يوم
    func getMonthYearDays(year: Int, month: Int) -> (Int, Int) {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents) ?? Date()
        let yearRange = calendar.range(of: .day, in: .year, for: date)!
        let monthRange = calendar.range(of: .day, in: .month, for: date)!
        let yearDays = yearRange.count
        let monthDays = monthRange.count
        return (yearDays, monthDays)
    }
    
    func changeTimeFormat(time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: time)

        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "hh:mm a"

        let newTime = newFormatter.string(from: date ?? Date())
        return newTime
    }
    
    func changeDateFormat(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)

        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MM/dd/yyyy"

        let newTime = newFormatter.string(from: date ?? Date())
        return newTime
    }
    
}
