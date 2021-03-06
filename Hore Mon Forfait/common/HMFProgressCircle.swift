//
//  HMFProgressCircle.swift
//  Hore Mon Forfait
//
//  Created by Paraita Wohler on 7/4/20.
//  Copyright © 2020 Paraita.io. All rights reserved.
//

import SwiftUI

struct HMFProgressCircle: View {
    
    var progressBarColor: Color = Color(#colorLiteral(red: 0.7260068059, green: 0.1090376303, blue: 0.09677212685, alpha: 1))
    var lineWidth: Float = 20.0
    var progressValue: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: CGFloat(self.lineWidth))
                .opacity(0.3)
                .foregroundColor(self.progressBarColor)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(1.0 - self.progressValue, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: CGFloat(self.lineWidth), lineCap: .round, lineJoin: .round))
                .foregroundColor(self.progressBarColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            VStack {
                Text(String(format: "%.0f %%", min(1.0 - self.progressValue, 1.0)*100.0))
                    .font(.title)
                    .bold()
                Text("restant")
                    .font(.subheadline)
                    .bold()
            }
        }
    }
}

extension View {
    func animate(using animation: Animation = Animation.easeInOut(duration: 2), _ action: @escaping () -> Void) -> some View {
        return onAppear {
            withAnimation(animation) {
                action()
            }
        }
    }
}

struct HMFProgressCircle_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            ScrollView {
                VStack {
                    Text("Offre téléphone").bold()
                    HMFProgressCircle(lineWidth: 15.0, progressValue: 0.01)
                        .frame(width: 120, height: 120)
                    Text("Dernière maj le 04 juillet 2020 à 18:42").font(.footnote).italic()
                }
            }
            .previewDevice("Apple Watch Series 5 - 40mm")
            
            ScrollView {
                VStack {
                    Text("Offre téléphone").bold()
                    HMFProgressCircle(lineWidth: 15.0, progressValue: 0.99)
                        .frame(width: 120, height: 120)
                    Text("Dernière maj le 04 juillet 2020 à 18:42").font(.footnote).italic()
                }
            }
            .previewDevice("Apple Watch Series 5 - 44mm")
        }
    }
}
