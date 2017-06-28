//
//  Probe.swift
//  LocationDumper
//
//  Created by Filippo on 9/27/16.
//  Copyright © 2016 Pellolio. All rights reserved.
//

import Foundation
import MapKit

class Probe {
    var lat: Double;
    var lng: Double;
    var timestamp: Date;
    var lane: Int;
    var nOfLanes: Int;
    var accuracy: Double;
    var heading: Double;
    var speed: Double;
    
    init(location: CLLocation, _lane: Int, _nOfLanes: Int) {
        lat = location.coordinate.latitude
        lng = location.coordinate.longitude
        timestamp = location.timestamp
        lane = _lane
        nOfLanes = _nOfLanes
        accuracy = location.horizontalAccuracy
        speed = location.speed
        heading = location.course
    }
    
    func toJSON() -> String {
        var res = "{"
        res += "lat:\(lat),lng:\(lng)"
        res += ",timestamp:\(timestamp.timeIntervalSince1970 * 1000)"
        res += ",lane:\(lane),nOfLanes:\(nOfLanes)"
        res += ",speed:\(speed),heading:\(heading)"
        res += ",id:1"
        res += "}"
        return res
    }
    
    func toText() -> String {
        var res = "";
        res += "lat: \(Double(round(1000 * lat)/1000)),lng: \(Double(round(1000 * lng)/1000))"
        res += " at \(Calendar.current.component(.hour, from: timestamp)):\(Calendar.current.component(.minute, from: timestamp))"
        return res
    }
}
