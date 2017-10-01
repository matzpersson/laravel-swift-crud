//
//  Config.swift
//  laravel-swift-crud
//
//  Created by Matz Persson on 29/09/2017.
//  Copyright © 2017 Headstation. All rights reserved.
//

import UIKit

struct AppConfig {
    
    // -- Configure your Lavarel REST Api server
    static var proxy_server = "http://172.16.1.17:8000"
    
    // -- This token is past with every url request in Proxy once the session has been authenticated. 
    // -- This could also be set persistent using UserDefaults instead of a global variable
    static var apiToken: String!
    
}
