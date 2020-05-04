//
//  AppDelegate.swift
//  SpotifyRecommender
//
//  Created by 90303054 on 4/26/20.
//  Copyright © 2020 90303054. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SPTSessionManagerDelegate {
    
    var window: UIWindow?
    lazy var rootViewController = LoginViewController()
    
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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(createSession), name: NSNotification.Name(rawValue: "loginButtonPressed"), object: nil)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        self.sessionManager.application(app, open: url, options: options)
        
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    @objc func createSession(){
        let scope: SPTScope = [.playlistReadPrivate]
        sessionManager.initiateSession(with: scope, options: .default)
    }
    // MARK: - SPTSessionManagerDelegate
       func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
           print("session connected")
           NotificationCenter.default.post(name: Notification.Name("sessionConnected"), object: nil)
       }
       
       func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
           print("session connect failed", error)
       }
       func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
           print("session renewed")
       }
    
    
    
}

