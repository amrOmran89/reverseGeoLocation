//
//  ViewController.swift
//  reverseGeoLocation
//
//  Created by Amr Omran on 08/20/2017.
//  Copyright © 2017 Amr Omran. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var physicalAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!


    var manager = CLLocationManager()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.startUpdatingLocation()
        manager.requestWhenInUseAuthorization()

        mapView.delegate = self as? MKMapViewDelegate
        mapView.showsUserLocation = true
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        // to get the location on the mapView
        let userLocation: CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locationCoordinate, span: span)
        mapView.setRegion(region, animated: true)

        // to get the geoLocation
        let lastLocation: CLLocation = locations[locations.count-1]
        latitudeLabel.text = String(format: "%.6f", lastLocation.coordinate.latitude)
        longitudeLabel.text = String(format: "%.6f", lastLocation.coordinate.longitude)

        // to get the physical address
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemark, error) in
            if (error != nil){
                print("ERROR")
            }
            else{
                if let place = placemark?[0]{
                    if place.subThoroughfare != nil {
                        self.physicalAddressLabel.text = "\(place.thoroughfare!) \(place.subThoroughfare!)\n\(place.locality!) \(place.postalCode!)\n\(place.country!)"
                    }
                    else {
                        print("address error")
                    }
                }
                else{
                    print("place error")
                }
            }
        }
    }

}
