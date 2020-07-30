//
//  ConsoView.swift
//  Hore Mon Forfait
//
//  Created by Paraita Wohler on 6/29/20.
//  Copyright © 2020 Paraita.io. All rights reserved.
//

import SwiftUI
import Combine
import os

struct ConsoView: View {
    
    // MARK: ---------- states ----------
    
    var progressBarColor: Color = Color(#colorLiteral(red: 0.7260068059, green: 0.1090376303, blue: 0.09677212685, alpha: 1))
    @State var account: Account
    var dateFormatter: HMFDateFormatter = HMFDateFormatter()
    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    @State var reloading: Bool = false
    var watchConnectivityHandler: WatchConnectivityHandler = WatchConnectivityHandler()
    var client: APIConsoRequest {
        return APIConsoRequest(msisdn: self.account.numTel, password: self.account.password)
    }
    
    // MARK: ---------- views ----------
    
    var connectedBody: some View {
        GeometryReader { proxy in
            VStack {
                Text("Ligne \(self.account.numTel)")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                Text("Dernière maj le \(self.dateFormatter.string(from: self.account.updateDate))")
                    .italic()
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .padding(.bottom)
                HMFProgressCircle(progressValue: self.account.consoProgress)
                    .frame(width: 150.0, height: 150.0)
                    .padding(.horizontal, 20)
                    .padding(.bottom)
                    .multilineTextAlignment(.center).padding(.bottom, 10)
                Text(String(format: "Tu as consommé %.1f/%.1f Go", self.account.consumed / 1024.0, self.account.credit / 1024.0))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                Text(String(format: "Il te reste %.1f Go", self.account.remaining / 1024.0, self.account.credit / 1024.0))
                    .multilineTextAlignment(.center)
                Button(action: {
                    self.reloading = true
                    self.client.dispatch(onSuccess: {
                        response in
                        self.account.update(with: response)
                        //self.account.consumed = Double.random(in: 0...10000)
                        //self.account.credit = 10000
                        //self.account.remaining = self.account.credit - self.account.consumed
                        self.watchConnectivityHandler.sendStuffToTheWatch(self.account)
                        self.reloading = false
                    }, onFailure: { response, err in
                        os_log("error fetching info: %@", type: .debug, err.localizedDescription)
                        self.reloading = false
                    })
                }, label: {
                    if self.reloading {
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                    }
                    else {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(self.progressBarColor)
                    }
                })
                Spacer()
                AdBanner(width: proxy.size.width, height: proxy.size.width / 6.4)
            }.onAppear {
                self.client.dispatch(onSuccess: {
                    response in
                    self.account.update(with: response)
                    // mock
                    //self.account.consumed = Double.random(in: 0...10000)
                    //self.account.credit = 10000
                    //self.account.remaining = self.account.credit - self.account.consumed
                    self.watchConnectivityHandler.sendStuffToTheWatch(self.account)
                    self.reloading = false
                }, onFailure: {
                response, err in
                    os_log("error fetching info: %@", type: .debug, err.localizedDescription)
                    self.reloading = false
                })
            }
        }
    }
    
    var demoConnectedBody: some View {
        GeometryReader { proxy in
            VStack {
                Text("Ligne 87123456")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                Text("Dernière maj le \(self.dateFormatter.string(from: self.account.updateDate))")
                    .italic()
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .padding(.bottom)
                HMFProgressCircle(progressValue: self.account.consoProgress)
                    .frame(width: 150.0, height: 150.0)
                    .padding(.horizontal, 20)
                    .padding(.bottom)
                Text(String(format: "Tu as consommé 1.0/10.0 Go"))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                Text(String(format: "Il te reste 9.0 Go"))
                    .multilineTextAlignment(.center)
                Button(action: {
                    self.reloading = true
                    self.client.dispatch(onSuccess: {
                        response in
                        self.account.update(with: response)
                        //self.account.consumed = Double.random(in: 0...10000)
                        //self.account.credit = 10000
                        //self.account.remaining = self.account.credit - self.account.consumed
                        self.watchConnectivityHandler.sendStuffToTheWatch(self.account)
                        self.reloading = false
                    }, onFailure: { response, err in
                        os_log("error fetching info: %@", type: .debug, err.localizedDescription)
                        self.reloading = false
                    })
                }, label: {
                    if self.reloading {
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                    }
                    else {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(self.progressBarColor)
                    }
                })
                Spacer()
                //AdBanner(width: proxy.size.width, height: proxy.size.width / 6.4)
                }.onAppear {
                self.client.dispatch(onSuccess: {
                    response in
                    self.account.update(with: response)
                    // mock
                    //self.account.consumed = Double.random(in: 0...10000)
                    //self.account.credit = 10000
                    //self.account.remaining = self.account.credit - self.account.consumed
                    self.watchConnectivityHandler.sendStuffToTheWatch(self.account)
                    self.reloading = false
                }, onFailure: {
                response, err in
                    os_log("error fetching info: %@", type: .debug, err.localizedDescription)
                    self.reloading = false
                })
            }
        }
    }
    
    var notConnectedBody: some View {
        GeometryReader { proxy in
            
            VStack {
                VStack(alignment: .center) {
                    Text("Ia'orana dans Hore Mon Forfait, l'app pour surveiller ton forfait !").font(.title).multilineTextAlignment(.center)
                    Spacer()
                    Text("Attention ! Cette app ne fonctionnera qu'avec un numéro en 87 et un abonnement Data !").font(.subheadline).multilineTextAlignment(.center)
                    Spacer()
                    Text("Connectes-toi pour voir l'état de ton forfait !").font(.subheadline).multilineTextAlignment(.center)
                    
                }.padding()
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "arrowshape.turn.up.right.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .rotationEffect(.init(degrees: 90))
                        .padding(.trailing, proxy.size.width - proxy.size.width * 0.81)
                        .padding(.bottom, 20)
                        .foregroundColor(self.progressBarColor)
                        .shadow(radius: 5)
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            if self.account.isConnected {
                connectedBody
            }
            else {
                notConnectedBody
            }
        }
    }
}

struct ConsoView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            
            ConsoView(account: Account(isConnected: false, numTel: "12345678", nomOffre: "Offre téléphone", consumed: 5569, remaining: 25131, credit: 30700))
                .previewDevice("iPhone 11 Pro Max")
            
            ConsoView(account: Account(isConnected: false, numTel: "12345678", nomOffre: "Offre téléphone", consumed: 5569, remaining: 25131, credit: 30700))
                .previewDevice("iPhone SE (2nd generation)")
            
            ConsoView(account: Account(isConnected: true, numTel: "12345678", nomOffre: "Offre téléphone", consumed: 5569, remaining: 25131, credit: 30700))
                .previewDevice("iPhone 11 Pro Max")
            
            ConsoView(account: Account(isConnected: true, numTel: "12345678", nomOffre: "Offre téléphone", consumed: 5569, remaining: 25131, credit: 30700))
                .previewDevice("iPhone SE (2nd generation)")
        }
    }
}
