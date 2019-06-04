//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Siyu Zhang on 6/1/19.
//  Copyright © 2019 Siyu Zhang. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeCellViewController {
    
    let realm = try! Realm()

    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
        tableView.separatorStyle = .none
        
    }
    
    //Mark: - tableview data source method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1/*if it is nil then return 1*/
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "no category added yet"
        
        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].color ?? "1D98F6")
        
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)

        return cell
    }
    
    //Mark: - tableview delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        //use this method when you click on the cell ,it will only be grey for a shorter time
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //this method will be triggered just before perfoming that segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
            
        }
    }
    
    //Mark: - data manipulation method:save and load
    
    func loadCategory() {
        
        categoryArray = realm.objects(Category.self)
        
        categoryArray = categoryArray?.sorted(byKeyPath: "name", ascending: true)
        
        tableView.reloadData()

    }
    
    func save(category : Category) {
        
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("error saving context")
        }
        tableView.reloadData()
        
    }
    
    //Mark: - delete data from swipe
    override func updateModel(at indexpath: IndexPath) {
        if let category = self.categoryArray?[indexpath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category.items)
                    self.realm.delete(category)
                }
            }catch {
                print("error delete category, \(error)")
            }

        }
        //tableView.reloadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
            //self.categoryArray.append(newCategory)
            //we do not need to append since result is an auto-updating container and it will monitor changes
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "create new categories"
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
}



