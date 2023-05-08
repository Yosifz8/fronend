//
//  Post.swift
//  fronend
//
//  Created by Yosi Faroh Zada on 07/05/2023.
//

import Foundation

struct Post: Codable {
    let id: String
    let username: String
    let title: String
    let description: String
    let longitude: Double?
    let latitude: Double?
    let imgUrl: String
}
