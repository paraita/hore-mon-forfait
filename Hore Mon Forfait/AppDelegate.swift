//
//  AppDelegate.swift
//  Hore Mon Forfait
//
//  Created by Paraita Wohler on 6/23/20.
//  Copyright © 2020 Paraita.io. All rights reserved.
//

import UIKit
import BackgroundTasks
import os
//import Intents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //INPreferences.requestSiriAuthorization({status in
        //    print("demande de permission pour Siri: \(status)")
        //})
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "io.paraita.hore.background-refresh", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(scheduleAppRefresh), name: UIScene.didEnterBackgroundNotification, object: nil)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: App Refresh
    
    @objc func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "io.paraita.hore.background-refresh")
        // refresh every 30mins
        request.earliestBeginDate = Date(timeIntervalSinceNow: 30 * 60)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        
        let account = Account.sharedInstance
        let client = APIConsoRequest(msisdn: account.numTel, password: account.password)
        
        task.expirationHandler = {
            os_log("expiration handler triggered", type: .debug)
        }
        
        if account.isConnected {
            scheduleAppRefresh()
            client.dispatch(onSuccess: {
                response in
                os_log("background refresh successful", type: .debug)
                account.update(with: response)
                task.setTaskCompleted(success: true)
            }, onFailure: {
                response, err in
                os_log("background refresh failed: %@", type: .debug, err.localizedDescription)
                task.setTaskCompleted(success: false)
            })
        }
        else {
            task.setTaskCompleted(success: true)
        }
    }
}
