//
//  AdMob.swift
//  Hore Mon Forfait
//
//  Created by Paraita Wohler on 7/19/20.
//  Copyright © 2020 Paraita.io. All rights reserved.
//

import SwiftUI
import GoogleMobileAds
import UIKit

final class AdBannerVC: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeBanner)
        let viewController = UIViewController()
        view.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        view.load(GADRequest())
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

struct AdBanner: View {
    var body: some View {
        HStack {
            Spacer()
            AdBannerVC().frame(width: 320, height: 50, alignment: .center)
            Spacer()
        }
    }
}

struct AdBanner_Previews: PreviewProvider {
    static var previews: some View {
        AdBanner()
    }
}
