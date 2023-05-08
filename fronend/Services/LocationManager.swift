//
//  LocationManager.swift
//  fronend
//
//  Created by Yosi Faroh Zada on 08/05/2023.
//

import Foundation
import CoreLocation

enum LocationError: Error {
    case name
}

final class LocationManager: NSObject {
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
        
    var currentLocation: CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    func start() {
        locationManager.requestWhenInUseAuthorization()

        // Start updating the user's location
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        // Use the location object to get the latitude and longitude
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        // Do something with the latitude and longitude
        
        currentLocation = .init(latitude: latitude, longitude: longitude)
        
        locationManager.stopUpdatingLocation()
    }
}
