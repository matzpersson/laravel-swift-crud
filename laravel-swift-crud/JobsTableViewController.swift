//
//  UsersTableViewController.swift
//  laravel-swift-crud
//
//  Created by Matz Persson on 29/09/2017.
//  Copyright © 2017 Headstation. All rights reserved.
//

import UIKit

class JobsTableViewController: UITableViewController {

    let reuseIdentifier: String = "cellJobs"
    var jobs: [[String: Any]] = []
    
    let proxy = Proxy()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension

        load()
        
    }

    func load() {
        
        let params = [
            "sort": "updated_at|desc"
        ]
            
        proxy.submit(httpMethod: "GET", route: "/api/jobs", params: params, resolve: resolve, reject: reject)
       
    }

    func resolve(json: JSON) {
        
        if (json.arrayObject != nil) {
            jobs = json.arrayObject! as! [[String: Any]]
            tableView.reloadData()
        }


    }
    
    func reject(json: JSON) {
        
        print("reject")
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! JobsTableViewCell

        // Configure the cell...

        let record = jobs[indexPath.row]
        cell.nameLabel.text = record["name"] as! String?
        cell.descriptionLabel.text = record["description"] as! String?
        
        let progress = record["progress"] as! Int
        let progressText = String( describing: progress )
        cell.progressLabel.text = progressText + "%"
        
        cell.updatedLabel.text =  record["updated_at"] as! String?
        
        
        if let status = record["status"] as? [String: Any] {
            cell.statusLabel.text = status["name"] as! String
        } else {
            cell.statusLabel.text = "None"
        }
        
        
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dc = segue.destination as! JobTableViewController
        
        switch (segue.identifier) {
            
            case "editSegue"?:
            
                let indexPath = tableView.indexPathForSelectedRow
                let job = jobs[(indexPath?.row)!]
                dc.job = job
            
            case "addSegue"?: break;
            
            default: break;
            
        }
    }
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {

        // -- Null token on Server
        proxy.submit(httpMethod: "POST", route: "/api/logout", params: [:], resolve: resolve, reject: reject)

        // -- Null token locally
        AppConfig.apiToken = nil
        
        // -- Return to Login
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToJobs(segue: UIStoryboardSegue) {
        
        load()
        
    }
    

}
