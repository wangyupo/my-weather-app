//
//  ViewController.swift
//  weather2
//
//  Created by 王玉珀 on 2019/3/8.
//  Copyright © 2019 王玉珀. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

// delegate——委托
// protocol——协议
class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let weather = Weather()
    let appid = "2f683f20bf84912032b862d17b102609"

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters  // 设置位置精度，精度越高，耗电量越大
        locationManager.requestLocation()   // 请求用户位置——只请求一次
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.requestWhenInUseAuthorization() // 请求授权当前位置
    }
    
    // 当用户请求某个位置的时候立刻调用这个方法
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = locations[0].coordinate.latitude
        let lon = locations[0].coordinate.longitude
        print(lat, lon)
        
        let params = ["lat":"\(lat)", "lon":"\(lon)", "appid": appid]
        getWeather(params)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    // 导航之前做的一些准备操作——大多数情况下是传值操作
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "selectCity" {
            let vc = segue.destination as! SelectCityController
            vc.currentCity = weather.city
            vc.delegate = self
        }
    }

}

// 扩展——分离出代码，方便维护
extension ViewController: CLLocationManagerDelegate, SelectCityDelegate {
    func didChangeCiry(city: String) {
        let params = ["q": city, "appid": appid]
        getWeather(params)
    }
    
    func getWeather(_ params: [String: String]) {
        Alamofire.request("https://api.openweathermap.org/data/2.5/weather", parameters: params).responseJSON { response in
            
            if let json = response.result.value {
                let weather = JSON(json)
                print(weather)
                self.createWeather(weather)
                
                self.updateUI()
            }
            
        }
    }
    
    func createWeather(_ weatherJSON: JSON) {
        weather.city = weatherJSON["name"].stringValue
        weather.temp = Int(round(weatherJSON["main", "temp"].doubleValue - 273.15))
        weather.condition = weatherJSON["weather",0,"id"].intValue
    }
    
    func updateUI() {
        cityLabel.text = weather.city
        tempLabel.text = "\(weather.temp)˚"
        imageView.image = UIImage(named: weather.icon)
    }
}
