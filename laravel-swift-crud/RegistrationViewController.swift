//
//  RegistrationViewController.swift
//  laravel-swift-crud
//
//  Created by Matz Persson on 29/09/2017.
//  Copyright © 2017 Headstation. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var errorsLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.white.cgColor
        registerButton.clipsToBounds = true
        registerButton.layer.cornerRadius = 5
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        
    }

    func resolve(json: JSON) {
        
        let data = json.dictionaryObject! as [String: Any]
        
        let user = data["user"] as! [String: Any]
        AppConfig.apiToken = user["api_token"] as! String
        
        performSegue(withIdentifier: "mainSegue", sender: nil)
    }

    func reject(json: JSON) {
        
        let data = json.dictionaryObject! as [String: Any]
        
        self.errorsLabel.alpha = 1
        errorsLabel.text = ""
        
        let errors = data["errors"] as! [String: Any]

        for (key, error) in errors {
            let description = (error as! [String])[0] as String
            errorsLabel.text = errorsLabel.text! + description + " "
        }
        
        UIView.animate(withDuration: 1.0, delay: 3.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.errorsLabel.alpha = 0
        }, completion: nil)
        
        
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        
        let proxy = Proxy()
        
        var params = [
            "name": nameTextField.text!,
            "email": emailTextField.text!,
            "password": passwordTextField.text!,
            "password_confirmation": passwordConfirmTextField.text!
        ]
        
        proxy.submit(httpMethod: "POST", route: "/api/register", params: params, resolve: resolve, reject: reject)
        
    }


    
}
