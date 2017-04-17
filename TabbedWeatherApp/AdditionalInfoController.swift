//
//  AdditionalInfoController.swift
//  TabbedWeatherApp
//
//  Created by Alex Sobolevski on 4/17/17.
//  Copyright © 2017 Alex Sobolevski. All rights reserved.
//

import UIKit

class AdditionalInfoController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    
    var weather = Weather()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityLabel.text = weather.city
        if let temperature = weather.temperature {
            let tempText = "\(round(temperature*10)/10) ℃"
            tempLabel.text = tempText
        }
        statusLabel.text = weather.status
        let longitude = (round(weather.longitude!)*10)/10
        let latitude = (round(weather.latitude!)*10)/10
        coordinatesLabel.text = "lon: \(longitude) lat: \(latitude)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
