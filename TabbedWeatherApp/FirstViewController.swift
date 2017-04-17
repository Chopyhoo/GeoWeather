//
//  FirstViewController.swift
//  TabbedWeatherApp
//
//  Created by Alex Sobolevski on 4/12/17.
//  Copyright © 2017 Alex Sobolevski. All rights reserved.
//

import UIKit
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate  {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var adviseLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    
    
    private let locationManager = CLLocationManager()
    private var location: CLLocation? {
        didSet {
            if let location = location {
                checkWeather(in: location)
            }
        }
    }
    private var model: WeatherModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = WeatherModel()
        checkStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkStatus()
    }
    
    func checkWeather(in location: CLLocation) {
        model.getWeather(in: (location.coordinate.latitude, location.coordinate.longitude)) {[weak self] weather -> Void in
            guard self != nil else { return }
            DispatchQueue.main.async {
                self!.cityLabel.text = weather.city
                if let temperature = weather.temperature {
                    let tempText = "\(round(temperature*10)/10) ℃"
                    self!.tempLabel.text = tempText
                }
                self!.statusLabel.text = weather.status
                if let advise = WeatherStatus(rawValue: weather.status!) {
                    switch (advise) {
                    case .clear:
                        self!.adviseLabel.text = "Great weather out here"
                        self!.view.backgroundColor = UIColor(red: 126/255, green: 192/255, blue: 238/255, alpha: 0.8)
                    case .clouds:
                        self!.adviseLabel.text = "It is pretty cloudy"
                        self!.view.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 0.8)
                    case .snow:
                        self!.adviseLabel.text = "You better wear something warm"
                        self!.view.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 250/255, alpha: 1)
                    case .rain:
                        self!.adviseLabel.text = "You should take an umbrella"
                        self!.view.backgroundColor = UIColor(red: 126/255, green: 140/255, blue: 180/255, alpha: 0.8)
                    case .thunderstorm:
                        self!.adviseLabel.text = "Zeus is out somewhere"
                        self!.view.backgroundColor = UIColor(red: 45/255, green: 54/255, blue: 86/255, alpha: 0.8)
                    case .extreme:
                        self!.adviseLabel.text = "RUN YOU FOOLS"
                        self!.view.backgroundColor = UIColor(red: 255/255, green: 123/255, blue: 36/255, alpha: 1)
                    case .drizzle:
                        self!.adviseLabel.text = "Not really pleasant weather out there"
                        self!.view.backgroundColor = UIColor(red: 106/255, green: 120/255, blue: 180/255, alpha: 0.8)
                    case .atmosphere, .additional:
                        self!.adviseLabel.text = "ツ"
                        self!.view.backgroundColor = UIColor(red: 126/255, green: 192/255, blue: 238/255, alpha: 0.8)
                    case .mist:
                        self!.adviseLabel.text = "Do you know what it does to you, James? When you're hated, picked on, spit on, just cause of the way you look? After you've been laughed at your whole friggin' life?"
                        self!.view.backgroundColor = UIColor(red: 151/255, green: 143/255, blue: 153/255, alpha: 0.9)
                    }
                }
                else {
                    self!.adviseLabel.text = "I don't know what to suggest"
                    self!.view.backgroundColor = UIColor(red: 126/255, green: 192/255, blue: 238/255, alpha: 0.8)
                }
                let longitude = (round(weather.longitude!)*10)/10
                let latitude = (round(weather.latitude!)*10)/10
                self!.coordinatesLabel.text = "lon: \(longitude) lat: \(latitude)"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkStatus() {
        let authStatus = CLLocationManager.authorizationStatus()
        guard authStatus == .authorizedWhenInUse else {
            switch authStatus {
            case .denied, .restricted:
                let alert = UIAlertController(
                    title: "Location services for this app are disabled",
                    message: "In order to get your current location, please open Settings for this app, choose \"Location\"  and set \"Allow location access\" to \"While Using the App\".",
                    preferredStyle: .alert
                )
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let openSettingsAction = UIAlertAction(title: "Open Settings", style: .default) {
                    action in
                    if let url = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                alert.addAction(cancelAction)
                alert.addAction(openSettingsAction)
                present(alert, animated: true, completion: nil)
                return
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                getLocation()
                
            default:
                print("Oops! Shouldn't have come this far.")
            }
            return
        }
        getLocation()
    }
    
    func getLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            showSimpleAlert(
                title: "Please turn on location services",
                message: "This app needs location services in order to report the weather " +
                    "for your current location.\n" +
                "Go to Settings → Privacy → Location Services and turn location services on."
            )
            return
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // This method is called asynchronously, which means it won't execute in the main queue.
        // All UI code needs to execute in the main queue, which is why we're wrapping the call
        // to showSimpleAlert(title:message:) in a dispatch_async() call.
        print("locationManager didFailWithError: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkStatus()
    }
    
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style:  .default,
            handler: nil
        )
        alert.addAction(okAction)
        present(
            alert,
            animated: true,
            completion: nil
        )
    }
    
}

