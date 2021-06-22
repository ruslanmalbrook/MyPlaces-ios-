//
//  ViewController.swift
//  MyPlaces
//
//  Created by Ruslan Malbrook on 08.06.2021.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    //    var places = Place.getPlaces()
    private var places: Results<Place>!
    private var filteredPlaces: Results<Place>!
    
    private var ascendingSorting = true
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reversedSortingBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
        
        //Setup SearchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Now"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    //MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPlaces.count
        }
        
        return places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        
        let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]

        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfCell.image = UIImage(data: place.imageData!)
        
        cell.ratingCosmosView.rating = place.rating

        return cell
    }
    
    //MARK: - Table View Delegate
    
    //may be used for more functionality!
    
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let place = places[indexPath.row]
//
//        let deleteAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Delete") { _, _, _ in
//            StorageManager.deleteObject(place)
//            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
//        }
//
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let place = places[indexPath.row]
            
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 85
//    }
    
    @IBAction func unwindSeque(_ seque: UIStoryboardSegue) {
        guard let newPlaceVC = seque.source as? NewPlaceViewController else { return }
        
        newPlaceVC.savePlace()
//        places.append(newPlaceVC.newPlace!)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
            
            let newPlaceVC = segue.destination as! NewPlaceViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        sorting()
    }
    
    @IBAction func reversedSorting(_ sender: Any) {
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reversedSortingBtn.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingBtn.image = #imageLiteral(resourceName: "ZA")
        }
        
        sorting()
    }
    
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        
        tableView.reloadData()
    }
    
}

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@ OR type CONTAINS[c] %@", searchText, searchText, searchText)
        tableView.reloadData()
    }
}
