//
//  SBViewController.swift
//  YerevanOfflineMap
//
//  Created by Vahagn Gevorgyan on 4/19/17.
//  Copyright © 2017 Vahagn Gevorgyan. All rights reserved.
//

import Foundation
import GoogleMaps
import GoogleMapsCore
import GooglePlaces
import Alamofire
import SwiftyJSON

class SBViewController: UIViewController, CLLocationManagerDelegate {
    
    var direction: CLLocation = CLLocation(latitude: -33.86, longitude: 151.20)
    let station = Station()
    
    @IBAction func start(_ sender: Any) {
    }
    @IBAction func end(_ sender: Any) {
    }
    @IBOutlet weak var mapView: GMSMapView!
    var center: CLLocationCoordinate2D!
    var start: CLLocation!
    var end: CLLocation!
    
    override func viewWillLayoutSubviews() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6)
        mapView.camera = camera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView(mapView: mapView, regionDidChangeAnimated: true)
    }
    
    func mapView(mapView: GMSMapView, regionDidChangeAnimated animated: Bool) {
        center = mapView.camera.target
    }
    
    @IBAction func dropPin(_ sender: Any) {
        if start != nil && end != nil {
            let busName = station.busNames(startLocation: start, endLocation: end)
            drawRoute(direction: busName)
        }
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
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation) {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        
        Alamofire.request(url).responseJSON { response in
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





