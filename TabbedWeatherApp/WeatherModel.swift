//
//  WeatherModel.swift
//  TabbedWeatherApp
//
//  Created by Alex Sobolevski on 4/12/17.
//  Copyright © 2017 Alex Sobolevski. All rights reserved.
//

import Foundation
import CoreData

class WeatherModel {
    
    func getWeather(in region:(latitude: Double, longitude: Double), completion: @escaping (Weather) -> Void) -> Void {
        let container = NSPersistentContainer.init(name: "WeatherHistory")
        container.loadPersistentStores(completionHandler: { description, error -> Void in
            if error != nil {
                print(error!)
            }
        })
        let context = container.newBackgroundContext()
        
        do {
            let request = NSFetchRequest<WeatherData>.init(entityName: "WeatherData")
            let calendar = Calendar.current
            let date = calendar.date(byAdding: .hour, value: -1, to: Date())
            let predicate = NSPredicate(format: "date > %@", date! as CVarArg)
            request.predicate = predicate
            let result = try context.fetch(request)
            if (result.count > 0){
                let weather = Weather(city: result[0].city, temperature: result[0].temperature, status: result[0].status)
                completion(weather)
            } else {
                let dataReceiver = ApiDataReceiver.shared
                dataReceiver.getWeather(in: region) { success, weather -> Void in
                    if success && weather != nil {
                        let managedObject = NSEntityDescription.insertNewObject(forEntityName: "WeatherData", into: context)
                        managedObject.setValue(Date(), forKey: "date")
                        managedObject.setValue(weather!.city, forKey: "city")
                        managedObject.setValue(weather!.status, forKey: "status")
                        managedObject.setValue(weather!.temperature, forKey: "temperature")
                        print(managedObject)
                        do {
                            try context.save()
                            
                        } catch let error {
                            print(error)
                        }
                        completion(weather!)
                    }
                }
            }
        } catch let error {
            print(error)
        }
        
        
    }
    
}
