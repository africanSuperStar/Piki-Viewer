//
//  AppDelegate.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/30.
//

import UIKit
import CoreData


@main
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    )
    -> Bool
    {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainViewController = MainViewController()
        
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
           
        let container = NSPersistentContainer(name: "Mindera")
        
        container.loadPersistentStores(completionHandler:
        {
            (storeDescription, error) in
                
            if let error = error as NSError?
            {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
        
    // MARK: - Core Data Saving support
        
    func saveContext()
    {
        let context = persistentContainer.viewContext

        if context.hasChanges
        {
            do {
                try context.save()
            }
            catch
            {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

