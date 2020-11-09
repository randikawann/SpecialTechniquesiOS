//
//  Profile.swift
//  SpecialTechniquesiOS
//
//  Created by Randika Wanninayaka on 11/9/2563 BE.
//

import Foundation

struct WholeResponse: Codable {
    var status: Int?
    var data: [Profile]
}
struct Profile: Codable{
    var id: Int?
    var title: String?
    var description: String?
    var address: String?
    var postcode:String?
    var phoneNumber: String?
    var latitude: String?
    var longitude: String?
    var image: Images?
}

struct Images: Codable {
    var small: String?
    var medium: String?
    var large: String?
}

