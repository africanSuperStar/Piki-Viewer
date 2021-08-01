//
//  AppDelegate.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/30.
//

import UIKit
import CoreData
import Mixpanel

@main
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var persistence = CoreDataManager()
    
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    )
    -> Bool
    {
        Mixpanel.initialize(token: "73e8a85e493cf65dfccd39b30c5ed019")
        
        persistence.saveContext()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainViewController = MainViewController()
        
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

