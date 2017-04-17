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
    
    var latitude: Double?
    
    var longitude: Double?
    
    init() {}
    
    init?(map: Map) {}
    
    init(city: String?, temperature: Double?, status: String?, longitude: Double?, latitude: Double?) {
        self.city = city
        self.temperature = temperature
        self.status = status
        self.longitude = longitude
        self.latitude = latitude
    }
    
    init(weatherData: WeatherData) {
        self.city = weatherData.city
        self.temperature = weatherData.temperature
        self.status = weatherData.status
        self.longitude = weatherData.longitude
        self.latitude = weatherData.latitude
    }
    
    mutating func mapping(map: Map) {
        city <- map["name"]
        temperature <- map["main.temp"]
        status <- map["weather.0.main"]
        latitude <- map["coord.lat"]
        longitude <- map["coord.lon"]
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
