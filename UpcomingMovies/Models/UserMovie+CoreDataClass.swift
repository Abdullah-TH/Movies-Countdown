//
//  UserMovie+CoreDataClass.swift
//  UpcomingMovies
//
//  Created by Abdullah Althobetey on 23/12/2017.
//  Copyright © 2017 Abdullah Althobetey. All rights reserved.
//
//

import Foundation
import CoreData

@objc(UserMovie)
public class UserMovie: NSManagedObject
{
    // MARK: Computed Properties
    
    var releaseDate: Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: releaseDateString)
    }
    
    var prettyDateString: String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        if let date = releaseDate
        {
            return dateFormatter.string(from: date)
        }
        
        return "Unknown"
    }
    
    var daysUntilRelease: Int {
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        if today <= releaseDate!
        {
            let differance = calendar.dateComponents([.day], from: today, to: releaseDate!)
            return differance.day!
        }
        else // today > date
        {
            let differance = calendar.dateComponents([.day], from: releaseDate!, to: today)
            return -differance.day!
        }
    }
    
    var allreadyReleased: Bool {
        
        if let releaseDate = releaseDate
        {
            return Date() > releaseDate
        }
        
        return true
    }
    
    var countdownComponents: (years: String, months: String, days: String, hours: String, minutes: String, seconds: String)? {
        
        if allreadyReleased { return nil }
        
        let calendar = Calendar.current
        let now = Date()
        let differance = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now, to: releaseDate!)
        
        let yearString = differance.year! / 10 == 0 ? "0\(differance.year!)" : "\(differance.year!)"
        let monthsString = differance.month! / 10 == 0 ? "0\(differance.month!)" : "\(differance.month!)"
        let daysString = differance.day! / 10 == 0 ? "0\(differance.day!)" : "\(differance.day!)"
        let hoursString = differance.hour! / 10 == 0 ? "0\(differance.hour!)" : "\(differance.hour!)"
        let minutesString = differance.minute! / 10 == 0 ? "0\(differance.minute!)" : "\(differance.minute!)"
        let secondsString = differance.second! / 10 == 0 ? "0\(differance.second!)" : "\(differance.second!)"
        
        return (yearString, monthsString, daysString, hoursString, minutesString, secondsString)
    }
}

















