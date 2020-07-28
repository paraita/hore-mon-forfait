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
    
    var bannerSize: CGSize

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: GADAdSizeFromCGSize(self.bannerSize))
        let viewController = UIViewController()
        view.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: self.bannerSize)
        view.load(GADRequest())
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    init(bannerSize: CGSize) {
        self.bannerSize = bannerSize
    }
}

struct AdBanner: View {
    
    var width: CGFloat = 320
    var height: CGFloat = 50
    
    var body: some View {
        HStack {
            Spacer()
            AdBannerVC(bannerSize: CGSize(width: width, height: height)).frame(width: width, height: height, alignment: .center)
            Spacer()
        }
    }
}

struct AdBanner_Previews: PreviewProvider {
    static var previews: some View {
        AdBanner(width: 320, height: 50)
    }
}
