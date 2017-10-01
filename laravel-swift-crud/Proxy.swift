//
//  Proxy.swift
//  laravel-swift-crud
//
//  Created by Matz Persson on 29/09/2017.
//  Copyright © 2017 Headstation. All rights reserved.
//

import Foundation

class Proxy {
    
    var lastModified: String = ""

    func submit(httpMethod: String, route: String, params: [String: Any], resolve: ((JSON) -> Void )?=nil, reject: ((JSON) -> Void )?=nil) {
        
        // -- Set initial URL
        let urlString: String
        urlString = AppConfig.proxy_server + route

        // -- Set Request
        let request = NSMutableURLRequest(
            url: URL(string: urlString)!,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 5
        )
        
        // -- Set Headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
 
        // -- Set Authentication if token exist
        if (AppConfig.apiToken != nil) {
            request.setValue("Bearer " + AppConfig.apiToken, forHTTPHeaderField: "Authorization")
        }
        
        // -- Set Method
        request.httpMethod = httpMethod
        switch (httpMethod) {
            
            case "POST", "PUT":
                
                // -- Pass parameters in body
                request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            
            case "GET": 
            
                // -- Replace URL and append parameters to query string
                request.url = URL(string: urlString + "?" + joinParams(params: params).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! )
            
            case "DELETE": break;


            default: break;
            
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            
            let httpResponse = response as? HTTPURLResponse

            if (error != nil) {
                
                // -- Server is not responding withing the TimeOutInterval
                //print("ProxyUrl Error: ", error)
                //reject(error)
                
            } else {
                
                DispatchQueue.main.async {
                    
                    // -- Process the JSON response
                    let json = JSON(data: data! as Data)
                    
                    // -- Pass JSON to callbacks
                    if (json["errors"] != nil) {
                        reject!(json)
                    } else {
                        resolve!(json)
                    }
                    
                    
                    
                }
                
            }
            
        }
        dataTask.resume()
        
    }
    
    func joinParams(params: [String: Any] ) -> String {
        
        var out = [String]()
        for (key,value) in params {
            out.append( key + "=" + String(describing: value) )
        }
        
        return out.joined(separator: "&")
        
    }
    
}
