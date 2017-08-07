//
//  MapVC.swift
//  WeatherBB
//
//  Created by Mustafa Saeed on 8/4/17.
//  Copyright © 2017 Mustafa Saeed. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark, _ lat:Double, _ lon:Double)
}

class MapVC: UIViewController {
    
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    var selectedLat = 0.0
    var selectedLon = 0.0
    var cityNameForWeather = ""
    
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var dragPin: MKPointAnnotation!
    var startLocation = CGPoint.zero

//    let defaults:UserDefaults = UserDefaults.standard
    
    @IBOutlet weak var mapview: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapview
        locationSearchTable.handleMapSearchDelegate = self
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            selectedLat = currentLocation.coordinate.latitude
            selectedLon = currentLocation.coordinate.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = currentLocation.coordinate
            //annotation.title = currentLocation.
            
            mapview.addAnnotation(annotation)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(currentLocation.coordinate, span)
            mapview.setRegion(region, animated: true)
            
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }

    @IBAction func saveCity(_ sender: Any) {
        
        var someDict = [String : Double]()
        someDict["lat"] = selectedLat
        someDict["lon"] = selectedLon
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let city = City(context: context) // Link Task & Context
        city.lat = selectedLat
        city.lon = selectedLon
        
        // Save the data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        self.navigationController?.popViewController(animated: true)
            }
}

extension MapVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapview.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}

extension MapVC: HandleMapSearch {
    
    func dropPinZoomIn(_ placemark: MKPlacemark, _ lat:Double, _ lon:Double){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapview.removeAnnotations(mapview.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
            cityNameForWeather = city
            
        }
        selectedLat = lat
        selectedLon = lon
        
        
        mapview.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapview.setRegion(region, animated: true)
    }
    
}


extension MapVC : MKMapViewDelegate {
    
    func handleDrag(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: mapview)
        
        if gesture.state == .began {
            startLocation = location
        } else if gesture.state == .changed {
            gesture.view?.transform = CGAffineTransform(translationX: location.x - startLocation.x, y: location.y - startLocation.y)
        } else if gesture.state == .ended || gesture.state == .cancelled {
            let annotationView = gesture.view as! MKAnnotationView
            let annotation = annotationView.annotation
            
            
            
            
            let translate = CGPoint(x: location.x - startLocation.x, y: location.y - startLocation.y)
            let originalLocation = mapview.convert((annotation?.coordinate)!, toPointTo: mapview)
            let updatedLocation = CGPoint(x: originalLocation.x + translate.x, y: originalLocation.y + translate.y)
            
            let coordinateChanged :CLLocationCoordinate2D = mapview.convert(updatedLocation, toCoordinateFrom: mapview)
            selectedLat = coordinateChanged.latitude
            selectedLon = coordinateChanged.longitude
            
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard !(annotation is MKUserLocation) else { return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        let drag = UILongPressGestureRecognizer(target: self, action: #selector(MapVC.handleDrag(gesture:)))
        drag.minimumPressDuration = 0 // set this to whatever you want
        drag.allowableMovement = .greatestFiniteMagnitude
        pinView?.addGestureRecognizer(drag)
        
        pinView?.pinTintColor = UIColor.orange
        pinView?.isDraggable = true
        pinView?.canShowCallout = true
        pinView?.animatesDrop = true

        
        return pinView
    }
    
}
