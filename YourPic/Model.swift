//
//  Model.swift
//  YourPic
//
//  Created by Maria Lacayo on 11/04/21.
//

import UIKit

struct ResultsFlickr: Codable{
    var stat: String
    var photos: PhotoArray
}

struct PhotoArray: Codable{
    var photo: [Photo]
}

struct Photo: Codable{
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
}
