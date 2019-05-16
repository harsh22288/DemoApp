//
//  ViewController.swift
//  DemoApp
//
//  Created by  Harsh Saxena on 14/05/19.
//  Copyright © 2019  Harsh Saxena. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    //let dataManager = DataFile()
    var dataArray = [DataFile]()
    var filterArray = [DataFile]()
    let searchController = UISearchController(searchResultsController: nil)
    let locationManager = CLLocationManager()
    var location = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here"
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false;
        searchController.searchBar.searchBarStyle = .minimal;
        self.definesPresentationContext = true;
        // Include the search bar within the navigation bar.
        navigationItem.titleView = self.searchController.searchBar;
        tableView.dataSource = self
        tableView.delegate = self
        
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        self.readJson()
        

        // Do any additional setup after loading the view.
    }
    
    
    
    private func readJson() {
        /* retreiving the data from the local json file
            locating the path and serializing the data in JSON format
         */
        let file = Bundle.main.path(forResource: "cities", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: file!))
        let json = try? JSONSerialization.jsonObject(with: data!, options:[])

        
        /* The format of json is an array and type casted into the relevant data type.
         Relevant properties are retrieved and stored in dataArray which is of struct type.
        
         Using array because its an ordered collection to store same type of data-
         each element in the array is an instance of structure DataFile and every unique element can be accessed by using the dot operator on a particular object of the array
         Every object stored in the array is of struct type; these are value types which helps in memory issues when passing them around
         */
        if let jsonObject = json as? [[String:Any]] {
            for dataObject in jsonObject {
                guard let name = dataObject["name"] as? String else {return}
                guard let country = dataObject["country"] as? String else {return}
                guard let id = dataObject["_id"] as? Int else {return}
                guard let coordinate = dataObject["coord"] as? [String:Any] else {return}
                guard let longitude = coordinate["lon"] as? Double else {return}
                guard let latitude = coordinate["lat"] as? Double else {return}
                
                
               
                dataArray.append(DataFile(id: id, latitude: latitude, longitude: longitude, country: country, name: name))
            }
            
        }
        dataArray.sort(by: <)

    }
    
    private func convertStringDataToCoordinates(dataObject: DataFile) -> CLLocationCoordinate2D{
        let latitude = dataObject.latitude
        let longitude = dataObject.longtiude
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return coordinate
    }
    
}


// TABLE VIEW DELEGATES
extension ViewController:  UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.isActive) {
            if(filterArray.count > 0){
                return filterArray.count
            }else {
                return 1
            }
        }else {
            return dataArray.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dataObject = DataFile()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CitiesTableViewCell
        
        
        if(searchController.isActive) {
            if(filterArray.count > 0){
                dataObject = filterArray[indexPath.row]
            }else {
                cell.nameLabel.text = "Not Found"
                cell.countryLabel.text = ""
                cell.distanceLabel.text = ""
                return cell
            }
        }else {
             dataObject = dataArray[indexPath.row]
        }
       
       
        let coordinate = convertStringDataToCoordinates(dataObject: dataObject)
        let dista = calculateDistanceFromCoordinates(destinationCoordinate: coordinate, startingCoordinate: location.coordinate)
        
        
        cell.nameLabel.text = dataObject.name
        cell.countryLabel.text = dataObject.country
        if (location.coordinate.longitude == 0.0 && location.coordinate.latitude == 0.0 ){
            cell.distanceLabel?.text = "Calculating......"
        }else {
            cell.distanceLabel?.text = String(dista) + " kms"
            
        }
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}

// Search Bar Delegates

extension ViewController: UISearchResultsUpdating, UISearchBarDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        filterSearchController(searchString: searchController.searchBar.text!)
    }
    
    func filterSearchController(searchString: String){
        
        /* The previous code had the searching feature and filtering the data on the main thread resulting in a laggy UI execution of entering search text and filtering of data in the table
         Corrective action taken is to free up the main thread and therefore a more responsive search bar implementation along with the filtering of data in tableview is being carried out
         A concurrent thread performing an asynchronous task of filtering the data of the array based on the search parameters is carried out on this thread.
         The concurrent thread filters the data and the main thread updates the UI depending on the filter array
         We treat the filtering process the same as fetching data from a webservice call.
         */
        DispatchQueue.global(qos: .default).async {
            self.filterArray = self.dataArray.filter({$0.name.lowercased().hasPrefix(searchString.lowercased())})
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
    }
}

// Location Manager Delegates

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations[0] as CLLocation
        locationManager.stopUpdatingLocation()
        tableView.reloadData()
        
    }
    
    func calculateDistanceFromCoordinates(destinationCoordinate: CLLocationCoordinate2D, startingCoordinate: CLLocationCoordinate2D) -> Double {
        
        let destinaton = CLLocation(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
        let start = CLLocation(latitude: startingCoordinate.latitude, longitude: startingCoordinate.longitude)
        let distance = start.distance(from: destinaton)
        return round((distance/1000.0)*100)/100
    }
}
