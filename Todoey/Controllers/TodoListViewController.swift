//
//  ViewController.swift
//  Todoey
//
//  Created by Siyu Zhang on 5/30/19.
//  Copyright © 2019 Siyu Zhang. All rights reserved.
//

import UIKit
import  CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Items]()
    var selectedCategory : Category? {
        //everything in this curly braces will happen once selectedCategory get a value
        didSet {
            loadData()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    let context =/*this is the delegate of the application object*/ (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
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
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //ternary operator ==>
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    //Mark - tableview delegate methods, it is going to get fired whenever it get clicked on the tableview
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //grab a cell
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //force it to call datasource method again,it is necessary,if youhave 3 iiitems in the tableview, then it will call this method 3 times
        saveData()
        
        //use this method when you click on the cell ,it will only be grey for a shorter time
        tableView.deselectRow(at: indexPath, animated: true)
        //also we want a check mark
    }
    
    //Mark - add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        
        //ui alert pop up
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
             
             /*And at the time point when our app is running live inside the user's iPhone then the shared UI application
             
             will correspond to our live application object.*/
            let newItem = Items(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            // what will happen once the user clicked the add item button on ui alert
            self.itemArray.append(newItem)//it is never be a nil even if it is an empty, it is an empty string
            
            self.saveData()
            
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
    
    func saveData() {
        
        do{
            try context.save()
        }
        catch{
            print("error saving context")
        }
        tableView.reloadData()
    }
    
    //this func has a default value , if we do not pass any param into this func then we do the request shows up in the fun is Items.fetchRequest()
    func loadData(with request : NSFetchRequest<Items> = Items.fetchRequest(), predicate : NSPredicate? = nil) {
        //we only want items that have same parentCategory with selectedCategory
        let categoryPredicate = NSPredicate(format: "parentCategory.name Matches %@", selectedCategory!.name!)
        
        //let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, categoryPredicate])
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
        }
        else {
           request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print("error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}

//Mark - search bar methods

extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Items> = Items.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        //sort items we get back
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadData(with: request, predicate : predicate)
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

