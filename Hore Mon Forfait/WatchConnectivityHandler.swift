//
//  File.swift
//  Hore Mon Forfait
//
//  Created by Paraita Wohler on 7/2/20.
//  Copyright © 2020 Paraita.io. All rights reserved.
//

import Foundation
import WatchConnectivity
import Combine
import os


class WatchConnectivityHandler: NSObject, WCSessionDelegate {
    
    private let session: WCSession

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
    }
    
    func sendStuffToTheWatch(_ account: Account) {
        os_log("Sending data to the watch...")
        if WCSession.isSupported() {
            self.session.activate()
            
            DispatchQueue.main.async {
                if self.session.isPaired && self.session.isWatchAppInstalled {
                    do {
                        let jsonPayload = try! JSONEncoder().encode(account)
                        //let jsonString = String(data: jsonPayload, encoding: .utf8)
                        try self.session.updateApplicationContext(["account": jsonPayload])
                    } catch let error as NSError {
                        os_log("error while fetching data from Vini: %@", type: .error, error.description)
                    }
                }
                else {
                    os_log("cancelled (no paired watch session)")
                }
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        os_log("activation did complete")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        os_log("session became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        os_log("session deactivated")
    }
    
    
    
    
    
    
}
