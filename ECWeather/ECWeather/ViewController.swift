//
//  ViewController.swift
//  ECWeather
//
//  Created by Anton Mansvelt on 2017/05/18.
//  Copyright © 2017 Anton Mansvelt. All rights reserved.
//

import UIKit
import SwiftSky
import Alamofire
import SwiftyJSON

let longitude = 18.4241
let latitude = -33.9249

let standard = UserDefaults.standard
var forecast : Forecast = standard.value(forKeyPath: "forecast") as! Forecast

struct oneDay {
    var date : String
    var minTemp : String
    var minTime : String
    var maxTemp : String
    var maxTime : String
}

var allDays : [oneDay] = []
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.setupSwiftSky()
//        self.getSwiftSkyForecast()
        
        self.getForecast()
    }
    
    func getForecast(){
        let URL = "http://ec-weather-proxy.appspot.com/forecast/29e4a4ce0ec0068b03fe203fa81d457f/-33.9249,18.4241?delay=5&chaos=0.2"
        
        let request = Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                if (response.result.isSuccess){
                    var json = JSON(response.result.value!)
                    let data :Dictionary<String,JSON> = json["data"].dictionaryValue
                    allDays.removeAll()
                    for one in data {
                        let new = oneDay(date: one.["time"], minTemp: one.["temperatureMin"], minTime: one.["apparentTemperatureMinTime"], maxTemp: one.["temperatureMax"], maxTime: one.["temperatureMaxTime"])
                    }
                    print ("json = \(json)")
                }
                else if (response.result.isFailure){
                    print ("ERROR = \(String(describing: response.error))")
                }
        
        }
        print ("request = \(request)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func setupSwiftSky(){
        SwiftSky.secret = "29e4a4ce0ec0068b03fe203fa81d457f"
        SwiftSky.hourAmount = .fortyEight
        
        SwiftSky.language = .english
        
        SwiftSky.locale = .autoupdatingCurrent
        
        SwiftSky.units.temperature = .celsius
        SwiftSky.units.distance = .kilometer
        SwiftSky.units.speed = .kilometerPerHour
        SwiftSky.units.pressure = .millibar
        SwiftSky.units.precipitation = .millimeter
        SwiftSky.units.accumulation = .centimeter
    }
    
    func getSwiftSkyForecast(){
        SwiftSky.get([.current, .minutes, .hours, .days, .alerts],
                     at: Location(latitude: latitude, longitude: longitude)
        ) { result in
            switch result {
            case .success(let forecast):
                // do something with forecast
                print("forecast = \(forecast)")
                standard.setValue(forecast, forKey: "forecast")
                
            case .failure(let error):
                // do something with error
                print("failed to get forecast because \(error)")
            }
        }
    }
*/

}

