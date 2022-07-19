//
//  GoogleImageAPI.swift
//  ImageUIKit
//
//  Created by Влад on 11.07.2022.
//

import Foundation


protocol GoogleImageAPISerciceProtocol {
    
    func getImages(searchString: String, sizeParameter: SizeButton, languageParameter: String, countryParameter: String, complection: @escaping(_ success:Bool,_ result: MainView.Images?, _ error: String?) -> ())
}


class GoogleImageAPIService: GoogleImageAPISerciceProtocol {
    
    var parameters: [String: String] =  ["q" : "",
                                         "tbm" : "isch",
                                         "api_key" : "here your",
                                         "ijn" : "0"]
    
    func getImages(searchString: String, sizeParameter: SizeButton, languageParameter: String, countryParameter: String, complection: @escaping (Bool, MainView.Images?, String?) -> ()) {
        parameters.updateValue(searchString, forKey: "q")
        
        switch sizeParameter {
        case .Large:  parameters["tbs"] = "l"
        case .Medium: parameters["tbs"] = "m"
        case .Icon:  parameters["tbs"] = "i"
        case .NoSelection: break
        }
        
        switch languageParameter {
        case "No Selection": break
        case "Russian": parameters["hl"] = "ru"
        case "English": parameters["hl"] = "en"
        case "German": parameters["hl"] = "de"
        case "Portuguese": parameters["hl"] = "pt"
        case "Indonesian": parameters["hl"] = "id"
        case "Japanese": parameters["hl"] = "ja"
        case "Spanish": parameters["hl"] = "es"
        default: break
        }
        
        switch countryParameter {
        case "No Selection": break
        case "Russia": parameters["gl"] = "ru"
        case "United States": parameters["gl"] = "us"
        case "Germany": parameters["gl"] = "de"
        case "Brazil": parameters["gl"] = "br"
        case "Indonesia": parameters["gl"] = "id"
        case "Japan": parameters["gl"] = "jp"
        case "Mexico": parameters["gl"] = "mx"
        default: break
        }
        
        HttpRequest().GET(url: "https://serpapi.com/search.json", params: parameters, httpHeader: .application_json) { success, data in
            if success {
                do {
                    let model = try JSONDecoder().decode(MainView.Images.self, from: data!)
                    complection(true, model, nil)
                } catch {
                    complection(false, nil, "Error parse Images from API")
                    print(error)
                }
            } else {
                complection(false, nil, "Error GET request")
            }
        }
    }
}
