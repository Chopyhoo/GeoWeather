//
//  SecondViewController.swift
//  TabbedWeatherApp
//
//  Created by Alex Sobolevski on 4/12/17.
//  Copyright © 2017 Alex Sobolevski. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var historyTableView: UITableView!
    
    private var dataSourceModel: WeatherDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSourceModel = WeatherDataSource()
        historyTableView.delegate = self
        historyTableView.dataSource = dataSourceModel!
        historyTableView.rowHeight = UITableViewAutomaticDimension
        historyTableView.estimatedRowHeight = 50
        historyTableView.tableFooterView = UIView()
        historyTableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        historyTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showAdditionalInfo", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAdditionalInfo" {
            let vc = segue.destination as! AdditionalInfoController
                vc.weather = (dataSourceModel?.getAdditionalInfo(index: sender as! Int))!
        }
    }
}

