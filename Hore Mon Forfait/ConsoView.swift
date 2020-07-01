//
//  ConsoView.swift
//  Hore Mon Forfait
//
//  Created by Paraita Wohler on 6/29/20.
//  Copyright © 2020 Paraita.io. All rights reserved.
//

import SwiftUI

struct ConsoView: View {
    
    var progressBarColor: Color = Color(#colorLiteral(red: 0.9151532054, green: 0.195348233, blue: 0.3076925874, alpha: 1))
    @ObservedObject var account: Account
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.locale = Locale(identifier: "fr_FR")
        df.dateFormat = "dd MMMM YYYY à HH:mm"
        return df
    }
    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    @State var reloading: Bool = false
    
    var progressBar: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(progressBarColor)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(1.0 - self.account.consoProgress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(progressBarColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.spring(response: 2, dampingFraction: 0.5, blendDuration: 0.5))
            VStack {
                Text(String(format: "%.0f %%", min(1.0 - self.account.consoProgress, 1.0)*100.0))
                    .font(.largeTitle)
                    .bold()
                Text("restant")
                    .font(.headline)
                    .bold()
            }
        }
    }
    
    var connectedBody: some View {
        VStack {
            Text("Ligne \(self.account.numTel)").font(.largeTitle).bold().padding()
            HStack(alignment: .top) {
                progressBar
                    .frame(width: 150.0, height: 150.0)
                    .padding(.horizontal, 20)
                VStack(alignment: .center) {
                    Text(String(format: "Tu as consomé %.1f/%.1f Go", self.account.consumed / 1024.0, self.account.credit / 1024.0))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                    Text(String(format: "Il te reste %.1f Go", self.account.remaining / 1024.0, self.account.credit / 1024.0))
                        .multilineTextAlignment(.center)
                    Button(action: {
                        self.reloading = true
                        let client = APIConsoRequest(msisdn: self.account.numTel, password: self.account.password)
                        client.dispatch(onSuccess: {
                            response in
                            print(response)
                            self.account.nomOffre = response.offre
                            self.account.consumed = response.detail_forfait.internet_mobile_premium.consumed_mo
                            self.account.remaining = response.detail_forfait.internet_mobile_premium.remaining_mo
                            self.account.credit = response.detail_forfait.internet_mobile_premium.credits_mo
                            self.account.updateDate = Date(timeIntervalSince1970: response.update_date)
                            print("nom offre: \(self.account.nomOffre)")
                            print("consumed: \(self.account.consumed)")
                            print("remaining: \(self.account.remaining)")
                            print("credit: \(self.account.credit)")
                            print("updateDate: \(self.account.updateDate)")
                            print("progress: \(self.account.consoProgress)")
                            self.reloading = false
                        }, onFailure: {
                            response, err in
                            print(err)
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
                            .foregroundColor(progressBarColor)
                        }
                    })
                }
            }.padding()
            Text("Abonnement \(self.account.nomOffre)").font(.headline)
            Text("Dernière maj le \(self.dateFormatter.string(from: self.account.updateDate))").italic().multilineTextAlignment(.center).font(.caption)
            Spacer()
        }
    }
    
    var notConnectedBody: some View {
        Text("NOPE")
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
        ConsoView(account: Account(isConnected: true, numTel: "87344266", nomOffre: "Vini Pa Dourmir", consumed: 5569, remaining: 25131, credit: 30700))
    }
}
