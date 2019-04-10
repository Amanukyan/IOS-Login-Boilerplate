//
//  EndPoint.swift
//  Login
//
//  Created by Alex Manukyan on 4/6/19.
//  Copyright © 2019 Alex Manukyan. All rights reserved.
//

import Foundation

protocol EndPoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}


public enum UserApi {
    case register(username: String, password: String)
}

extension UserApi: EndPoint {
    
    
    var baseURL: URL { return URL(string: "http://192.168.50.198:3000/api/auth")! }
    
    var path: String {
        switch self {
        case .register:
            return "register"
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var task: HTTPTask {
        return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
    }
    
    var headers: HTTPHeaders? {
        let assigned: [String: String] = [
            "Accept": "application/json",
            "Content-Type": "application/json",
        ]
        return assigned
    }
    
    var parameters: Parameters? {
        switch self {
            
        case .register(let username, let password):
            return [
                "username": username,
                "password": password
            ]
        }
        
    }
    var parameterEncoding: ParameterEncoding {
        if method == .get {
            return .urlEncoding
        }
        else {
            return .jsonEncoding
        }
    }
}





public enum AuthApi {
    case login(username: String, password: String)
}

extension AuthApi: EndPoint {
    
    
    var baseURL: URL { return URL(string: "http://192.168.50.198:3000/api/auth")! }
    
    var path: String {
        switch self {
        case .login:
            return "login"
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var task: HTTPTask {
        return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
    }
    
    var headers: HTTPHeaders? {
        let assigned: [String: String] = [
            "Accept": "application/json",
            "Content-Type": "application/json",
        ]
        return assigned
    }
    
    var parameters: Parameters? {
        switch self {
            
        case .login(let username, let password):
            return [
                "username": username,
                "password": password
            ]
        }
        
    }
    var parameterEncoding: ParameterEncoding {
        if method == .get {
            return .urlEncoding
        }
        else {
            return .jsonEncoding
        }
    }
}

