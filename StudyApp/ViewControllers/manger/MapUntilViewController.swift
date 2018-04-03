//
//  MapUntilViewController.swift
//  StudyApp
//


import UIKit
import MapKit

class MapUntilViewController: SuperBaseViewController ,MKMapViewDelegate{

    
    var mapView: MKMapView!
    let locationManger = ManagerLocationUtil();
    
    var searchView: UISearchBar!
    var searchBackView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManger.startPositionLocation();
        locationManger.finishedDidLocation = {
            [weak self](coordate) -> Void in
            self?.showRegionCoordinate(coordinate: coordate);
        }
        
        mapView = MKMapView(frame: navigateRect);
        addView(tempView: mapView);
        mapView.showsUserLocation = true;
        mapView.delegate = self;
        
        
        createSearchView();

    }
    
    func createSearchView() -> Void {
        searchView = UISearchBar(frame: .init(x: 0, y: 8, width: width() - 100, height: 28));
        searchView.barTintColor = UIColor.white;
        searchView.barStyle = .default;
        searchView.searchBarStyle = .prominent;
        searchView.setBackgroundImage(UIImage(), for: .any, barMetrics: .default);
        
        searchBackView = UIView(frame: .init(x: 50, y: 0, width: width() - 100, height: 44));
        searchBackView.addSubview(searchView);

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.navigationBar.addSubview(searchBackView);

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        searchBackView.removeFromSuperview();

    }
   
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var aView = mapView.dequeueReusableAnnotationView(withIdentifier: "cell");
        if aView == nil {
            aView = MKAnnotationView(annotation: annotation, reuseIdentifier: "cell");//72 × 86
            aView?.frame = CGRect.init(x: 0, y: 0, width: 36, height: 43);
            aView?.canShowCallout = true;
        }
        aView?.image = UIImage(named:"flag");
        return aView;
    }

    func showRegionCoordinate(coordinate: CLLocationCoordinate2D) -> Void {
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.11, longitudeDelta: 0.11));
        mapView.setRegion(region, animated: true);
    }
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let coordinate = mapView.userLocation.location?.coordinate else{
            return;
        }
        showRegionCoordinate(coordinate: coordinate);
    }

}



class LocationItemAnnotation:  MKAnnotationView{
    
}

