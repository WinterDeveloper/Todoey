//
//  Category.swift
//  Todoey
//
//  Created by Siyu Zhang on 6/3/19.
//  Copyright © 2019 Siyu Zhang. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Items>()/*one-to-many relationship*/
}
