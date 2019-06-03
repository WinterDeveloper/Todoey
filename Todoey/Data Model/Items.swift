//
//  Items.swift
//  Todoey
//
//  Created by Siyu Zhang on 6/3/19.
//  Copyright © 2019 Siyu Zhang. All rights reserved.
//

import Foundation
import RealmSwift

class Items : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
