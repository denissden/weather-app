//
//  LocationProvider.swift
//  Weather
//
//  Created by deniss on 4/15/23.
//

import Foundation
import CoreLocation


protocol LocationProvider {
    func setup(onUpdate: @escaping (CLLocation) -> Void)
    func getLocation() -> CLLocation?
}

class DeviceLocationProvider : LocationProvider {
    private var onUpdateFunc: ((CLLocation) -> Void)?
    private var location: CLLocation?
    private var manager: CLLocationManager?
    private var managerDelegate: DeviceLocationManagerDelegate?

    
    func setup(onUpdate: @escaping (CLLocation) -> Void) {
        onUpdateFunc = onUpdate
        
        manager = CLLocationManager()
        managerDelegate = DeviceLocationManagerDelegate(provider: self)
        manager!.delegate = managerDelegate
        manager!.requestWhenInUseAuthorization()
        manager!.requestLocation()
    }
    
    func getLocation() -> CLLocation? {
        return location
    }
    
    fileprivate func setLocation(location: CLLocation) {
        self.location = location
        if let onUpdate = onUpdateFunc {
            onUpdate(location)
        }
    }
}

class DeviceLocationManagerDelegate : NSObject, CLLocationManagerDelegate {
    private let provider: DeviceLocationProvider
    
    init(provider: DeviceLocationProvider) {
        self.provider = provider
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied {
            print("Location access not authorized")
        } else {
            print("Location authorized")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            provider.setLocation(location: location)
        }
    }
}
