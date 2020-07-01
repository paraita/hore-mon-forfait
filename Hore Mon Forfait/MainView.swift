//
//  ContentView.swift
//  Hore Mon Forfait
//
//  Created by Paraita Wohler on 6/23/20.
//  Copyright © 2020 Paraita.io. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State private var selection = 0
    @ObservedObject var account: Account = Account()
 
    var body: some View {
        TabView(selection: $selection){

            ConsoView(account: account)
            .tabItem {
                VStack {
                    Image(systemName: "gauge")
                    Text("Conso")
                }
            }
            .tag(0)
            
            
            AccountView(account: account)
                .tabItem {
                    VStack {
                        Image(systemName: "person.crop.circle")
                        Text("Compte")
                    }
                }
                .tag(1)
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
