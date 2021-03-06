//
//  WatchView.swift
//  Hore Extension
//
//  Created by Paraita Wohler on 7/1/20.
//  Copyright © 2020 Paraita.io. All rights reserved.
//

import SwiftUI
import Combine
import os

struct WatchView: View {
    
    var dateFormatter: HMFDateFormatter = HMFDateFormatter()
    @ObservedObject var account: Account
    var client: APIConsoRequest {
        return APIConsoRequest(msisdn: self.account.numTel, password: self.account.password)
    }
    
    var body: some View {
        realBody
    }
    
    var realBody: some View {
        ScrollView {
            VStack {
                Text("Ligne \(account.numTel)").bold()
                HMFProgressCircle(lineWidth: 15.0, progressValue: account.consoProgress)
                    .frame(width: 120, height: 120)
                    .padding()
                Spacer()
                Divider()
                VStack(alignment: .leading) {
                    Text(String(format: "Tu as consommé %.1f Go", account.consumed / 1024.0))
                    Text(String(format: "Il te reste %.1f Go", account.remaining / 1024.0))
                }
                Divider()
                Text("Dernière maj le \(dateFormatter.string(from: account.updateDate))")
                    .font(.footnote).italic().multilineTextAlignment(.center)
            }
        }
        .onAppear {
            self.client.dispatch(onSuccess: {
                response in
                os_log("fetched data successfully", type: .debug)
                self.account.update(with: response)
                let CLKServer = CLKComplicationServer.sharedInstance()
                for complication in CLKServer.activeComplications ?? [] {
                    CLKServer.reloadTimeline(for: complication)
                }
            }, onFailure: {
                response, err in
                os_log("error fetching info: %@", type: .debug, err.localizedDescription)
            })
        }
    }
    
    var demoBody: some View {
        ScrollView {
            VStack {
                Text("Ligne 87123456").bold()
                HMFProgressCircle(lineWidth: 15.0, progressValue: 0.10)
                    .frame(width: 120, height: 120)
                    .padding()
                Spacer()
                Divider()
                VStack(alignment: .leading) {
                    Text("Tu as consommé 1.0 Go")
                    Text("Il te reste 9.0 Go")
                }
                Divider()
                Text("Dernière maj le \(dateFormatter.string(from: account.updateDate))")
                    .font(.footnote).italic().multilineTextAlignment(.center)
            }
        }
        .onAppear {
            self.client.dispatch(onSuccess: {
                response in
                os_log("fetched data successfully", type: .debug)
                self.account.update(with: response)
                let CLKServer = CLKComplicationServer.sharedInstance()
                for complication in CLKServer.activeComplications ?? [] {
                    CLKServer.reloadTimeline(for: complication)
                }
            }, onFailure: {
                response, err in
                os_log("error fetching info: %@", type: .debug, err.localizedDescription)
            })
        }
    }
}

struct WatchView_Previews: PreviewProvider {
    static var previews: some View {
        WatchView(account: Account(isConnected: true, numTel: "12345678", nomOffre: "Offre téléphone", consumed: 30500, remaining: 200, credit: 30700))
    }
}
