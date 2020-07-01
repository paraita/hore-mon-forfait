//
//  Account.swift
//  Hore Mon Forfait
//
//  Created by Paraita Wohler on 6/23/20.
//  Copyright © 2020 Paraita.io. All rights reserved.
//

import Foundation
import Combine

class Account: ObservableObject {
    
    @Published var numTel: String {
        didSet {
            UserDefaults.standard.set(numTel, forKey: "numTel")
        }
    }
    @Published var password: String {
        didSet {
            UserDefaults.standard.set(password, forKey: "password")
        }
    }
    
    @Published var isConnected: Bool {
        didSet {
            UserDefaults.standard.set(isConnected, forKey: "isConnected")
        }
    }
    
    @Published var nomOffre: String {
        didSet {
            UserDefaults.standard.set(nomOffre, forKey: "nomOffre")
        }
    }
    
    @Published var consumed: Double {
        didSet {
            UserDefaults.standard.set(consumed, forKey: "consumed")
        }
    }
    
    @Published var remaining: Double {
        didSet {
            UserDefaults.standard.set(remaining, forKey: "remaining")
        }
    }
    
    @Published var credit: Double {
        didSet {
            UserDefaults.standard.set(credit, forKey: "credit")
        }
    }
    
    @Published var updateDate: Date {
        didSet {
            UserDefaults.standard.set(updateDate, forKey: "updateDate")
        }
    }
    
    var consoProgress: Float {
        return Float(self.consumed/self.credit)
    }
    
    init() {
        let consumed = UserDefaults.standard.object(forKey: "consumed") as? Double ?? 0.0
        let credit = UserDefaults.standard.object(forKey: "credit") as? Double ?? 0.0
        self.numTel = UserDefaults.standard.object(forKey: "numTel") as? String ?? ""
        self.password = UserDefaults.standard.object(forKey: "password") as? String ?? ""
        self.isConnected = UserDefaults.standard.object(forKey: "isConnected") as? Bool ?? false
        self.nomOffre = UserDefaults.standard.object(forKey: "nomOffre") as? String ?? ""
        self.consumed = consumed
        self.remaining = UserDefaults.standard.object(forKey: "remaining") as? Double ?? 0.0
        self.credit = credit
        self.updateDate = UserDefaults.standard.object(forKey: "updateDate") as? Date ?? Date()
    }
    
    convenience init(isConnected: Bool, numTel: String, nomOffre: String, consumed: Double, remaining: Double, credit: Double) {
        self.init()
        self.isConnected = isConnected
        self.numTel = numTel
        self.nomOffre = nomOffre
        self.consumed = consumed
        self.remaining = remaining
        self.credit = credit
    }
    
}
