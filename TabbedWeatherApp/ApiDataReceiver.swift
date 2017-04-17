//
//  ApiDataReceiver.swift
//  TabbedWeatherApp
//
//  Created by Alex Sobolevski on 4/12/17.
//  Copyright © 2017 Alex Sobolevski. All rights reserved.
//

import Foundation
import ObjectMapper

class ApiDataReceiver {
    
    static let shared = ApiDataReceiver()
    
    static let mainUrl = "http://api.openweathermap.org/data/2.5/weather?"
    static let appid = "78c493c54523b7892d2a8d5f97adb891&units=metric"
    
    let sharedSession = URLSession(configuration: .default)
    
    
    private func get(request: URLRequest, completion: @escaping (Bool, Any?) -> ()) {
        print(request)
        dataTask(with: request, method: "GET", completion: completion)
    }
    
    private func dataTask(with request: URLRequest, method: String, completion: @escaping (Bool, Any?) -> ()) {
        var request = request
        request.httpMethod = method
        
        let session = sharedSession
        
        session.dataTask(with: request) { (data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse {
                    if (200...299).contains(response.statusCode) {
                        completion(true, json)
                    } else {
                        completion(false, json)
                    }
                }
            }
            }
            .resume()
    }
    
    private func clientURLRequest(path: String, parameters: Dictionary<String, Any>? = nil) -> URLRequest {
        var request = URLRequest(url: URL(string: ApiDataReceiver.mainUrl + path)!)
        if let parameters = parameters {
            var paramString = ""
            for (key, value) in parameters {
                let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let escapedValue = String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                if let escapedKey = escapedKey, let escapedValue = escapedValue {
                    paramString += "\(escapedKey)=\(escapedValue)&"
                }
            }
            request.url = URL(string: ApiDataReceiver.mainUrl + path + paramString)!
        }
        
        return request
    }
    
    
    func getWeather(in region:(latitude: Double, longitude: Double), completion: @escaping (Bool, Weather?) -> ()) {
        let parameters: [String:Any] = ["lat":region.latitude, "lon": region.longitude, "appid": ApiDataReceiver.appid]
        get(request: clientURLRequest(path: "", parameters: parameters)) { success, json -> Void in
            if success {
                if let json = json {
                    if let weather = Mapper<Weather>().map(JSONObject: json) {
                        completion(success, weather)
                    }
                }
            }
            completion(success, nil)
        }
    }
}
