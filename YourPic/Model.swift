//
//  Model.swift
//  YourPic
//
//  Created by Maria Lacayo on 11/04/21.
//

import UIKit

struct MyStars: Codable{
    var fileName: String
}

struct Images: Codable{
    var fileName: String
    var onwerEmail: String
    var stars: Int
}
