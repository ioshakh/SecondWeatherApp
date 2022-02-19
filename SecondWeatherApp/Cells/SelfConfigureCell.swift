//
//  SelfConfigureCell.swift
//  SecondWeatherApp
//
//  Created by Shakhzod Bektemirov on 2022/02/19.
//

import UIKit

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with item: ForecastTemperature)
}

