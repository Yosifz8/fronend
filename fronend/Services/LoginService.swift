//
//  LoginService.swift
//  fronend
//
//  Created by Yosi Faroh Zada on 08/05/2023.
//

import Foundation

final class LoginService {
    static let shared = LoginService()
    
    var username: String? = nil
    
    private init() {}
}
