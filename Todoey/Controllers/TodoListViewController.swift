//
//  ViewController.swift
//  Todoey
//
//  Created by Siyu Zhang on 5/30/19.
//  Copyright © 2019 Siyu Zhang. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var todoItems : Results<Items>?
    var selectedCategory : Category? {
        //everything in this curly braces will happen once selectedCategory get a value
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        if let items = defaults.array(forKey: "ToDoListItem") as? [Items] {
//
//            itemArray = items
//
//        }
        //loadData()
    }
    
    //Mark - tableview datasource methods
    //what the cell desplyy and how many rows we wanted
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //ternary operator ==>
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "no items added yet"
        }
        
        return cell
        
    }
    
    //Mark - tableview delegate methods, it is going to get fired whenever it get clicked on the tableview
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            }catch {
                print("error saving done status, \(error)")
            }
            
        }
        
        tableView.reloadData()
        
        //use this method when you click on the cell ,it will only be grey for a shorter time
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark - add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        
        //ui alert pop up
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
             
             /*And at the time point when our app is running live inside the user's iPhone then the shared UI application*/
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Items()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch {
                    print("error saving new item, \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new items"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert
            , animated: true
            , completion: nil)
    }
    
//    func saveData(item : Items) {
//
//        do{
//            try realm.write {
//                realm.add(item)
//            }
//        }
//        catch{
//            print("error add item")
//        }
//        tableView.reloadData()
//    }
    
    //this func has a default value , if we do not pass any param into this func then we do the request shows up in the fun is Items.fetchRequest()
    func loadData() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

//Mark - search bar methods

extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }

    //this function will be triggered when the text in searchbar is changed, but when we lanuch the app it won't be triggered since text does n ot change
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            //we should not respond anymore and keyboard should go away
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

