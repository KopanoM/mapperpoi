//
//  ViewController.swift
//  HellowWorld
//
//  Created by Mac on 2023/01/07.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController {
    var locationManager: CLLocationManager?
    private var places: [PlaceAnnotation] = []
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.layer.cornerRadius = 10
        searchTextField.delegate = self
        searchTextField.clipsToBounds = true
        searchTextField.textColor = .black
        
        searchTextField.backgroundColor = UIColor.white
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search",attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 0))
        searchTextField.leftViewMode = .always
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager?.startUpdatingLocation()
            print("enabled")
        }else{
            print("disabled")
        }
        checkLocationAuthorization()
        setUpUI()
        
        
    }
    
    private func setUpUI(){
        view.addSubview(searchTextField)
        view.addSubview(mapView)
        view.bringSubviewToFront(searchTextField)
        //add constraints
        searchTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTextField.widthAnchor.constraint(equalToConstant: view.bounds.size.width/1.2).isActive = true
        searchTextField.topAnchor.constraint(equalTo: view.topAnchor,constant: 60).isActive = true
        searchTextField.returnKeyType = .go
        
        
        // add constraints
        
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    private func presentPlacesSheet(places: [PlaceAnnotation]){
        
        guard let locationManager = locationManager, let userLocation = locationManager.location
        else { return }
 
        let placesTVC = PlacesTableViewController(userLocation: userLocation, places: places)
        placesTVC.modalPresentationStyle = .pageSheet
        if let sheet = placesTVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            present(placesTVC, animated: true)
        }
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager,
              let location = locationManager.location else {return}
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters:750)
        mapView.setRegion(region,animated: true)

        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters:750)
            mapView.setRegion(region,animated: true)
        case .denied:
            print("Location services has been denied.")
        case .notDetermined, .restricted:
            print("Location can not be determined or resticted")
        @unknown default:
            print("Unknown")
        }
    }
    private func findNearbyPlaces( query: String){
        // clear all annotations
        mapView.removeAnnotations(mapView.annotations)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start {[weak self] response , error in
            guard let response = response, error == nil else {return }
            self?.places = response.mapItems.map(PlaceAnnotation.init)
            self?.places.forEach { place in
                self?.mapView.addAnnotation(place)
            }
            if let places =  self?.places{
                print("IT GETS HERE")
                self?.presentPlacesSheet(places: places)
                //print(response.mapItems)
            }
            
        }
    }
}
extension ViewController: MKMapViewDelegate {
    
    private func clearAllSelections(){
        self.places = self.places.map {place in
            place.isSelected = false
            return place
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // clear all selections
        clearAllSelections()
        guard let selectedAnnotation = view.annotation as? PlaceAnnotation else {return}
        let placeAnnotation = self.places.first(where: {$0.id == selectedAnnotation.id})
        placeAnnotation?.isSelected = true
        presentPlacesSheet(places: self.places)
        print("PLACE: \(placeAnnotation?.mapItem.isCurrentLocation)")
    }
}
extension ViewController: UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        if !text.isEmpty{
            textField.resignFirstResponder()
            // find nearby
            findNearbyPlaces(query: text)
        }
        return true
    }
    
    
}
extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locations = locations.last else {return }
        let viewRegion = MKCoordinateRegion(center: locations.coordinate, latitudinalMeters: 2000,longitudinalMeters: 2000)
        self.mapView.setRegion(viewRegion, animated: true)
        //print(locations.coordinate)
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

