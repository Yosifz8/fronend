//
//  PostUpload.swift
//  fronend
//
//  Created by Yosi Faroh Zada on 08/05/2023.
//

import Foundation

struct PostUpload: Codable {
    let username: String
    let title: String
    let description: String
    let longitude: Double?
    let latitude: Double?
    let image: String
}

struct PostEdit: Codable {
    let id: String
    let username: String
    let title: String
    let description: String
    let longitude: Double?
    let latitude: Double?
}
