//
//  ViewController.swift
//  YerevanOfflineMap
//
//  Created by Vahagn Gevorgyan on 4/17/17.
//  Copyright © 2017 Vahagn Gevorgyan. All rights reserved.
//

//import UIKit
//
//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//}

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, GMSMapViewDelegate ,  CLLocationManagerDelegate {
    
    var mapView: GMSMapView!
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 40.176798, longitude: 44.438761, zoom: 15)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        mapView.accessibilityElementsHidden = false
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 40.176798, longitude: 44.438761)
        marker.title = "StartPoint"
        marker.snippet = "ՀԱԹ"
        marker.map = mapView
        addMarker(location: location)
        let stationLocation = doubleToCllocation(doubleArray: transportNumber77Up)
        drawRoute(station: stationLocation, startPosition: stationLocation[1])
//        drawPath(startLocation: stationLocation[0], endLocation: stationLocation[1])
    }
    
    func addMarker(location: [[Double]]) {
        let path = GMSMutablePath()
        for i in 0..<location.count {
            let positionLatitude = location[i][0]
            let positionLongitude = location[i][1]
            
            let position = CLLocationCoordinate2D (
                latitude: positionLatitude,
                longitude: positionLongitude
            )
            
            let marker = GMSMarker(position: position)
            marker.title = "Hello World"
            marker.map = self.mapView
        }
        let rectangle = GMSPolyline(path: path)
        rectangle.map = mapView
    }
    
    func drawRoute(station: [CLLocation], startPosition: CLLocation) {
        
        if let startIndex = station.index(of: startPosition) {
            var tempLocation = startPosition
            for i in station {
                if index(ofAccessibilityElement: i) > startIndex {
                    drawPath(startLocation: tempLocation, endLocation: i)
                    tempLocation = i
                }
            }
        } else {
            print("Error, maybe problem is startPositions")
        }
    }
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            let json = JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.red
                polyline.map = self.mapView
            }
            
        }
    }
    
    func doubleToCllocation(doubleArray: [[Double]]) -> [CLLocation] {
        var locations: [CLLocation] = []
        for i in doubleArray {
            locations.append(CLLocation(latitude: i[0], longitude: i[1]))
        }
        return locations
    }
}









