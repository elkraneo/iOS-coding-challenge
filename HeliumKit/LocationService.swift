//
//  LocationService.swift
//  SpeakToWeather
//
//  Created by elkraneo on 28/11/2016.
//  Copyright © 2016 metodowhite. All rights reserved.
//


import CoreLocation


public protocol LocationServiceDelegate {
    func didUpdate(location: Location) -> Void
}


public struct Location {
    let latitude: Double
    let longitude: Double
}


public final class LocationService: NSObject, CLLocationManagerDelegate {
    
    private var delegate: LocationServiceDelegate?
    private var locationManager: CLLocationManager = CLLocationManager()
    private var authorized: Bool = false {
        didSet {
            print("🌍 Location service\(authorized ? "" : " not") authorized")
        }
    }
    private var locations = [CLLocation]()
    public var lastLocation: Location? {
        let location = locations.last?.coordinate
        guard let latitude = location?.latitude,
            let longitude = location?.longitude else { return nil }
        
        return Location(latitude: latitude, longitude: longitude)
    }
    
    
    public override init() {
        super.init()
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        print("🌍 Location service: started")
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
        OperationQueue.main.addOperation {
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                self.authorized = true
            default:
                self.authorized = false
            }
        }
    }
}
