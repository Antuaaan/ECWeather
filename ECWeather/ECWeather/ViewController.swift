//
//  ViewController.swift
//  ECWeather
//
//  Created by Anton Mansvelt on 2017/05/18.
//  Copyright © 2017 Anton Mansvelt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let longitude = 18.4241
let latitude = -33.9249
let fifteenMinutes = 60*15.0
let twentyMinutes = 60*20.0

let standard = UserDefaults.standard

var allDays : [[String:Any]] = []

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if standard.value(forKey: "allDays") != nil{
            allDays = standard.value(forKey: "allDays") as! [[String : Any]]
        }
        
        if allDays.count < 1{
            self.getForecast()
        }
        
        Timer.scheduledTimer(timeInterval: twentyMinutes, target: self, selector:#selector(getForecast), userInfo: nil, repeats: true)
    }
    
    func getForecast(){
        let URL = "http://ec-weather-proxy.appspot.com/forecast/29e4a4ce0ec0068b03fe203fa81d457f/-33.9249,18.4241'?delay=5&chaos=0.2"
        
        let request = Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                if (response.result.isSuccess){
                    var json = JSON(response.result.value!)
                    let data :Array<JSON> = json["daily"]["data"].arrayValue
//                    print ("data = \(data)")
                    allDays.removeAll()
                    for one in data {
                        let minTemp = self.convertToCelsius(fahrenheit: one["temperatureMin"].intValue)
                        let maxTemp = self.convertToCelsius(fahrenheit: one["temperatureMax"].intValue)
                        let minTime = Date(timeIntervalSince1970: TimeInterval(one["apparentTemperatureMinTime"].intValue)).ToLocalStringWithFormat("hh:mm")
                        let maxTime = Date(timeIntervalSince1970: TimeInterval(one["temperatureMaxTime"].intValue)).ToLocalStringWithFormat("hh:mm")
                        let time = Date(timeIntervalSince1970: TimeInterval(one["time"].intValue)).ToLocalStringWithFormat("yyyy-MM-dd")
                        
                        let oneDic = ["date":time,"minTemp":minTemp,"minTime":minTime,"maxTemp":maxTemp,"maxTime":maxTime] as [String : Any]
                        allDays.append(oneDic)
                    }
//                    print ("json = \(json)")
//                    print ("allDays = \(allDays)")
                    standard.set(allDays, forKey: "allDays")
                    self.tableview.reloadData()
                }
                else if (response.result.isFailure){
                    print ("ERROR = \(String(describing: response.error))")
                    self.getForecast()
                }
        
        }
        print ("request = \(request)")
    }
    
    func convertToCelsius(fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("\(allDays.count) values expected")
        return allDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        let oneValue = allDays[indexPath.row]
        cell.date.text = oneValue["date"] as? String
        cell.time.text = "\(oneValue["minTime"]!) Min : \(oneValue["minTemp"]!) "
        cell.temp.text = "\(oneValue["maxTime"]!) Max : \(oneValue["maxTemp"]!)"
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
extension Date{
    func ToLocalStringWithFormat(_ dateFormat: String) -> String {
        // change to a readable time format and change to local time zone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let timeStamp = dateFormatter.string(from: self)
        
        return timeStamp
    }
}
