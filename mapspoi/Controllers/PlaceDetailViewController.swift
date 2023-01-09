//
//  PlaceDetailViewController.swift
//  HellowWorld
//
//  Created by Mac on 2023/01/09.
//

import Foundation
import UIKit

class PlaceDetailViewController: UIViewController{
    let place: PlaceAnnotation
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    lazy var directionButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration:  config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Directions", for: .normal)
        return button
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    lazy var callButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Call", for: .normal)
        return button
    }()
    
    
    init(place: PlaceAnnotation){
        self.place = place
        super.init(nibName: nil, bundle: nil)
        setUpUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    @objc func directionsButtonTapped(_sender: UIButton){
        let cordinate  = place.location.coordinate
        guard let url = URL(string: "https://maps.apple.com/?daddr=\(cordinate.latitude),\(cordinate.longitude)") else {return}
        UIApplication.shared.open(url)
    }
    @objc func callButtonTapped(_sender: UIButton){
        guard let url = URL(string: "tel://\(place.phone.formatPhoneCall)") else {return}
        UIApplication.shared.open(url)
        
    }
    private func setUpUI(){
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        nameLabel.text = place.name
        addressLabel.text = place.address
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addressLabel)
        
        let contactStackOverView = UIStackView()
        contactStackOverView.translatesAutoresizingMaskIntoConstraints = false
        contactStackOverView.axis = .horizontal
        contactStackOverView.spacing = UIStackView.spacingUseSystem
        
        directionButton.addTarget(self, action: #selector(directionsButtonTapped), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        contactStackOverView.addArrangedSubview(directionButton)
        contactStackOverView.addArrangedSubview(callButton)
        
        stackView.addArrangedSubview(contactStackOverView)
        
        
        nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        view.addSubview(stackView)
    }
    
    
}
