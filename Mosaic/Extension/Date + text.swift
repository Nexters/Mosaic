//
//  Date + text.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 31..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func text(_ millisecons: Int) -> String {
        return Date(milliseconds: millisecons).text
    }
    
    var text: String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        if calendar.isDateInToday(self) {
            dateFormatter.dateFormat = "HH시 mm분"
            let now = dateFormatter.string(from: self)
            return String(describing: now)
        } else {
            dateFormatter.dateFormat = "yyyy년 M월 d일"
            let now = dateFormatter.string(from: self)
            return String(describing: now)
        }
    }
}
