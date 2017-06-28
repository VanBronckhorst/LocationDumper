//
//  ViewController.swift
//  LocationDumper
//
//  Created by Filippo on 9/27/16.
//  Copyright © 2016 Pellolio. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var lastOnlineLabel: UILabel!
    @IBOutlet weak var lastFileLabel: UILabel!
    @IBOutlet weak var nOfPositionsLabel: UILabel!
    @IBOutlet weak var lastPositionLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var nOfLanesLabel: UILabel!
    @IBOutlet weak var laneSelector: UISegmentedControl!
    @IBOutlet weak var laneStepper: UIStepper!
    
    var positions = [Probe]()
    
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let nOfLanes = Int(sender.value);
        var selectedLane = laneSelector.selectedSegmentIndex;
        nOfLanesLabel.text = String(nOfLanes);
        
        if (nOfLanes == 1) {
            laneSelector.setEnabled(false, forSegmentAt: 0)
            selectedLane = 1
        } else if (laneSelector.numberOfSegments == nOfLanes) {
            laneSelector.setEnabled(true, forSegmentAt: 0)
        } else if (laneSelector.numberOfSegments > nOfLanes) {
            if (laneSelector.selectedSegmentIndex == laneSelector.numberOfSegments - 1) {
                selectedLane = nOfLanes - 1;
            }
            laneSelector.removeSegment(at: nOfLanes - 1, animated: false)
        } else {
            laneSelector.insertSegment(withTitle: "1", at: nOfLanes - 1, animated: false)
        }
        
        for i in 0...nOfLanes - 1 {
            laneSelector.setTitle(String(nOfLanes - i), forSegmentAt: i);
        }
        
        laneSelector.selectedSegmentIndex = selectedLane;
        if (selectedLane == nOfLanes - 1 && laneSelector.numberOfSegments > 1) {
            laneSelector.selectedSegmentIndex = selectedLane - 1;
            laneSelector.setNeedsLayout()
            laneSelector.setNeedsFocusUpdate()
            laneSelector.selectedSegmentIndex = selectedLane;
        }
        
        
        
    }
    let locationManager = CLLocationManager();
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            map.showsUserLocation = true
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    
    override func viewDidLoad() {
        
        UIApplication.shared.isIdleTimerDisabled = true
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.startUpdatingLocation();
        
        checkLocationAuthorizationStatus()
        debugPrint("Starting Location Dump")
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    //MARK: Error and completion handlers
    func onOnlineSuccess() {
        let nowTime = "\(Calendar.current.component(.hour, from: Date())):\(Calendar.current.component(.minute, from: Date()))"
        let text = "Success at: \(nowTime)"
        
        let linkTextWithColor = "Success"
        
        let range = (text as NSString).range(of: linkTextWithColor)
        
        let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.green , range: range)
        
        lastOnlineLabel.attributedText = attributedString;
    }
    
    func onFileSuccess() {
        let nowTime = "\(Calendar.current.component(.hour, from: Date())):\(Calendar.current.component(.minute, from: Date()))"
        let text = "Success at: \(nowTime)"
        
        let linkTextWithColor = "Success"
        
        let range = (text as NSString).range(of: linkTextWithColor)
        
        let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.green , range: range)
        
        lastFileLabel.attributedText = attributedString;
    }
    
    func onOnlineError(_: Error?) {
        let nowTime = "\(Calendar.current.component(.hour, from: Date())):\(Calendar.current.component(.minute, from: Date()))"
        let text = "Error at: \(nowTime)"
        
        let linkTextWithColor = "Error"
        
        let range = (text as NSString).range(of: linkTextWithColor)
        
        let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red , range: range)
        
        lastOnlineLabel.attributedText = attributedString;
    }
    
    func onFileError(_: Error?) {
        let nowTime = "\(Calendar.current.component(.hour, from: Date())):\(Calendar.current.component(.minute, from: Date()))"
        let text = "Error at: \(nowTime)"
        
        let linkTextWithColor = "Error"
        
        let range = (text as NSString).range(of: linkTextWithColor)
        
        let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red , range: range)
        
        lastFileLabel.attributedText = attributedString;
    }
    

    //MARK: Location Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let nOfLanes = Int(laneStepper.value);
        
        var lane = nOfLanes - 1 - laneSelector.selectedSegmentIndex;
        if (nOfLanes == 1) {
            lane = 0;
        }
        let lastProbe = Probe(location: locations.last!, _lane: lane, _nOfLanes: nOfLanes)
        
        positions.append(lastProbe);
        nOfPositionsLabel.text = String(positions.count);
        lastPositionLabel.text = lastProbe.toText();
        if (positions.count % 60 == 0) {
            postProbes(probes: positions, onSuccess: onOnlineSuccess, onError: onOnlineError)
            saveToFile(probes: positions, onSuccess: onFileSuccess, onError: onFileError)
            positions = [];
        }
        
        map.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
    }
    
}

