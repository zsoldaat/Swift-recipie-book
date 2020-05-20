//
//  MyRecipiesTableViewController.swift
//  mealMe
//
//  Created by Zac Soldaat on 2020-04-29.
//  Copyright © 2020 Zac Soldaat. All rights reserved.
//

import UIKit
import RealmSwift

class MyRecipiesTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var recipieArray: Results<Recipie>?
        
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        recipieArray = realm.objects(Recipie.self)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recipieArray = realm.objects(Recipie.self)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipieArray?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipieCell", for: indexPath)
        
        cell.textLabel?.text = recipieArray?[indexPath.row].recipieName ?? ""


        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    var selectedRecipieIndex: Int? = nil
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipieIndex = indexPath.row
        performSegue(withIdentifier: "ToDetailView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetailView" {
            if let detailView = segue.destination as? RecipieDetailViewController {
                detailView.selectedRecipie = recipieArray![selectedRecipieIndex!]
            }
        }
    }


}

extension MyRecipiesTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        recipieArray = recipieArray?.filter("recipieName CONTAINS[cd] %@", searchBar.text!)
        
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            recipieArray = realm.objects(Recipie.self)
            
            tableView.reloadData()
        }
    }
    
}
