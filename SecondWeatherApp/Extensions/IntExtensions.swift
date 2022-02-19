//
//  IntExtensions.swift
//  SecondWeatherApp
//
//  Created by Shakhzod Bektemirov on 2022/02/19.
//

import UIKit

extension Int {
    func incrementWeekDays(by num: Int) -> Int {
        let incrementedVal = self + num
        let mod = incrementedVal % 7
        
        return mod
    }
}

