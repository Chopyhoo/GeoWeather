//
//  TableViewDataSource.swift
//  TabbedWeatherApp
//
//  Created by Alex Sobolevski on 4/13/17.
//  Copyright © 2017 Alex Sobolevski. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class WeatherDataSource: NSObject, UITableViewDataSource {
    
    private var weatherData = [WeatherData]()
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    private let dateFormatter: DateFormatter
    
    override init() {
        container = NSPersistentContainer.init(name: "WeatherHistory")
        container.loadPersistentStores(completionHandler: { description, error -> Void in
            if error != nil {
                print(error!)
            }
        })
        
        context = container.newBackgroundContext()
        let request = NSFetchRequest<WeatherData>.init(entityName: "WeatherData")
        do {
            weatherData = try context.fetch(request) as [WeatherData]
        } catch let error {
            print(error)
        }
        
        dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        super.init()
    }
    
    func getAdditionalInfo(index: Int) -> Weather {
        let weather = Weather(weatherData: weatherData[index])
        return weather
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherCell

        cell.cityName.text = weatherData[indexPath.row].city
        
        if let date = weatherData[indexPath.row].date {
            cell.date.text = dateFormatter.string(from: date as Date)
        }
        
        cell.longitude.text = "lon: \(weatherData[indexPath.row].longitude)"
        cell.latitude.text = "lat: \(weatherData[indexPath.row].latitude)"
        //cell.latitude.text = "\(round(weatherData[indexPath.row].temperature*10)/10) ℃"

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }
}

