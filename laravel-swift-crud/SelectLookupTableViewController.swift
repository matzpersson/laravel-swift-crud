//
//  LookupTableViewController.swift
//  laravel-swift-crud
//
//  Created by Matz Persson on 1/10/2017.
//  Copyright © 2017 Headstation. All rights reserved.
//

import UIKit

class SelectLookupTableViewController: UITableViewController {

    var rows: [[String:Any]] = []
    var reuseIdentifier = "cellStandard"
    var fieldName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        load()
        
    }

    func load() {
        
        let proxy = Proxy()
        let route = "/api/lookups/statuses"
        proxy.submit(httpMethod: "GET", route: route, params: [:], resolve: resolve, reject: reject)
        
    }

    // -- Request callback
    func resolve(json: JSON) {
        
        rows = json.arrayObject! as! [[String: Any]]
        tableView.reloadData()
        
    }
    
    func reject(json: JSON) {
        
        print("reject")
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...
        let record = rows[indexPath.row]
        cell.textLabel?.text = record[fieldName] as! String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "unwind", sender: nil)
        
    }
    
}
