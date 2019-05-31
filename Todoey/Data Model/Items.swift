//
//  Items.swift
//  Todoey
//
//  Created by Siyu Zhang on 5/30/19.
//  Copyright © 2019 Siyu Zhang. All rights reserved.
//

import Foundation

class Items : Encodable, Decodable {
    //all the field has to be standard type, custom type is not right
    var title : String = ""
    var done : Bool = false
    
}
