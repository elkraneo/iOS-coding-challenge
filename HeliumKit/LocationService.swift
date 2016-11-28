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
    
    private let locationManager = CLLocationManager()
    private var delegate: LocationServiceDelegate?
    
    public override init() {
        super.init()
        print("🌍 Location service: started")
    }
    
    public func requestAuthorization() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    public func startUpdatingLocation(delegate: LocationServiceDelegate) {
        if CLLocationManager.locationServicesEnabled() {
            self.delegate = delegate
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
    }
    
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: CLLocationManagerDelegate
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue = manager.location?.coordinate
        guard let latitude = locValue?.latitude,
            let longitude = locValue?.longitude else { return }
        
        delegate?.didUpdate(location: Location(latitude: latitude, longitude: longitude))
        print("🌍 Location service: \(locValue?.latitude) \(locValue?.longitude)")
    }
}
