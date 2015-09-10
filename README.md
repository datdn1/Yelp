## Yelp

This is a Yelp search app using the [Yelp API](http://developer.rottentomatoes.com/docs/read/JSON).

Time spent: About 26h

### Features

### Required

- [ ] Search results page
   - [x] Table rows should be dynamic height according to the content height
   - [x] Custom cells should have the proper Auto Layout constraints. Have a problem with distance label. I don't understance why :(
   - [x] Search bar shoulxd be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- [ ] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
   - [x] The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).
   - [x] The filters tablexld dismiss the filters page and trigger the search w/ the new filter settings.
   - [x] Display some of the available Yelp categories (choose any 3-4 that you want).

#### Optional

- [ ] Search results page
   - [x] Infinite scroll for restaurant results
   - [x] Implement map view of restaurant results. But occcur problems after fitlter and search when presenting businesses in mapview :(
- [ ] Filter page
   - [x] Radius filter should expand as in the real Yelp app
   - [x] Categories should show a subset of the full list with a "See All" row to expand. Category list is here: http://www.yelp.com/developers/documentation/category_list (Links to an external site.)
- [x] Implement the restaurant detail page.

### Walkthrough

![Video Walkthrough](Yelp-Wal-3.gif)
