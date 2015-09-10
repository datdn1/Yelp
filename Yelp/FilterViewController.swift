//
//  FilterViewController.swift
//  Yelp
//
//  Created by datdn1 on 9/4/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate{
    optional func filterViewController(filterViewController:FilterViewController?, didUpdateFilters filters:[String:AnyObject])
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var filterTableView: UITableView!
    
    weak var delegate:FilterViewControllerDelegate?
    
    var filterGroup:FilterGroup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filterTableView.delegate = self
        self.filterTableView.dataSource = self
        self.filterGroup = FilterGroup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var filters = createParameters(filterGroup)
        delegate?.filterViewController!(self, didUpdateFilters: filters)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filterGroup.filters.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title:String? = nil
        let filterSection = self.filterGroup.filters[section]
        return filterSection.titleHeader
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // get filter section
        let filterSection = filterGroup.filters[section]
        if !(filterSection.expanded!){
            let filterSectionType = filterSection.filterSectionType
            if filterSectionType == FilterSectionType.CategorySection{
                return 4  // 3 categories + 1 See All item
            }
            else{
                return 1
            }
        }
        else{
            return filterSection.itemsInSection!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "FilterCell"
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        
        let filterSection = self.filterGroup.filters[indexPath.section]
        switch filterSection.filterSectionType! {
            case .DistanceSection, .SortSection:
                if filterSection.expanded! {
                    let rowItem = filterSection.itemsInSection![indexPath.row]
                    cell.textLabel?.text = rowItem.title
                    if rowItem.selected! {
                        cell.accessoryView = UIImageView(image: UIImage(named: "checked-icon"))
                    }
                    else {
                        cell.accessoryView = UIImageView(image: UIImage(named: "unchecked-icon"))
                    }
                }
                else {
                    cell.textLabel?.text = filterSection.itemsInSection![filterSection.selectedItemIndex].title
                    cell.accessoryView = UIImageView(image: UIImage(named: "dropdown-icon"))
                }
            case .CategorySection:
                if filterSection.expanded! || indexPath.row < 3{
                    let rowItem = filterSection.itemsInSection![indexPath.row]
                    cell.textLabel?.text = rowItem.title
                    if rowItem.selected! {
                        cell.accessoryView = UIImageView(image: UIImage(named: "checked-icon"))
                    }
                    else {
                        cell.accessoryView = UIImageView(image: UIImage(named: "unchecked-icon"))
                    }
                }
                else {
                    cell.textLabel!.text = "See All"
                    cell.textLabel!.textAlignment = NSTextAlignment.Center
                    cell.textLabel!.textColor = .redColor()
                    cell.tag = 100
                }
            default:
                let item = filterSection.itemsInSection![indexPath.row]
                cell.textLabel!.text = item.title
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                let switchView = UISwitch(frame: CGRectZero)
                switchView.on = item.selected!
                switchView.onTintColor = UIColor.redColor()
                switchView.addTarget(self, action: "dealChanged:", forControlEvents: UIControlEvents.ValueChanged)
                cell.accessoryView = switchView
        }
        return cell
    }
    
    func dealChanged(dealSwitch:UISwitch) {
        if dealSwitch.on {
            println("ON")
        }
        else {
            println("OFF")
        }
            filterGroup.filters[0].itemsInSection![0].selected = dealSwitch.on
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let filterSection = filterGroup.filters[indexPath.section]
        switch filterSection.filterSectionType! {
        case .DistanceSection, .SortSection:
            if filterSection.expanded! {
                let preSelectedIndex = filterSection.selectedItemIndex
                if preSelectedIndex != indexPath.row {
                    filterSection.selectedItemIndex = indexPath.row
                }
            }
            let expanded = filterSection.expanded!
            filterSection.expanded = !expanded
            if expanded {
                self.filterTableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            }
            else {
                self.filterTableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            }
            
        case .CategorySection:
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
            if !(filterSection.expanded!) {
                if selectedCell?.tag == 100 {
                    filterSection.expanded = true
                    self.filterTableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
                }
                else {
                    let selectedItem = filterSection.itemsInSection![indexPath.row]
                    filterGroup.filters[indexPath.section].itemsInSection![indexPath.row].selected = !(selectedItem.selected!)
                    self.filterTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            }
            else {
                let selectedItem = filterSection.itemsInSection![indexPath.row]
                filterGroup.filters[indexPath.section].itemsInSection![indexPath.row].selected = !(selectedItem.selected!)
                self.filterTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        default:
            break

        }
    }
    
    func createParameters(filterGroup:FilterGroup) -> [String:AnyObject] {
        var parameters = [String:AnyObject]()
        for filterSection in filterGroup.filters {
            switch filterSection.filterSectionType! {
                case .DealSection:
                    if filterSection.selectedItemIndex == 0 {
                        parameters[filterSection.parameterFilterName!] = true
                    }
                case .DistanceSection:
                    let distance = filterSection.itemsInSection![filterSection.selectedItemIndex].parameterValue as! Double
                    parameters[filterSection.parameterFilterName!] = distance == 0.0 ? nil : distance
                case .SortSection:
                    parameters[filterSection.parameterFilterName!] = filterSection.itemsInSection![filterSection.selectedItemIndex].parameterValue as! Int
                case .CategorySection:
                    var categories = [String]()
                    for item in filterSection.selectedItems {
                        categories.append(item.parameterValue as! String)
                    }
                    parameters[filterSection.parameterFilterName!] = categories
                default:
                    break
            }
        }
        return parameters
    }
}
