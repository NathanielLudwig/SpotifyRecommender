//
//  ViewController.swift
//  SpotifyRecommender
//
//  Created by 90303054 on 4/26/20.
//  Copyright © 2020 90303054. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SPTSessionManagerDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    
    private let SpotifyClientID = "6fbaa216180b4898872744e61e14df49"
    private let SpotifyRedirectURL = URL(string: "spotifyrecommender://spotify-login-callback")!
    
    lazy var configuration = SPTConfiguration(
      clientID: SpotifyClientID,
      redirectURL: SpotifyRedirectURL
    )
    
    lazy var sessionManager: SPTSessionManager = {
      if let tokenSwapURL = URL(string: "https://spotifyrecommender.herokuapp.com/api/token"),
         let tokenRefreshURL = URL(string: "https://spotifyrecommender.herokuapp.com/api/refresh_token") {
        self.configuration.tokenSwapURL = tokenSwapURL
        self.configuration.tokenRefreshURL = tokenRefreshURL
        self.configuration.playURI = ""
      }
      let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
      return manager
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let scope: SPTScope = [.playlistReadPrivate]
        sessionManager.initiateSession(with: scope, options: .default)
    }
    
    // MARK: - SPTSessionManagerDelegate
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("session connected")
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("session connect failed", error)
    }
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("session renewed")
    }
    
    
}


