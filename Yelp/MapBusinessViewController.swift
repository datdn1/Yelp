//
//  MapBusinessViewController.swift
//  Yelp
//
//  Created by datdn1 on 9/7/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class MapBusinessViewController: UIViewController {
    
    var business:Business!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = business.name
        self.thumbImageView.setImageWithURL(business.imageURL)
        self.distanceLabel.text = business.distance
        self.ratingImageView.setImageWithURL(business.ratingImageURL)
        self.reviewCountLabel.text = "\(business.reviewCount!) Reviews"
        self.addressLabel.text = business.address
        self.categoriesLabel.text = business.categories
        
        self.thumbImageView.layer.cornerRadius = 10
        self.thumbImageView.clipsToBounds = true
        self.title = business.name
        
        let initialLocation = CLLocation(latitude: business.latitude!, longitude: business.longitude!)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        self.mapView.setRegion(coordinateRegion, animated: true)
        
        var businessLocationPin = MKPointAnnotation()
        let latitude:CLLocationDegrees = business.latitude!
        let longitude:CLLocationDegrees = business.longitude!
        businessLocationPin.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        businessLocationPin.title = business.name
        businessLocationPin.subtitle = business.address
        self.mapView.addAnnotation(businessLocationPin)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
