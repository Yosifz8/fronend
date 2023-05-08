//
//  SetMapViewController.swift
//  fronend
//
//  Created by Yosi Faroh Zada on 08/05/2023.
//

import UIKit
import MapKit

protocol SetMapProtocol {
    func didSetLocation(location: CLLocationCoordinate2D?)
}

final class SetMapViewController: UIViewController {
    
    private let delegate: SetMapProtocol
    private var location: CLLocationCoordinate2D?
        
    init(delegate: SetMapProtocol, location: CLLocationCoordinate2D? = nil) {
        self.delegate = delegate
        self.location = location
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsCompass = true
        mapView.showsScale = false
        mapView.showsUserLocation = true
        mapView.isRotateEnabled = true
        mapView.mapType = .standard
        
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        let useCurrentLocationButton: UIButton = {
            let button = UIButton()
            
            button.setTitle("Set current location", for: .normal)
            button.titleLabel?.font =  .systemFont(ofSize: 20)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 37/255, green: 211/255, blue: 102/255, alpha: 1.0)
            
            button.layer.cornerRadius = 5
            
            button.addTarget(self, action: #selector(didPressUseCurrentLocationButton), for: .touchUpInside)
            
            return button
        }()
        
        self.view.addSubviews([useCurrentLocationButton, self.mapView])
        
        useCurrentLocationButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20), size: .init(width: view.width - 40, height: 50))
        mapView.anchor(top: useCurrentLocationButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.2
        mapView.addGestureRecognizer(lpgr)
        
        self.navigationItem.rightBarButtonItem = .init(title: "Save", style: .plain, target: self, action: #selector(didPressSaveButton))
        
        if let location = location {
            updateMapAnnotaion(location)
        }
    }
    
    private func updateMapAnnotaion(_ coordinate: CLLocationCoordinate2D) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        self.mapView.addAnnotation(annotation)
    }
}

extension SetMapViewController {
    @objc private func didPressUseCurrentLocationButton() {
        self.location = LocationManager.shared.currentLocation
    }
    
    @objc private func handleLongPress(gestureRecognizer:UIGestureRecognizer) {
        if gestureRecognizer.state != .began {
            return
        }
        
        let touchPoint = gestureRecognizer.location(in: self.mapView)
        let touchMapCoordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        
        updateMapAnnotaion(touchMapCoordinate)
        
        self.location = touchMapCoordinate
    }
    
    @objc private func didPressSaveButton() {
        delegate.didSetLocation(location: location)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
