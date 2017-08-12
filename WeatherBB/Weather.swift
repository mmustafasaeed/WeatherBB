//
//  Weather.swift
//  WeatherBB
//
//  Created by Mustafa Saeed on 8/3/17.
//  Copyright © 2017 Mustafa Saeed. All rights reserved.
//

import UIKit

class Weather {
    
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: Double!
    var _latitude : Double!
    var _longitude : Double!
    var _minTemp : Double!
    var _maxTemp: Double!
    var _humidity: Double!
    var _windSpeed :Double!
    
    let downloader = JSONDownloader()
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    var latitudeLocation: Double {
        if _latitude == nil {
            _latitude = 0.0
        
        }
        return _latitude
    }
    
    var longitudeLocation: Double {
        if _longitude == nil {
            _longitude = 0.0
            
        }
        return _longitude
    }
    
    var minTemp : Double {
        if _minTemp == nil {
            _minTemp = 0.0
            
        }
        return _minTemp
    }
    
    var maxTemp : Double {
        if _maxTemp == nil {
            _maxTemp = 0.0
            
        }
        return _maxTemp
    }
    
    var humidity: Double {
        
        if _humidity == nil {
            _humidity = 0.0
            
        }
        return _humidity
        
    }
    
    var windSpeed: Double {
        
        if _windSpeed == nil {
            _windSpeed = 0.0
            
        }
        return _windSpeed
        
    }

    
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        //Download Current Weather Data
        let url = "\(BASE_URL)\(LATITUDE)\(latitudeLocation)\(LONGITUDE)\(longitudeLocation)\(APP_ID)\(API_KEY)"
        
        let request = URLRequest(url: URL(string: url)!)
        
        let task = downloader.jsonTask(with: request) { json, error in
            
            //running asynchronous stuff on the main thread, use this method!
            //if you're on a background queue and you want to make changes to the UI call this method.
            DispatchQueue.main.async {
                guard let json = json else {
                    completed()
                    return
                }
                
                            let result = json
                
                            if let dict = result as? Dictionary<String, AnyObject> {
                
                                if let name = dict["name"] as? String {
                                    self._cityName = name.capitalized
                                    print(self._cityName)
                                }
                
                                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                
                                    if let main = weather[0]["main"] as? String {
                                        self._weatherType = main.capitalized
                                        print(self._weatherType)
                                    }
                
                                }
                
                                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                
                                    if let currentTemperature = main["temp"] as? Double {
                
                                        let kelvinToFarenheitPreDivision = (currentTemperature * (9/5) - 459.67)
                
                                        let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                
                                        let celsiusTemp = Double(round(currentTemperature - 273.15))
                
                                        self._currentTemp = celsiusTemp
                
                                        print(self._currentTemp)
                                    }
                
                                    if let currentMin = main["temp_min"] as? Double {
                
                                        let celsiusTempMin = Double(round(currentMin - 273.15))
                
                                        self._minTemp = celsiusTempMin
                                    }
                
                                    if let currentMax = main["temp_max"] as? Double {
                
                                        let celsiusTempMax = Double(round(currentMax - 273.15))
                
                                        self._maxTemp = celsiusTempMax
                                    }
                
                                    if let humidityPercentage = main["humidity"] as? Double {
                                        
                                        let humidityValue = humidityPercentage
                                        self._humidity = humidityValue
                                    }
                                    
                                    
                                }
                                
                                if let wind = dict["wind"] as? Dictionary<String, AnyObject> {
                                    
                                    if let windSpeedValue = wind["speed"] as? Double {
                                        
                                        let speed = windSpeedValue
                                        self._windSpeed = speed
                                    }
                                }
                            }
                print(json)
                
                
                completed()
            }
        }
        
        task.resume()
        
    }

    

}
