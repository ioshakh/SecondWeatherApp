//
//  AppDelegate.swift
//  SecondWeatherApp
//
//  Created by Shakhzod Bektemirov on 2022/02/19.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setUpView()
        return true
    }
    
    private func setUpView() {
        let cv = HomeViewController()
        let nv = UINavigationController(rootViewController:cv)
        self.window = UIWindow(frame:UIScreen.main.bounds)
        self.window?.rootViewController = nv
        self.window?.makeKeyAndVisible()
    }
}

