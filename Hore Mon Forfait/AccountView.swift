//
//  AccountView.swift
//  Hore Mon Forfait
//
//  Created by Paraita Wohler on 6/23/20.
//  Copyright © 2020 Paraita.io. All rights reserved.
//

import SwiftUI

struct AccountView: View {
    
    public enum AccountStatus {
        case configured, notConfigured, connecting
    }
    
    @ObservedObject var account: Account
    @State var isConnecting: Bool = false
    var colorText: Color = Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
    var colorBannerBackground: Color = Color(#colorLiteral(red: 0.9993683696, green: 0.230212003, blue: 0.1864413619, alpha: 1))
    var colorBannerForeground: Color = Color(#colorLiteral(red: 0.6817478538, green: 0.1464989185, blue: 0.1279250383, alpha: 1))
    var colorButtonBackground: Color = Color(#colorLiteral(red: 0.9151532054, green: 0.195348233, blue: 0.3076925874, alpha: 1))
    var colorButtonForeground: Color = Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
    
    var colorButtonNotConnected: Color = Color(#colorLiteral(red: 0.9151532054, green: 0.195348233, blue: 0.3076925874, alpha: 1))
    var colorButtonConnecting: Color = Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
    var colorButtonConnected: Color = Color(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1))
    
    var login: (()->()) = {
        print("TITOI")
        
    }
    
    var backBanner: some View {
        Text("HORE MON FORFAIT  HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT  HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT  HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT  HORE MON FORFAIT  HORE MON FORFAIT  HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT  HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT  HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT  HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT  HORE MON FORFAIT HORE MON FORFAIT  HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT  HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT FORFAIT HORE MON FORFAIT  HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT  FORFAIT HORE MON FORFAIT  HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT FORFAIT HORE MON FORFAIT  HORE MON FORFAIT HORE MON FORFAIT HORE MON FORFAIT")
            .foregroundColor(colorBannerForeground)
            .shadow(color: colorBannerBackground, radius: 1, x: 1, y: 1)
            .background(Color.red)
            .rotationEffect(.degrees(-20))
            .frame(width: 600, height: 400)
            .padding(.top, -100)
            .padding(.bottom, -70)
            .clipped()
    }
    
    var profilePic: some View {
        Image("profil-pic")
            .resizable()
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
    }
    
    var body: some View {
        
        GeometryReader { proxy in
            
            VStack {
                
                self.backBanner.frame(width: proxy.size.width, height: 120, alignment: .center)
                
                VStack(alignment: .center, spacing: 10) {
                    self.profilePic.clipShape(Circle()).padding(.top, -120).shadow(radius: 10)
                    
                    HStack {
                        TextField("N° tél", text: self.$account.numTel)
                            .padding()
                        Image(systemName: "phone")
                            .imageScale(.large)
                            .padding()
                            .foregroundColor(self.colorText)
                    }
                    .background(self.colorText.opacity(0.2)).clipShape(Capsule())
                    .padding(.horizontal).disabled(self.account.isConnected || self.isConnecting)
                    
                    HStack {
                        SecureField("Mot de passe", text: self.$account.password)
                            .padding()
                        Image(systemName: "lock")
                            .imageScale(.large)
                            .padding()
                            .foregroundColor(self.colorText)
                    }
                    .background(self.colorText.opacity(0.2)).clipShape(Capsule())
                    .padding(.horizontal).disabled(self.account.isConnected || self.isConnecting)
                    
                    Button(action: {
                        
                        if self.account.isConnected {
                            
                            if self.isConnecting {
                                print("how did you end up here ?!")
                            }
                            else {
                                // configured
                                self.account.isConnected = false
                            }
                        }
                        else {
                            // not configured
                            self.isConnecting = true
                            let client = APIConsoRequest(msisdn: self.account.numTel, password: self.account.password)
                            client.dispatch(onSuccess: {
                                response in
                                print(response)
                                self.account.nomOffre = response.offre
                                self.account.consumed = response.detail_forfait.internet_mobile_premium.consumed_mo
                                self.account.remaining = response.detail_forfait.internet_mobile_premium.remaining_mo
                                self.account.credit = response.detail_forfait.internet_mobile_premium.credits_mo
                                self.account.updateDate = Date(timeIntervalSince1970: response.update_date)
                                self.account.isConnected = true
                                self.isConnecting = false
                                print("nom offre: \(self.account.nomOffre)")
                                print("consumed: \(self.account.consumed)")
                                print("remaining: \(self.account.remaining)")
                                print("credit: \(self.account.credit)")
                                print("updateDate: \(self.account.updateDate)")
                                print("progress: \(self.account.consoProgress)")
                            }, onFailure: {
                                response, err in
                                print(err)
                                self.isConnecting = false
                            })
                        }
                        
                    }) {
                      HStack {
                        if self.account.isConnected {
                            if self.isConnecting {
                                ActivityIndicator(isAnimating: self.$isConnecting, style: .large)
                                    .padding()
                                    .cornerRadius(30)
                            }
                            else {
                                Text("Se déconnecter")
                                    .bold()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .padding(.vertical)
                                    .accentColor(self.colorButtonForeground)
                                    .background(self.colorButtonConnected)
                                    .cornerRadius(30)
                            }
                        }
                        else {
                            if self.isConnecting {
                                ActivityIndicator(isAnimating: self.$isConnecting, style: .large)
                                    .padding()
                                    .cornerRadius(30)
                            }
                            else {
                                Text("Se connecter")
                                .bold()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding(.vertical)
                                .accentColor(self.colorButtonForeground)
                                .background(self.colorButtonBackground)
                                .cornerRadius(30)
                            }
                        }
                       }
                    }.padding().disabled(self.isConnecting)
                    Spacer()
                }
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(account: Account(isConnected: true, numTel: "87344266", nomOffre: "Vini Pa Dourmir", consumed: 5569, remaining: 25131, credit: 30700))//.previewDevice(PreviewDevice.init(stringLiteral: "iPhone 7 Plus"))
            .previewDevice(PreviewDevice.init(stringLiteral: "iPhone SE"))
    }
}
