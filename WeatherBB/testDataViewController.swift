//
//  testDataViewController.swift
//  WeatherBB
//
//  Created by Mustafa Saeed on 8/3/17.
//  Copyright © 2017 Mustafa Saeed. All rights reserved.
//

import UIKit
import CoreLocation


class testDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var metricSegmentControl: UISegmentedControl!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var WeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var latitude : Double = 0.0
    var longitude: Double = 0.0
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather: Weather!
    var forecast: Forecast!
    var forecasts = [Forecast]()
    let downloader = JSONDownloader()

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
        currentWeather._latitude = latitude
        currentWeather._longitude = longitude
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //locationAuthStatus()
        getData()
    }
    
    func getData(){
        currentWeather.downloadWeatherDetails {_ in
            self.downloadForecastData {_ in
                self.updateMainUI()
            }
        }
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            currentWeather.downloadWeatherDetails {_ in 
                self.downloadForecastData {_ in
                    self.updateMainUI()
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    func downloadForecastData(completed: @escaping DownloadWeatherComplete) {
        //Downloading forecast weather data for TableView
        
        let url = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(latitude)&lon=\(longitude)&cnt=10&mode=json&appid=c6e381d8c7ff98f0fee43775817cf6ad"
        
        let request = URLRequest(url: URL(string: url)!)
        
        let task = downloader.jsonTask(with: request) { json, error in
            
            //running asynchronous stuff on the main thread, use this method!
            //if you're on a background queue and you want to make changes to the UI call this method.
            DispatchQueue.main.async {
                guard let json = json else {
                    completed(error)
                    return
                }
                
                //print(json["daily"] as? [String: AnyObject]!)
                let result = json
                if let dict = result as? Dictionary<String, AnyObject> {
                    
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
                completed(nil)

            }
        }
        
        task.resume()
        
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
