//
//  Date+Format.swift
//  reignmobiletest
//
//  Created by Diego Alfaro Vives on 8/27/21.
//  Copyright © 2021 Diego Alfaro. All rights reserved.
//

import UIKit
extension Date {
    static func fromServerDateString(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter.date(from: dateString)!
    }
    
    static func timeElapsed(from date: Date) -> String  {
        let timeInterval = Date().timeIntervalSince(date)
        return getTimeString(from: timeInterval)
    }
    
    private static func getTimeString(from timeInterval: TimeInterval) -> String {
        //1. Formats: Minutes, Hours, Days (1 is Yesterday)
        
        let minutes: Int = Int(timeInterval / 60)
        
        if minutes < 60 {
            return "\(minutes)m"
        } else {
            let hours: Int = minutes / 60
            if hours < 24 {
                return "\(hours)h"
            } else {
                let days: Int = hours / 24
                if days == 1 {
                    return "Yesterday"
                } else {
                    return "\(days)d"
                }
            }
        }
    }
}
