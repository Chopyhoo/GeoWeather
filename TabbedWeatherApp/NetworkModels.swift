//
//  NetworkModels.swift
//  TabbedWeatherApp
//
//  Created by Alex Sobolevski on 4/12/17.
//  Copyright © 2017 Alex Sobolevski. All rights reserved.
//

import Foundation
import ObjectMapper

struct Weather: Mappable {
    
    var city: String?
    
    var temperature: Double?
    
    var status: String?
    
    init?(map: Map) {}
    
    init(city: String?, temperature: Double?, status: String?) {
        self.city = city
        self.temperature = temperature
        self.status = status
    }
    
    mutating func mapping(map: Map) {
        city <- map["name"]
        temperature <- map["main.temp"]
        status <- map["weather.0.main"]
    }

}

enum WeatherStatus : String {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    case thunderstorm = "Thunderstorm"
    case snow = "Snow"
    case drizzle = "Drizzle"
    case atmosphere = "Atmosphere"
    case additional = "Additional"
    case extreme = "Extreme"
    case mist = "Mist"
}
