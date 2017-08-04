//
//  testDataViewController.swift
//  WeatherBB
//
//  Created by Mustafa Saeed on 8/3/17.
//  Copyright © 2017 Mustafa Saeed. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class testDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var metricSegmentControl: UISegmentedControl!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var WeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather: Weather!
    var forecast: Forecast!
    var forecasts = [Forecast]()

    @IBAction func addLocation(_ sender: Any) {
        
        let content = storyboard!.instantiateViewController(withIdentifier: "map") as! MapVC
        //content.type = contentType
        self.navigationController?.pushViewController(content, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        currentWeather = Weather()
        // Do any additional setup after loading the view.
//        let config = URLSessionConfiguration.default // Session Configuration
//        let session = URLSession(configuration: config) // Load configuration into Session
//        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=0&lon=0&appid=c6e381d8c7ff98f0fee43775817cf6ad&units=metric")!
//        
//        let task = session.dataTask(with: url, completionHandler: {
//            (data, response, error) in
//            
//            if error != nil {
//                
//                print(error!.localizedDescription)
//                
//            } else {
//                
//                do {
//                    
//                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
//                    {
//                        
//                        //Implement your logic
//                        print(json)
//                        
//                    }
//                    
//                } catch {
//                    
//                    print("error in JSONSerialization")
//                    
//                }
//                
//                
//            }
//            
//        })
//        task.resume()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            currentWeather.downloadWeatherDetails {
                self.downloadForecastData {
                    self.updateMainUI()
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        //Downloading forecast weather data for TableView
        Alamofire.request(FORECAST_URL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                        print(obj)
                    }
                    self.forecasts.remove(at: 0)
                    self.tableView.reloadData()
                }
            }
            completed()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
            
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return WeatherCell()
        }
    }
    
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        WeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }

}
