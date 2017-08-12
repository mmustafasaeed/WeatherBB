//
//  HomeVC.swift
//  WeatherBB
//
//  Created by Mustafa Saeed on 8/4/17.
//  Copyright © 2017 Mustafa Saeed. All rights reserved.
//

import UIKit
import MapKit

class HomeVC: UIViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var items = [String]()
    let collectionViewLayout = CoinLayout()
    fileprivate var cellWidth = CGFloat(0)
    
    var isEditEnabled : Bool = false
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var city: [City] = []
    var WeatherLocationsArray: NSMutableArray = []
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionViewLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = collectionViewLayout
        collectionViewLayout.offsetX = -(33 / 2)
        
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(HomeVC.handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self as UIGestureRecognizerDelegate
        collectionView.addGestureRecognizer(lpgr)
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        print("you pressed me")
        if isEditEnabled == false {
            editButton.title = "Done"
            isEditEnabled = true
        } else {
            isEditEnabled = false
            editButton.title = "Edit"
        }
        
    }

    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            return
        }
                let p = gestureReconizer.location(in: self.collectionView)
                let indexPath = self.collectionView.indexPathForItem(at: p)
                
                if let index = indexPath {
                    let cell = self.collectionView.cellForItem(at: index)
                    
                }

        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()

    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
                
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()
    }
    
    func getData() {
        
        WeatherLocationsArray.removeAllObjects()
        do {
            city = try context.fetch(City.fetchRequest())
            for obj in city {
                
                let weatherObj = Weather()
                weatherObj._latitude = obj.lat
                weatherObj._longitude = obj.lon
                weatherObj.downloadWeatherDetails {_ in 
                    
                    //self.downloadForecastData {
                    //self.updateMainUI()
                    self.collectionView.reloadData()
                    self.WeatherLocationsArray.add(weatherObj)
                }      
                        }


        } catch {
            print("Fetching Failed")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       // collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    @IBAction func addNewCity(_ sender: Any) {
        
        let content = storyboard!.instantiateViewController(withIdentifier: "map") as! MapVC
        //content.type = contentType
        self.navigationController?.pushViewController(content, animated: true)
        
    }

}


extension  HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WeatherLocationsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       // let invite = fetchedResultsController!.fetchedObjects![indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCardCell.identifier, for: indexPath) as! WeatherCardCell
        let weatherobject: Weather = WeatherLocationsArray.object(at: indexPath.row) as! Weather
        print(weatherobject)
        cell.cityName.text = weatherobject.cityName
        cell.temperature.text = "\(weatherobject.currentTemp) °C"
        cell.date.text = weatherobject.date
        cell.weatherDescription.text = "\(weatherobject.weatherType)"
        cell.weatherImage.image = UIImage(named: weatherobject.weatherType)
        cell.minTemp.text = " Max : \(weatherobject.minTemp) °C / Min : \(weatherobject.maxTemp) °C"
        cell.humidity.text = "Humidity \(weatherobject.humidity)%"
        cell.rainChances.text = "Wind Speed : \(weatherobject.windSpeed) km/h"
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCardCell.identifier, for: indexPath) as! WeatherCardCell
        let weatherobject: Weather = WeatherLocationsArray.object(at: indexPath.row) as! Weather
        
        if isEditEnabled == true {
            
            
        
        } else {
            let content = storyboard!.instantiateViewController(withIdentifier: "cityWeatherFull") as! testDataViewController
            content.latitude = weatherobject.latitudeLocation
            content.longitude = weatherobject.longitudeLocation
            
            self.navigationController?.pushViewController(content, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let margin = CGFloat(33)
        let itemSpacing = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 0
        let leftInset = margin
        let rightInset = collectionView.width - margin - cellWidth - itemSpacing
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfCollectionView = collectionView.layer.frame.size.width
        let heightOfCollectionView = collectionView.layer.frame.size.height
        let widthOfCell = widthOfCollectionView * 0.65
        let heightOfCell = heightOfCollectionView * 0.75
        
        cellWidth = widthOfCell
        
        return CGSize(width: widthOfCell, height:heightOfCell)
    }
}


