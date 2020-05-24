//
//  ViewController.swift
//  SpotifyRecommender
//
//  Created by 90303054 on 4/26/20.
//  Copyright © 2020 90303054. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(segueFromLogin), name: NSNotification.Name(rawValue: "sessionConnected"), object: nil)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @objc func segueFromLogin(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "homeSegue", sender: self)
        }
        
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        loginButton.isHidden = true
        spinner.startAnimating()
        NotificationCenter.default.post(name: Notification.Name("loginButtonPressed"), object: nil)
    }
    
   
    
    
}


