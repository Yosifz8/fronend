//
//  MapViewController.swift
//  fronend
//
//  Created by Yosi Faroh Zada on 08/05/2023.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    private let post: Post
    
    init(post: Post) {
        self.post = post
        
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
        title = "Location"
        
        self.view.addSubviews([self.mapView])
        
        mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        addLocationAnnotation()
    }
    
    private func addLocationAnnotation() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = .init(latitude: post.latitude!, longitude: post.longitude!)
        
        self.mapView.addAnnotation(annotation)
    }
}
