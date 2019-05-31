//
//  ViewController.swift
//  Todoey
//
//  Created by Siyu Zhang on 5/30/19.
//  Copyright © 2019 Siyu Zhang. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Items]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        if let items = defaults.array(forKey: "ToDoListItem") as? [Items] {
//
//            itemArray = items
//
//        }
        loadData()
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
            
            let newItem = Items()
            newItem.title = textField.text!
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
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to :dataFilePath!)
        }
        catch{
            print("error printing the array: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Items].self, from: data)
            }
            catch {
                print("items: any...")
            }
        }
    }
}

