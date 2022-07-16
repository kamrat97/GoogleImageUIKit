//
//  HTTPRequest.swift
//  ImageUIKit
//
//  Created by Влад on 11.07.2022.
//

import Foundation


enum HTTPHeaderField {
    case application_json
    case application_x_www_form_urlencoded
    case none
}

class HttpRequest {
    
    func GET(url: String, params: [String: String], httpHeader: HTTPHeaderField, complete: @escaping(Bool, Data?) -> ()){
        guard var components = URLComponents(string: url) else {
            print("Error create components")
            return
        }
        
        components.queryItems = params.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        guard let url = components.url else {
            print("Error create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        switch httpHeader {
        case .application_json:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .application_x_www_form_urlencoded:
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        case .none: break
        }
        
        
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error GET: \(error!)")
                complete(false, nil)
                return
            }
            guard let data = data else {
                print("Error recive data")
                complete(false, nil)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode  else {
                print("Error HTTP request")
                complete(false, nil)
                return
            }
            complete(true, data)
        }.resume()
    }
    
}
