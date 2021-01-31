//
//  SecondMapViewController.swift
//  Map
//
//  Created by Alexander Romanenko on 30.07.2020.
//  Copyright © 2020 Alexander Romanenko. All rights reserved.
//

import UIKit
import MapKit

class SecondMapViewController: UIViewController {
    
    @IBOutlet weak var MapView: MKMapView!
    let locationManager = CLLocationManager()
    var destinations: [MKPointAnnotation] = []
    var currentRoute: MKRoute?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
        // MARK: - Tracking Button
        let trackingButton = MKUserTrackingButton(mapView: MapView)
        trackingButton.tintColor = UIColor.gray
        trackingButton.alpha = 0.5
        MapView.addSubview(trackingButton)
        //MARK: - functions
        checkLocationEnabled()
        //addAnnotation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        MapView.mapType = .standard
        MapView.userTrackingMode = .follow
        MapView.isZoomEnabled = false
        
        let coordinates = MapView.userLocation.coordinate
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 2000, longitudinalMeters: 2000)
        MapView.regionThatFits(region)
    }
    // MARK: - AddNewSpot
    @IBAction func addSpot(_ sender: Any) {
        
        let alert = UIAlertController(title: "AddNewSpot", message: nil, preferredStyle: .alert)
        
        alert.addTextField()
        let texField = alert.textFields?.first
        let add = UIAlertAction(title: "add", style: .default) { (add) in
            //if let newItem = texField?.text{
                let coordinates = self.MapView.userLocation.coordinate
                let newUser = User(title: (texField?.text)!, coordinate: coordinates)
                spots.append(newUser)
                self.MapView.userLocation.location
                self.MapView.addAnnotation(newUser)
    }
        alert.addAction(add)
        present(alert, animated: true)
    }
    /*//    MARK: - Add Anotation - need a function that can add new MKpointAnnotation
    func addAnnotation()  {
        //let model = modelUser()
        for user in spots {
            MapView.addAnnotation(user)
        }
        func addOldAnotation() {
            let annotation1 = MKPointAnnotation()
            annotation1.coordinate = CLLocationCoordinate2D()
        }
    }
 */
    // MARK: - Check Loaction
    func checkLocationEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupManager()
            checkAutorization()
        } else {
            showAlertlocation(title: "Геолокация отключена", message: "Включить", url: URL(string:"App-Prefs:root=LOCATION_SERVICES" ) )
        }
    }
    // MARK: - Setup Manager
    func setupManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    //    MARK: - Check Autorization
    func checkAutorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            MapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        case .denied:
            showAlertlocation(title: "Местоположение запрещено", message: "Разрешить", url: URL(string: UIApplication.openSettingsURLString))
            break
        case .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    //    MARK: - Show Alert Location
    func showAlertlocation(title:String,message:String?,url:URL?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "Настройки", style: .default) { (alert) in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(settingAction)
        alert.addAction(cancelAction)
        present(alert,animated: true,completion: nil)
    }
}
//MARK: - LocationManagerDelegate
extension SecondMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAutorization()
    }
}
extension SecondMapViewController: MKMapViewDelegate {
    // MARK: Custom VIEW For Routes
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        var polyLineRender = MKPolylineRenderer(overlay: overlay)
        polyLineRender.strokeColor = UIColor.blue
        polyLineRender.lineWidth = 2
        return polyLineRender
    }
    // MARK: - Custom view for annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Annotation")
        if annotationView == nil {
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
        }
        if let annotation = annotation as? User {
            annotationView?.image = UIImage(named: "skater")
            annotationView?.centerOffset = CGPoint(x: 40, y: 0)
            annotationView?.leftCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
        if annotation === mapView.userLocation {
            annotationView?.image = UIImage(named: "gorillaMap")
        }
        annotationView?.canShowCallout = true
        annotationView?.isDraggable = true
        return annotationView
        }
    
    // MARK: -  When the user selected the anotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        mapView.removeOverlays(mapView.overlays)
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        view.centerOffset = CGPoint(x: 0, y: 0)
        print(view.annotation?.coordinate)
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        func createRoute(){
            let alertController = UIAlertController(title: "Chose", message: nil, preferredStyle: .alert)
            alertController.view.tintColor = UIColor.white
            alertController.setBackgroundColor(color: UIColor.black)
            let attributeString = NSMutableAttributedString(string: alertController.title!)
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : (UIColor.red).self], range: NSMakeRange(0,alertController.title!.count))
            
            // MARK: - CreateRouteToSpot
            let action = UIAlertAction(title: "Маршрут", style: .default) { (UIAlertAction) in
                guard let coordinate = self.locationManager.location?.coordinate else {return}
                let user = view.annotation as! User
                let starPoint = MKPlacemark(coordinate: coordinate)
                let endPont = MKPlacemark(coordinate: user.coordinate)
                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: starPoint)
                request.destination = MKMapItem(placemark: endPont)
                request.transportType = .walking
                let direction = MKDirections(request: request)
                direction.calculate(completionHandler: { (response, error) in
                    guard let response = response else {return}
                    for route in response.routes {
                        mapView.addOverlay(route.polyline)
                    }
                })
            }
            // MARK: - CurrentSpot's CollectionView
            let action1 = UIAlertAction(title: "More", style: .default) { (UIAlertAction) in
                let thirdViewController = self.storyboard?.instantiateViewController(withIdentifier: "pushToSpotView") as? SpotViewController
                let user = view.annotation as? User
                thirdViewController?.title = user!.title
                //var user = view.annotation as? User
                //self.currentAnnotion?.pictures.append(UIImage(named: "skater")!)
                thirdViewController?.imageCell = user!.pictures
                self.navigationController?.pushViewController((thirdViewController ?? nil)!, animated: true)
            }
            alertController.addAction(action)
            alertController.addAction(action1)
            self.present(alertController, animated: true)
        }
        createRoute()
    }
}


