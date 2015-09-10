//
//  Filter.swift
//  Yelp
//
//  Created by datdn1 on 9/5/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

enum FilterSectionType:Int{
    case DealSection = 0
    case DistanceSection = 1
    case SortSection = 2
    case CategorySection = 3
}

struct ItemInSection{
    var title:String?
    var parameterValue:AnyObject?
    var selected:Bool?
    init(title:String, parameterValue:AnyObject, selected:Bool = false){
        self.title = title
        self.parameterValue = parameterValue
        self.selected = selected
    }
}
class FilterSection{
    var titleHeader:String?
    var itemsInSection:[ItemInSection]?
    var filterSectionType:FilterSectionType?
    var parameterFilterName:String?
    var expanded:Bool?
    
    init(titleHeader:String, parameterFilterName:String, itemsInSection:[ItemInSection], filterSectionType:FilterSectionType, expanded:Bool = false){
        self.titleHeader = titleHeader
        self.itemsInSection = itemsInSection
        self.filterSectionType = filterSectionType
        self.parameterFilterName = parameterFilterName
        self.expanded = expanded
    }
    var selectedItemIndex:Int{
        get{
            for var item = 0; item < self.itemsInSection?.count; item++ {
                if self.itemsInSection![item].selected!{
                    return item
                }
            }
            return -1
        }
        set{
            if self.filterSectionType == .DistanceSection || self.filterSectionType == .SortSection{
                self.itemsInSection![self.selectedItemIndex].selected = false
            }
            self.itemsInSection![newValue].selected = true
        }
    }
    
    var selectedItems:[ItemInSection]{
        get{
            var items = [ItemInSection]()
            for item in self.itemsInSection!{
                if item.selected! {
                    items.append(item)
                }
            }
            return items
        }
    }
}

class FilterGroup{
    var filters = [
        FilterSection(titleHeader: "Deal",
            parameterFilterName: "deals_filter",
            itemsInSection: [ItemInSection(title: "Offering a Deal", parameterValue: false, selected: false)],
            filterSectionType: .DealSection),
        FilterSection(titleHeader: "Distance",
            parameterFilterName: "radius_filter",
            itemsInSection: [
                ItemInSection(title: "Auto", parameterValue: 0.0, selected: true),
                ItemInSection(title: "0.3 miles", parameterValue: 0.3, selected: false),
                ItemInSection(title: "1 mile", parameterValue: 1.0, selected: false),
                ItemInSection(title: "5 miles", parameterValue: 5.0, selected: false),
                ItemInSection(title: "20 miles", parameterValue: 20.0, selected: false)
            ],
            filterSectionType: FilterSectionType.DistanceSection),
        FilterSection(titleHeader: "Sort by",
            parameterFilterName: "sort",
            itemsInSection: [
                ItemInSection(title: "Best matched", parameterValue: YelpSortMode.BestMatched.rawValue, selected: true),
                ItemInSection(title: "Distance", parameterValue: YelpSortMode.Distance.rawValue, selected: false),
                ItemInSection(title: "Highest rated", parameterValue: YelpSortMode.HighestRated.rawValue, selected: false)
                ],
            filterSectionType: FilterSectionType.SortSection),
        FilterSection(titleHeader: "Categories",
            parameterFilterName: "category_filter",
            itemsInSection: [
                ItemInSection(title: "Afghan", parameterValue: "afghani"),
                ItemInSection(title: "African", parameterValue: "african"),
                ItemInSection(title: "American (New)", parameterValue: "newamerican"),
                ItemInSection(title: "American (Traditional)", parameterValue: "tradamerican"),
                ItemInSection(title: "Arabian", parameterValue: "arabian"),
                ItemInSection(title: "Argentine", parameterValue: "argentine"),
                ItemInSection(title: "Armenian", parameterValue: "armenian"),
                ItemInSection(title: "Asian Fusion", parameterValue: "asianfusion"),
                ItemInSection(title: "Australian", parameterValue: "australian"),
                ItemInSection(title: "Austrian", parameterValue: "austrian"),
                ItemInSection(title: "Bangladeshi", parameterValue: "bangladeshi"),
                ItemInSection(title: "Barbeque", parameterValue: "bbq"),
                ItemInSection(title: "Basque", parameterValue: "basque"),
                ItemInSection(title: "Belgian", parameterValue: "belgian"),
                ItemInSection(title: "Brasseries", parameterValue: "brasseries"),
                ItemInSection(title: "Brazilian", parameterValue: "brazilian"),
                ItemInSection(title: "Breakfast & Brunch", parameterValue: "breakfast_brunch"),
                ItemInSection(title: "British", parameterValue: "british"),
                ItemInSection(title: "Buffets", parameterValue: "buffets"),
                ItemInSection(title: "Burgers", parameterValue: "burgers"),
                ItemInSection(title: "Burmese", parameterValue: "burmese"),
                ItemInSection(title: "Cafes", parameterValue: "cafes"),
                ItemInSection(title: "Cafeteria", parameterValue: "cafeteria"),
                ItemInSection(title: "Cajun/Creole", parameterValue: "cajun"),
                ItemInSection(title: "Cambodian", parameterValue: "cambodian"),
                ItemInSection(title: "Caribbean", parameterValue: "caribbean"),
                ItemInSection(title: "Catalan", parameterValue: "catalan"),
                ItemInSection(title: "Cheesesteaks", parameterValue: "cheesesteaks"),
                ItemInSection(title: "Chicken Wings", parameterValue: "chicken_wings"),
                ItemInSection(title: "Chinese", parameterValue: "chinese"),
                ItemInSection(title: "Comfort Food", parameterValue: "comfortfood"),
                ItemInSection(title: "Creperies", parameterValue: "creperies"),
                ItemInSection(title: "Cuban", parameterValue: "cuban"),
                ItemInSection(title: "Czech", parameterValue: "czech"),
                ItemInSection(title: "Delis", parameterValue: "delis"),
                ItemInSection(title: "Diners", parameterValue: "diners"),
                ItemInSection(title: "Ethiopian", parameterValue: "ethiopian"),
                ItemInSection(title: "Fast Food", parameterValue: "hotdogs"),
                ItemInSection(title: "Filipino", parameterValue: "filipino"),
                ItemInSection(title: "Fish & Chips", parameterValue: "fishnchips"),
                ItemInSection(title: "Fondue", parameterValue: "fondue"),
                ItemInSection(title: "Food Court", parameterValue: "food_court"),
                ItemInSection(title: "Food Stands", parameterValue: "foodstands"),
                ItemInSection(title: "French", parameterValue: "french"),
                ItemInSection(title: "Gastropubs", parameterValue: "gastropubs"),
                ItemInSection(title: "German", parameterValue: "german"),
                ItemInSection(title: "Gluten-Free", parameterValue: "gluten_free"),
                ItemInSection(title: "Greek", parameterValue: "greek"),
                ItemInSection(title: "Halal", parameterValue: "halal"),
                ItemInSection(title: "Hawaiian", parameterValue: "hawaiian"),
                ItemInSection(title: "Himalayan/Nepalese", parameterValue: "himalayan"),
                ItemInSection(title: "Hot Dogs", parameterValue: "hotdog"),
                ItemInSection(title: "Hot Pot", parameterValue: "hotpot"),
                ItemInSection(title: "Hungarian", parameterValue: "hungarian"),
                ItemInSection(title: "Iberian", parameterValue: "iberian"),
                ItemInSection(title: "Indian", parameterValue: "indpak"),
                ItemInSection(title: "Indonesian", parameterValue: "indonesian"),
                ItemInSection(title: "Irish", parameterValue: "irish"),
                ItemInSection(title: "Italian", parameterValue: "italian"),
                ItemInSection(title: "Japanese", parameterValue: "japanese"),
                ItemInSection(title: "Korean", parameterValue: "korean"),
                ItemInSection(title: "Kosher", parameterValue: "kosher"),
                ItemInSection(title: "Laotian", parameterValue: "laotian"),
                ItemInSection(title: "Latin American", parameterValue: "latin"),
                ItemInSection(title: "Live/Raw Food", parameterValue: "raw_food"),
                ItemInSection(title: "Malaysian", parameterValue: "malaysian"),
                ItemInSection(title: "Mediterranean", parameterValue: "mediterranean"),
                ItemInSection(title: "Mexican", parameterValue: "mexican"),
                ItemInSection(title: "Middle Eastern", parameterValue: "mideastern"),
                ItemInSection(title: "Modern European", parameterValue: "modern_european"),
                ItemInSection(title: "Mongolian", parameterValue: "mongolian"),
                ItemInSection(title: "Moroccan", parameterValue: "moroccan"),
                ItemInSection(title: "Pakistani", parameterValue: "pakistani"),
                ItemInSection(title: "Persian/Iranian", parameterValue: "persian"),
                ItemInSection(title: "Peruvian", parameterValue: "peruvian"),
                ItemInSection(title: "Pizza", parameterValue: "pizza"),
                ItemInSection(title: "Polish", parameterValue: "polish"),
                ItemInSection(title: "Portuguese", parameterValue: "portuguese"),
                ItemInSection(title: "Russian", parameterValue: "russian"),
                ItemInSection(title: "Salad", parameterValue: "salad"),
                ItemInSection(title: "Sandwiches", parameterValue: "sandwiches"),
                ItemInSection(title: "Scandinavian", parameterValue: "scandinavian"),
                ItemInSection(title: "Scottish", parameterValue: "scottish"),
                ItemInSection(title: "Seafood", parameterValue: "seafood"),
                ItemInSection(title: "Singaporean", parameterValue: "singaporean"),
                ItemInSection(title: "Slovakian", parameterValue: "slovakian"),
                ItemInSection(title: "Soul Food", parameterValue: "soulfood"),
                ItemInSection(title: "Soup", parameterValue: "soup"),
                ItemInSection(title: "Southern", parameterValue: "southern"),
                ItemInSection(title: "Spanish", parameterValue: "spanish"),
                ItemInSection(title: "Steakhouses", parameterValue: "steak"),
                ItemInSection(title: "Sushi Bars", parameterValue: "sushi"),
                ItemInSection(title: "Taiwanese", parameterValue: "taiwanese"),
                ItemInSection(title: "Tapas Bars", parameterValue: "tapas"),
                ItemInSection(title: "Tapas/Small Plates", parameterValue: "tapasmallplates"),
                ItemInSection(title: "Tex-Mex", parameterValue: "tex-mex"),
                ItemInSection(title: "Thai", parameterValue: "thai"),
                ItemInSection(title: "Turkish", parameterValue: "turkish"),
                ItemInSection(title: "Ukrainian", parameterValue: "ukrainian"),
                ItemInSection(title: "Uzbek", parameterValue: "uzbek"),
                ItemInSection(title: "Vegan", parameterValue: "vegan"),
                ItemInSection(title: "Vegetarian", parameterValue: "vegetarian"),
                ItemInSection(title: "Vietnamese", parameterValue: "vietnamese")
            ],
            filterSectionType: FilterSectionType.CategorySection)
    ]
}


