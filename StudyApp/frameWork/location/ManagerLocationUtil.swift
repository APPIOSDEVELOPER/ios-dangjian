//
//  ManagerLocationUtil.swift
//  StudyApp

import UIKit
import CoreLocation

class ManagerLocationUtil: NSObject,CLLocationManagerDelegate {

    var locationManager: CLLocationManager!
    var finishedDidLocation: ((CLLocationCoordinate2D) -> (Void))?
    
    
    
    func startPositionLocation() -> Void {
        
        
//        print("authorizationStatus = \(CLLocationManager.authorizationStatus())");
//        print("isabel = \(CLLocationManager.locationServicesEnabled())");
//
//        if CLLocationManager.authorizationStatus() == .authorizedAlways {
//            return;
//        }
        
        locationManager = CLLocationManager();
        locationManager.requestAlwaysAuthorization();

        locationManager.delegate = self;
//        locationManager.requestLocation();

        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation();
        
        print("eroor = \(locations.first)")

        
        guard let coordinate = locations.first?.coordinate else {
            return;
        }
        self.finishedDidLocation?(coordinate);
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("eroor = \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
}
