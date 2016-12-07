//
//  LocationService.swift
//  SpeakToWeather
//
//  Created by elkraneo on 28/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//


import CoreLocation


public enum LocationAuthorizationStatus: Int {
    case notDetermined, restricted, denied, authorizedWhenInUse, authorizedAlways
}


public protocol LocationServiceDelegate {
    func authorizationStatusDidChange(status: LocationAuthorizationStatus) -> Void
}


public struct Location {
    let latitude: Double
    let longitude: Double
}


public final class LocationService: NSObject, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager = CLLocationManager()
    private var locations = [CLLocation]()
    public var lastLocation: Location? {
        let location = locations.last?.coordinate
        guard let latitude = location?.latitude,
            let longitude = location?.longitude else { return nil }
        
        return Location(latitude: latitude, longitude: longitude)
    }
    private var delegate: LocationServiceDelegate?
    
    
    public override init() {
        super.init()
        print("🌍 Location service: started")
    }
    
    public func requestAuthorization(delegate: LocationServiceDelegate) {
        self.delegate = delegate
        
        locationManager.delegate = self
        
        requestWhenInUseAuthorization()
    }
    
    func requestWhenInUseAuthorization() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    public func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
    }
    
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: CLLocationManagerDelegate
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locations = locations
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        requestWhenInUseAuthorization()
        OperationQueue.main.addOperation {
            guard let authStatus = LocationAuthorizationStatus(rawValue: Int(status.rawValue)) else { return }
            self.delegate?.authorizationStatusDidChange(status: authStatus)
        }
    }
}
