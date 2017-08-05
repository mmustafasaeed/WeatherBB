//
//  HomeVC.swift
//  WeatherBB
//
//  Created by Mustafa Saeed on 8/4/17.
//  Copyright © 2017 Mustafa Saeed. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var items = [String]()
    let collectionViewLayout = CoinLayout()
    fileprivate var cellWidth = CGFloat(0)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var city: [City] = []
    var WeatherLocationsArray: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        for obj in city {
//            
//            let weatherObj = Weather()
//            weatherObj._latitude = obj.lat
//            weatherObj._longitude = obj.lon
//            weatherObj.downloadWeatherDetails {
//                //self.downloadForecastData {
//                    //self.updateMainUI()
//                self.collectionView.reloadData()
//                self.WeatherLocationsArray.add(weatherObj)
//                }
//            
//            
//            
//        }
        
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionViewLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = collectionViewLayout
        collectionViewLayout.offsetX = -(33 / 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()
//        self.collectionView.reloadData()
    }
    
    func getData() {
        
        WeatherLocationsArray.removeAllObjects()
        do {
            city = try context.fetch(City.fetchRequest())
            for obj in city {
                
                let weatherObj = Weather()
                weatherObj._latitude = obj.lat
                weatherObj._longitude = obj.lon
                weatherObj.downloadWeatherDetails {
                    
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
       cell.minTemp.text = "\(weatherobject.minTemp) °C / \(weatherobject.maxTemp) °C"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let weatherobject: Weather = WeatherLocationsArray.object(at: indexPath.row) as! Weather
        let content = storyboard!.instantiateViewController(withIdentifier: "cityWeatherFull") as! testDataViewController
        content.latitude = weatherobject.latitudeLocation
        content.longitude = weatherobject.longitudeLocation
        
        self.navigationController?.pushViewController(content, animated: true)
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
        let heightOfCell = heightOfCollectionView * 0.65
        
        cellWidth = widthOfCell
        
        return CGSize(width: widthOfCell, height:heightOfCell)
    }
}


