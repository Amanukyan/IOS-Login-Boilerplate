//
//  ApiClient.swift
//  Login
//
//  Created by Alex Manukyan on 4/3/19.
//  Copyright © 2019 Alex Manukyan. All rights reserved.
//

import Foundation


class ApiClient {
    
    static var shared = ApiClient()
    
    func perfomRequest(endPoint: EndPoint, completion: @escaping (Result<Any, Error>)->()) {
        let urlRequest = buildRequest(from: endPoint)
        
        if urlRequest == nil {
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest!) { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                print("JSON:", json)
                completion(.success(json))
            } catch let error {
                print("ERROR:", error.localizedDescription)
                completion(.failure(error))
            }
            }.resume()
    }
    fileprivate func buildRequest(from route: EndPoint) -> URLRequest? {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.method.rawValue
        do {
            switch route.task {
            case .requestParameters(let parameters, let encoding):
                try self.configureParameters(parameters: parameters, encoding: encoding, request: &request)
            case .requestPlain:
                return request
            }
            return request
        } catch let error {
            print("Error:", error)
            return nil
        }
    }
    
    fileprivate func configureParameters(parameters: Parameters?, encoding: ParameterEncoding, request: inout URLRequest) throws {
        do {
            try encoding.encode(urlRequest: &request, parameters: parameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    
}


extension ApiClient {
    
    
    func register(username:String, password: String, completion: @escaping (Result<[String: Any],Error>)->()){

        let registerEndpoint = UserApi.register(username: username, password: password)
        perfomRequest(endPoint: registerEndpoint) { (result) in
            switch result {
            case .success:
                self.login(username: username, password: password, completion: completion)
            case .failure(let error):
                print("Error: ", error)
            }
        }
        
        return;
    }
    
    
    func login(username:String, password: String, completion: @escaping (Result<[String: Any],Error>)->()){
        
        let endpoint = AuthApi.login(username: username, password: password)
        perfomRequest(endPoint: endpoint) { (result) in
            switch result {
            case .success(let json):
                print("")
                completion(.success(json as! [String: Any]))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

extension ApiClient{
    
    
    func dummy(username:String, password: String, completion: @escaping (Result<[String: Any],Error>)->()){
        
        // URL
        let urlString = "http://192.168.50.198:3000/api/auth/login"
        let url = URL(string: urlString)!
        
        // URL Request
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.httpMethod = "POST"
        let parameters = [
            "username": username,
            "password": password
        ]
        
        // Encoding
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }catch {
            
        }
        
        RequestLogger.log(request: urlRequest)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                print("JSON:", json)
                completion(.success(json))
            } catch {
                print("ERROR:", error.localizedDescription)
                completion(.failure(error))
            }
            }.resume()
        
    }
    
}
