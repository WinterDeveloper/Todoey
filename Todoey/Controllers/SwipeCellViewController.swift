//
//  SwipeCellViewController.swift
//  Todoey
//
//  Created by Siyu Zhang on 6/3/19.
//  Copyright © 2019 Siyu Zhang. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeCellViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        //this will be triggered when i click on the delete
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
//            if let category = self.categoryArray?[indexPath.row] {
//                do {
//                    try self.realm.write {
//                        self.realm.delete(category)
//                    }
//                }catch {
//                    print("error delete category, \(error)")
//                }
//
//            }
            
            //tableView.reloadData()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-Icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexpath : IndexPath) {
        
    }

}
