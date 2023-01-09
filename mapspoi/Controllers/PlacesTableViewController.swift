//
//  PlacesTableViewController.swift
//  HellowWorld
//
//  Created by Mac on 2023/01/08.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class PlacesTableViewController: UIViewController{
    var userLocation: CLLocation
    var places: [PlaceAnnotation]
    
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var indexForSelectedRow: Int? {
        self.places.firstIndex(where: {$0.isSelected == true})
    }
    
    init(userLocation: CLLocation,places: [PlaceAnnotation]){
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)
        self.places.swapAt(indexForSelectedRow ?? 0, 0)
        // register cell
    
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        view.backgroundColor = .white
        view.addSubview(table)
       
    }
    private func calculateDistance(from: CLLocation, to: CLLocation) ->CLLocationDistance{
        from.distance(from: to)
        
        
    }
    private func formatDistanceForDisplay(_ distance: CLLocationDistance)->String{
        let meters = Measurement(value: distance,unit: UnitLength.meters)
        return meters.converted(to: .kilometers).formatted()
    }
}



extension PlacesTableViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let place = places[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = place.name
        content.secondaryText = formatDistanceForDisplay(calculateDistance(from: userLocation, to: place.location))
        cell.contentConfiguration = content
        cell.backgroundColor = place.isSelected ? UIColor.lightGray: UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        let placeDetailViewController = PlaceDetailViewController(place: place)
        present(placeDetailViewController,animated: true)
    }
    
    
}
