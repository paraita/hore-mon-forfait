//
//  ExtensionDelegate.swift
//  Hore Extension
//
//  Created by Paraita Wohler on 6/30/20.
//  Copyright © 2020 Paraita.io. All rights reserved.
//

import WatchKit
import os

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }
    
    func reloadComplications() {
        let CLKServer = CLKComplicationServer.sharedInstance()
        for complication in CLKServer.activeComplications ?? [] {
            CLKServer.reloadTimeline(for: complication)
        }
    }
    
    func scheduleBackgroundRefreshTasks() {
        os_log("scheduling a background refresh !")
        let watchExtension = WKExtension.shared()
        let targetDate = Date().addingTimeInterval(15.0 * 60.0)
        watchExtension.scheduleBackgroundRefresh(withPreferredDate: targetDate, userInfo: nil) { (error) in
            
            // Check for errors.
            if let error = error {
                print("*** An background refresh error occurred: \(error.localizedDescription) ***")
                return
            }
            
            print("*** Background Task Completed Successfully! ***")
        }
    }
    
    func applicationDidEnterBackground() {
        os_log("applicationDidEnterBackground !")
        scheduleBackgroundRefreshTasks()
    }

    func applicationDidBecomeActive() {
        let account = Account.sharedInstance
        let client = APIConsoRequest(msisdn: account.numTel, password: account.password)
        client.dispatch(onSuccess: {
            response in
            os_log("fetch vini depuis la watch réussi (applicationDidBecomeActive)")
            print(response)
            account.update(with: response)
            //account.consumed = Double.random(in: 0...10000)
            //account.credit = 10000
            //account.remaining = account.credit - account.consumed
            print("applicationDidBecomeActive")
            print("consumed: \(account.consumed)")
            print("consoProgress: \(account.consoProgress)")
            print("restant: \(1.0 - account.consoProgress)")
            NotificationCenter.default.post(name:NSNotification.Name("update-ta-race"), object: nil)
        }, onFailure: {
            response, err in
            os_log("erreur lors du fetch (applicationDidBecomeActive)")
            print(err)
        })
        
        
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        os_log("background handle time !")
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                os_log("on est sur la bonne background task !")
                // Be sure to complete the background task once you’re done.
                let account = Account.sharedInstance
                let client = APIConsoRequest(msisdn: account.numTel, password: account.password)
                client.dispatch(onSuccess: {
                    response in
                    os_log("fetch vini depuis la watch réussi (scheduleBackgroundRefreshTasks)")
                    print(response)
                    account.update(with: response)
                    //account.consumed = Double.random(in: 0...10000)
                    //account.credit = 10000
                    //account.remaining = account.credit - account.consumed
                    print("scheduleBackgroundRefreshTasks")
                    print("consumed: \(account.consumed)")
                    print("consoProgress: \(account.consoProgress)")
                    print("restant: \(1.0 - account.consoProgress)")
                    self.reloadComplications()
                    self.scheduleBackgroundRefreshTasks()
                    backgroundTask.setTaskCompletedWithSnapshot(true)
                    
                }, onFailure: {
                    response, err in
                    os_log("erreur lors du fetch (scheduleBackgroundRefreshTasks)")
                    print(err)
                    self.scheduleBackgroundRefreshTasks()
                    backgroundTask.setTaskCompletedWithSnapshot(false)
                })
                
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                os_log("snapshotTask")
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                os_log("connectivityTask")
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                os_log("urlSessionTask")
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                os_log("relevantShortcutTask")
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                os_log("intentDidRunTask")
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                os_log("defaultTask")
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }

}
