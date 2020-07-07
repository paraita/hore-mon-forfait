//
//  HostingController.swift
//  Hore Extension
//
//  Created by Paraita Wohler on 6/30/20.
//  Copyright © 2020 Paraita.io. All rights reserved.
//

import WatchKit
import WatchConnectivity
import SwiftUI
import Combine
import os

class HostingController: WKHostingController<WatchView>, WCSessionDelegate {
    
    @ObservedObject var account: Account = Account()
    
    override var body: WatchView {
        return WatchView(account: account)
    }
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            print("WCSession supported")
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(notifyForRefresh), name: NSNotification.Name("update"), object: nil)
    }
    
    @objc func notifyForRefresh() {
        print("NOTIFIED !!!")
        print("consumed: \(account.consumed)")
        print("consoProgress: \(account.consoProgress)")
        self.setNeedsBodyUpdate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationState: \(activationState)")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        os_log("reception des infos du telephone")
        let data = applicationContext["account"] as! Data
        let account = try! JSONDecoder().decode(Account.self, from: data)
        DispatchQueue.main.async {
            print("recu numTel: \(account.numTel)")
            print("recu password: \(account.password)")
            print("self numTel: \(self.account.numTel)")
            print("self password: \(self.account.password)")
            self.account.numTel = account.numTel
            self.account.password = account.password
            self.account.consumed = account.consumed
            self.account.isConnected = account.isConnected
            self.account.credit = account.credit
            self.account.remaining = account.remaining
            self.account.updateDate = account.updateDate
            self.setNeedsBodyUpdate()
            print("apres les modifs sur la montre")
            print("self numTel: \(self.account.numTel)")
            print("self password: \(self.account.password)")
        }
    }
}

struct HostingController_Previews: PreviewProvider {
    static var previews: some View {
        WatchView(account: Account(isConnected: true, numTel: "12345678", nomOffre: "Vini Pa Dourmir", consumed: 5569, remaining: 25131, credit: 30700))
    }
}
