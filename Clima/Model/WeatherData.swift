//
//  WeatherData.swift
//  Clima
//
//  Created by Ahmed Abdelfatah on 29/08/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let timezone: Int
    let main: Main
    let weather: [Info]
    let name: String
}
struct Main: Decodable{
    let temp: Double
}
struct Info: Decodable{
    let description: String
    let id: Int
}
