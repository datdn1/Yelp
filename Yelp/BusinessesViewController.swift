//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

enum PresentType {
    case List
    case Map
}

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterViewControllerDelegate, UISearchBarDelegate {

    var moreLoading:Bool!
    var searching:Bool!
    var present:PresentType!
    
    var mapView:MKMapView!
    
    var businesses: [Business]!{
        didSet {
            if self.businesses.count > 0 {
                if moreLoading! {
                    updateTableView(true)
                }
                else {
                    updateTableView(false)
                }
            }
        }
        willSet(newValue) {
            if newValue.count > 0 {
                self.offsetBussiness = self.businesses.count
                println("Offset:\(self.offsetBussiness)")
            }
            else {
                self.offsetBussiness = 0
                println("Offset:\(self.offsetBussiness)")
            }
        }
    }
    var filters: [String:AnyObject]!
    var searchBar:UISearchBar!
    var termSearch:String!
    
    var offsetBussiness:Int!
    var currentNumberBussinesses:Int!
    var refreshBusinessControl:UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var errorInfromationView: UIView!
    
    @IBOutlet weak var reloadBussinessesButton: UIButton!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var displayTypeBarButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.businesses = []
        self.moreLoading = false
        self.searching = false
        self.present = .List
        
        self.mapView = MKMapView()
        mapView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        mapView.mapType = MKMapType.Standard
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        
        // Configure table view
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        
        self.currentNumberBussinesses = 0
        self.offsetBussiness = 0
        
        self.errorInfromationView.hidden = true
        self.tableView.hidden = false
        
        // Configure navigation bar
        self.searchBar = UISearchBar()
        self.searchBar.backgroundColor = UIColor.clearColor()
        self.searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar
        self.searchBar.delegate = self
        
        self.tableView.infiniteScrollIndicatorStyle = .White
        self.tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            self.loadMoreBusiness()
            tableView.finishInfiniteScroll()
        }
        self.termSearch = "Restaurants"   // Default term for search businesses
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        searchDefaultBusinesses()
    }
    
    func loadMoreBusiness() {
        if self.businesses.count < YelpClient.sharedInstance.totalBusinesses {
            self.moreLoading = true
            if self.filters != nil {
                self.filterViewController(nil, didUpdateFilters: self.filters)
            }
            else {
                self.searchDefaultBusinesses()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell") as! BusinessCell
        cell.positionOnTableView = indexPath.row + 1
        cell.business = self.businesses[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = segue.identifier!
        if identifier == "ShowFilterController" {
            let navigationViewController = segue.destinationViewController as! UINavigationController
            let filterViewController = navigationViewController.topViewController as! FilterViewController
            filterViewController.delegate = self
        }
        else if identifier == "ShowDetailBusiness" {
            let selectedCell = sender as! BusinessCell
            let detailBusinessViewController = segue.destinationViewController as! MapBusinessViewController
            detailBusinessViewController.business = selectedCell.business
        }
    }
    
    func filterViewController(filterViewController: FilterViewController?, didUpdateFilters filters: [String : AnyObject]) {
        self.filters = filters
        let categories = filters["category_filter"] as! [String]
        let sortRawValue = filters["sort"] as! Int
        let sort = YelpSortMode(rawValue: sortRawValue)
        let deals = filters["deals_filter"] as? Bool
        let radius = filters["radius_filter"] as? Double
        
        var offset:Int? = nil
        if self.moreLoading! {
            println("Offset for search:\(self.offsetBussiness)")
            offset = self.businesses.count
        }
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Business.searchWithTerm(self.termSearch, radius:radius, offset:offset, sort: sort, categories: categories, deals: deals)
            {(busines: [Business]!, error: NSError!) -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if busines != nil {
                    if busines.count > 0 {
                        self.navigationItem.leftBarButtonItem?.enabled = true
                        self.navigationItem.rightBarButtonItem?.enabled = true
                        self.searchBar.userInteractionEnabled = true
                        self.errorInfromationView.hidden = true
                        self.tableView.hidden = false
                        if filterViewController != nil || self.searching! {
                            self.businesses = []
                        }
                        self.businesses = self.businesses + busines!
                    }
                    else {
                        self.businesses = []
                        self.navigationItem.rightBarButtonItem?.enabled = false
                        self.errorMessageLabel.text = "No found. Please enter with other term or setting filter."
                        self.tableView.hidden = true
                        self.errorInfromationView.hidden = false
                    }
                }
                else {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.navigationItem.leftBarButtonItem?.enabled = false
                    self.navigationItem.rightBarButtonItem?.enabled = false
                    self.searchBar.userInteractionEnabled = false
                    self.errorMessageLabel.text = error.localizedDescription
                    self.tableView.hidden = true
                    self.errorInfromationView.hidden = false
                }
        }
    }
    @IBAction func onReloadBusinesses(sender: UIButton) {
        if self.filters != nil {
            self.filterViewController(nil, didUpdateFilters: self.filters)
        }
        else {
            searchDefaultBusinesses()
        }
    }
    
    func searchDefaultBusinesses(){
        println(self.termSearch)
        var offset:Int? = nil
        if self.moreLoading! {
            offset = self.businesses.count
        }
        Business.searchWithTerm(self.termSearch, radius:nil, offset:offset, sort: .BestMatched, categories: nil, deals: false) { (businesses: [Business]!, error: NSError!) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if businesses != nil {
                if businesses.count > 0 {
                    self.errorInfromationView.hidden = true
                    self.navigationItem.leftBarButtonItem?.enabled = true
                    self.navigationItem.rightBarButtonItem?.enabled = true
                    self.searchBar.userInteractionEnabled = true
                    self.tableView.hidden = false
                    if self.searching! {
                        self.businesses = []
                    }
                    self.businesses = self.businesses + businesses!
                }
                else {
                    self.businesses = []
                    self.navigationItem.rightBarButtonItem?.enabled = false
                    self.errorMessageLabel.text = "No found. Please enter with other term or setting filter."
                    self.tableView.hidden = true
                    self.errorInfromationView.hidden = false
                }
            }
            else {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.navigationItem.leftBarButtonItem?.enabled = false
                self.navigationItem.rightBarButtonItem?.enabled = false
                self.searchBar.userInteractionEnabled = false
                self.errorMessageLabel.text = error.localizedDescription
                self.tableView.hidden = true
                self.errorInfromationView.hidden = false
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println(searchBar.text)
        self.searching = true
        self.termSearch = searchBar.text
        if self.filters != nil {
            self.filterViewController(nil, didUpdateFilters: self.filters)
        }
        else {
            self.searchDefaultBusinesses()
        }
        self.searchBar.resignFirstResponder()
    }
    
    @IBAction func onTapTableView(sender: AnyObject) {
        self.searchBar.resignFirstResponder()
        self.tableView.becomeFirstResponder()
    }
    
    func updateTableView(moreLoading:Bool) {
        if moreLoading {
            var indexPathArrRowInsert = [NSIndexPath]()
            for rowToInsert in offsetBussiness...self.businesses.count-1 {
                var indexPathRow = NSIndexPath(forRow: rowToInsert, inSection: 0)
                indexPathArrRowInsert.append(indexPathRow)
            }
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths(indexPathArrRowInsert, withRowAnimation: UITableViewRowAnimation.Bottom)
            self.tableView.endUpdates()
            self.moreLoading = false
        }
        else {
            if self.searching! {
                self.searching = false
            }
            if self.present == .Map {
                showBusinessOnMapView()
            }
            else {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func tongleListMapBusiness(sender: UIBarButtonItem) {
        if self.present == .List {
            self.view.addSubview(self.mapView)
            UIView.transitionFromView(self.tableView, toView: mapView, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            showBusinessOnMapView()
            self.present = .Map
        }
        else if self.present == .Map {
            UIView.transitionFromView(self.mapView, toView: self.tableView, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            self.present = .List
        }

    }
    
    func showBusinessOnMapView() {
        // Configure region for mapview
        let initialLocation = CLLocation(latitude: 37.785771, longitude: -122.406165)
        let regionRadius: CLLocationDistance = 10000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        self.mapView.setRegion(coordinateRegion, animated: true)
        for business in self.businesses {
            let businessAnnotation = createAnnotations(business)
            self.mapView.addAnnotation(businessAnnotation)
        }
    }
    
    func createAnnotations(business:Business) -> MKPointAnnotation {
        var businessLocationPin = MKPointAnnotation()
        let latitude:CLLocationDegrees = business.latitude!
        let longitude:CLLocationDegrees = business.longitude!
        businessLocationPin.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        businessLocationPin.title = business.name
        businessLocationPin.subtitle = business.address
        return businessLocationPin
    }
    
}
