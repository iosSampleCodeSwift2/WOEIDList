//
//  DetailViewController.swift
//  WOEIDList
//
//  Created by Daesub Kim on 2016. 11. 29..
//  Copyright © 2016년 DaesubKim. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var aLabel: UILabel!
    var woeid: WOEID!
    
    @IBOutlet weak var aMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print(woeid.description)
        aLabel.text = woeid.description
        
        zoomToRegion(woeid.latitude, woeid.longitude)
        aMapView.addAnnotation(woeid)
        aMapView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func zoomToRegion(lat: CLLocationDegrees, _ lon: CLLocationDegrees) {
        let regionRadius: CLLocationDistance = 1000
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region = MKCoordinateRegionMakeWithDistance(location, regionRadius * 5.0, regionRadius * 7.0)
        
        aMapView.setRegion(region, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? WOEID {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as? UIView
            }
            return view
        }
        return nil
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        //dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    /*
     // MARK: – Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


