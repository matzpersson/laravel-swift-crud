//
//  UserTableViewController.swift
//  laravel-swift-crud
//
//  Created by Matz Persson on 29/09/2017.
//  Copyright © 2017 Headstation. All rights reserved.
//

import UIKit

class JobTableViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var progresSlider: UISlider!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var deleteButton: UIBarButtonItem!

    var job: [String: Any] = [:]
    var statusId: Int! = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        load()
        
    }

    func load() {
        
        // -- If existing job then ... else new record
        if ((job["id"]) != nil) {
            
            nameTextField.text = job["name"] as! String
            descriptionTextView.text = job["description"] as! String
            
            progresSlider.setValue(job["progress"] as! Float, animated: true)
            setProgress()
            
            if let status = job["status"] as? [String: Any] {
                statusLabel.text = status["name"] as! String
            } else {
                statusLabel.text = "None"
            }
            
        } else {
            
            // -- Disable delete button
            deleteButton.isEnabled = false
            
        }
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    // -- Request callbacks
    func resolve(json: JSON) {
        
        performSegue(withIdentifier: "unwind", sender: nil)
        
    }
    
    func reject(json: JSON) {
        
        print("reject")
        
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
   
        let proxy = Proxy()
        
        //  -- Set Parameters
        let params = [
            "name": nameTextField.text!,
            "description":descriptionTextView.text!,
            "progress":progresSlider.value,
            "status_id":statusId
        ] as [String : Any]
        
        // -- If job is new then POST else PUT
        if ((job["id"]) == nil) {
            
            proxy.submit(httpMethod: "POST", route: "/api/jobs", params: params, resolve: resolve, reject: reject)
            
        } else {
            
            let id = job["id"] as! Int
            let route = "/api/jobs/" + String(describing: id)
            proxy.submit(httpMethod: "PUT", route: route, params: params, resolve: resolve, reject: reject)
            
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch (segue.identifier) {
            
            case "lookupStatusSegue"?:
            
                let dc = segue.destination as! SelectLookupTableViewController
                dc.fieldName = "name"
            
            default: break
            
        }
    }
    
    func setProgress() {
        
        let progress = Int(progresSlider.value)
        let progressText = String( describing: progress )
        progressLabel.text = "Progress (" + progressText + "%)"
        
        if progresSlider.value == 100 {
            progresSlider.tintColor = UIColor.green
        } else {
            progresSlider.tintColor = UIColor(netHex: 0x007AFF)
        }
    }
    
    func deleteJob(alert: UIAlertAction!) {
        
        let proxy = Proxy()
        
        // -- Append the id to the DELETE request
        let id = job["id"] as! Int
        let route = "/api/jobs/" + String(describing: id)
        proxy.submit(httpMethod: "DELETE", route: route, params: [:], resolve: resolve, reject: reject)
        
    }
    
    @IBAction func deleteButton(_ sender: UIBarButtonItem) {
 
        let alert = UIAlertController(title: "Permanently remove this Job. Continue?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yup, nuke it!", style: UIAlertActionStyle.default, handler: deleteJob ))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil ))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func progressSlider(_ sender: UISlider) {
        
        setProgress()
        
    }
    
    @IBAction func unwindToJob(segue: UIStoryboardSegue) {
        
        if let sourceViewController = segue.source as? SelectLookupTableViewController {
            
            let lookupIndexPath = sourceViewController.tableView.indexPathForSelectedRow
            let selected = sourceViewController.rows[(lookupIndexPath?.row)!]
            
            // -- Set Status
            statusId = selected["id"] as! Int!
            statusLabel.text = (selected["name"]) as! String
            
            if (selected["tag"]) as! String == "done" {
                
                progresSlider.setValue(100, animated: true)
                setProgress()
                
            }
        }
        
    }
}
