//
//  AppDelegate.swift
//  SpotifyRecommender
//
//  Created by 90303054 on 4/26/20.
//  Copyright © 2020 90303054. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    lazy var rootViewController = ViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        rootViewController.sessionManager.application(app, open: url, options: options)
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    
    
    
}

