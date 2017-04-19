//
//  ViewController.swift
//  YerevanOfflineMap
//
//  Created by Vahagn Gevorgyan on 4/17/17.
//  Copyright © 2017 Vahagn Gevorgyan. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, GMSMapViewDelegate,  CLLocationManagerDelegate {
    

    @IBOutlet weak var myMapView: UIView!
    var station = Station()
    var mapView: GMSMapView!

    let locationHome: CLLocation = CLLocation(latitude: 40.173393, longitude: 44.456158)
    let locationWork: CLLocation = CLLocation(latitude: 40.205143, longitude: 44.506187)
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: locationHome.coordinate.latitude, longitude: locationHome.coordinate.longitude, zoom: 15)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        mapView.accessibilityElementsHidden = false
    }
    
    func buttonAction(sender: UIButton) {
        print("Hello")
    }
    
    override func viewDidLoad() {
        let direction = station.busNames(startLocation: locationHome, endLocation: locationWork)
        drawRoute(direction: direction)
        
        let startPointMarker = GMSMarker()
        startPointMarker.position = direction.1.coordinate
        startPointMarker.title = "Նստել"
        startPointMarker.map = mapView
        
        let endPointMarker = GMSMarker()
        endPointMarker.position = direction.2.coordinate
        endPointMarker.title = "Իջնել"
        endPointMarker.map = mapView
        
        let markerHome = GMSMarker()
        markerHome.icon = GMSMarker.markerImage(with: .green)
        markerHome.position = locationHome.coordinate
        markerHome.title = "Տուն"
        markerHome.snippet = "Սկիզբը այստեղ է"
        markerHome.map = mapView
        
        let markerWork = GMSMarker()
        markerWork.icon = GMSMarker.markerImage(with: .blue)
        markerWork.position = locationWork.coordinate
        markerWork.title = "Աշխատանք"
        markerWork.snippet = "Ավարտը այստեղ է"
        markerWork.map = mapView
        
//        let button = UIButton(frame: CGRect(x: 10, y: (self.view.bounds.height / 2), width: 80, height: 20))
//        button.backgroundColor = UIColor.gray
//        button.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
//        self.view.addSubview(button)
//        
//        print("adsasd: ", self.view.frame.width)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        <#code#>
//    }
    
    func pressButton(button: UIButton) {
        print("pressed!")
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
    
    func drawRoute(direction: direction) {
        
        let station: [CLLocation] = direction.0
        let startPosition: CLLocation = direction.1
        let endPosition: CLLocation = direction.2
        
        if let startIndex = station.index(of: startPosition) {
            var tempLocation = startPosition
            let endIndex = station.index(of: endPosition)!
            for i in station {
                if station.index(of: i)! > startIndex && station.index(of: i)! <= endIndex {
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
            
//            print(response.request as Any)  // original URL request
//            print(response.response as Any) // HTTP URL response
//            print(response.data as Any)     // server data
//            print(response.result as Any)   // result of response serialization
            
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
}









