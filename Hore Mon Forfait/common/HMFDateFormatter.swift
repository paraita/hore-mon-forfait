//
//  HMFDateFormatter.swift
//  Hore Mon Forfait
//
//  Created by Paraita Wohler on 7/4/20.
//  Copyright © 2020 Paraita.io. All rights reserved.
//

import Foundation

class HMFDateFormatter: DateFormatter {
    
    override init() {
        super.init()
        self.locale = Locale(identifier: "fr_FR")
        self.dateFormat = "dd MMMM YYYY à HH:mm"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
