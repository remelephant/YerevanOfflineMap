//
//  BusStations.swift
//  YerevanOfflineMap
//
//  Created by Vahagn Gevorgyan on 4/17/17.
//  Copyright © 2017 Vahagn Gevorgyan. All rights reserved.
//

import Foundation
import GoogleMaps

typealias direction = ([CLLocation], CLLocation, CLLocation)

struct Station {
    let upDirections =  [upMashtocAve, upArtsakhAve, upKomitasAve]

    func nearestLocation(locations: [CLLocation], closestToLocation location: CLLocation) -> CLLocation? {
        if locations.count == 0 {
            return nil
        }
        
        var closestLocation: CLLocation?
        var smallestDistance: CLLocationDistance?
        
        for i in locations {
            let distance = location.distance(from: i)
            if smallestDistance == nil || distance < smallestDistance! {
                closestLocation = i
                smallestDistance = distance
            }
        }
        return closestLocation
    }
    
    func doubleToCllocation(doubleArray: [[Double]]) -> [CLLocation] {
        var locations: [CLLocation] = []
        for i in doubleArray {
            locations.append(CLLocation(latitude: i[0], longitude: i[1]))
        }
        return locations
    }
    
    func busNames(startLocation: CLLocation, endLocation: CLLocation) -> direction {
        var allLines: [[CLLocation]] = []
        var allStations: [CLLocation] = []
        var walkingDistance: CLLocationDistance? = nil
        var confortLine: [CLLocation] = []
        var finalStart: CLLocation!
        var finalEnd: CLLocation!
        
        for lineWithDoubles in upDirections {
            let transportLine = doubleToCllocation(doubleArray: lineWithDoubles)
            allLines.append(transportLine)
            for location in transportLine {
                allStations.append(location)
            }
        }
        
        for line in allLines {
            let nearestStartLocation = nearestLocation(locations: line, closestToLocation: startLocation)!
            let nearestEndLocation = nearestLocation(locations: line, closestToLocation: endLocation)!
            let walkingStart = startLocation.distance(from: nearestStartLocation)
            let walkingEnd = nearestEndLocation.distance(from: endLocation)
            if walkingDistance == nil || (walkingStart + walkingEnd) < walkingDistance! {
                walkingDistance = walkingStart + walkingEnd
                confortLine = line
                finalStart = nearestStartLocation
                finalEnd = nearestEndLocation
            }
        }
        
        let direction: direction = (confortLine, finalStart, finalEnd)
        return direction
    }
}

let location =  [
    [40.188019, 44.514477],
    [40.184888, 44.512090],
    [40.181506, 44.508171],
    [40.176652, 44.503673],
    [40.184746, 44.512426]
]

let upMashtocAve = [
    [40.183971, 44.448567],
    [40.180569, 44.444981],
    [40.176798, 44.438761],
    [40.173380, 44.440124],
    [40.173773, 44.443933],
    [40.173863, 44.446368],
    [40.173726, 44.457308],
    [40.171665, 44.491753],
    [40.174231, 44.495905],
    [40.178476, 44.505103],
    [40.181333, 44.508434],
    [40.187721, 44.516120],
    [40.189786, 44.521012],
    [40.190966, 44.527680]
]

let upArtsakhAve = [
    [40.165860, 44.440118],
    [40.173156, 44.438520],
    [40.173781, 44.443902],
    [40.173978, 44.446547],
    [40.174534, 44.452216],
    [40.173830, 44.457360],
    [40.167877, 44.456217],
    [40.161670, 44.466790],
    [40.161933, 44.473291],
    [40.171670, 44.491768],
    [40.178473, 44.505116],
    [40.180301, 44.508485],
    [40.178358, 44.511221],
    [40.172185, 44.513528],
    [40.167807, 44.513163],
    [40.164707, 44.512891],
    [40.159803, 44.511671],
    [40.156089, 44.510394],
    [40.143993, 44.510426],
    [40.142078, 44.516343],
    [40.141822, 44.521748],
    [40.140116, 44.522268],
    [40.139062, 44.523250]
]

let upKomitasAve = [
    [40.173068, 44.437909],
    [40.173879, 44.446360],
    [40.176499, 44.458528],
    [40.187072, 44.461878],
    [40.189306, 44.462070],
    [40.190722, 44.465283],
    [40.191298, 44.473159],
    [40.190104, 44.475062],
    [40.189583, 44.479294],
    [40.193119, 44.485286],
    [40.194653, 44.487889],
    [40.197424, 44.492574],
    [40.199469, 44.493827],
    [40.201555, 44.495970],
    [40.202913, 44.499283],
    [40.204337, 44.502821],
    [40.205676, 44.506120],
    [40.206769, 44.510997],
    [40.206548, 44.514892],
    [40.206335, 44.518835],
    [40.206183, 44.522799],
    [40.207821, 44.538206]
]


