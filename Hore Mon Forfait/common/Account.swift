//
//  Account.swift
//  Hore Mon Forfait
//
//  Created by Paraita Wohler on 6/23/20.
//  Copyright © 2020 Paraita.io. All rights reserved.
//

import Foundation
import Combine

class Account: ObservableObject, Codable {
    
    static let sharedInstance: Account = Account()
    
    enum CodingKeys: CodingKey {
        case numTel, password, isConnected, nomOffre, consumed, remaining, credit, consoProgress, updateDate
    }
    
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
            if credit > 0 {
                consoProgress = Float(consumed/credit)
            }
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
            if credit > 0 {
                consoProgress = Float(consumed/credit)
            }
        }
    }
    
    @Published var updateDate: Date {
        didSet {
            UserDefaults.standard.set(updateDate, forKey: "updateDate")
        }
    }
    
    @Published var consoProgress: Float {
        didSet {
            UserDefaults.standard.set(consoProgress, forKey: "consoProgress")
        }
    }
    
    func update(with response: APIConsoSuccessResponse) {
        numTel = response.numero_vini
        nomOffre = response.offre
        consumed = response.detail_forfait.internet_mobile_premium.consumed_mo
        remaining = response.detail_forfait.internet_mobile_premium.remaining_mo
        credit = response.detail_forfait.internet_mobile_premium.credits_mo
        updateDate = Date(timeIntervalSince1970: response.update_date)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(numTel, forKey: .numTel)
        try container.encode(password, forKey: .password)
        try container.encode(isConnected, forKey: .isConnected)
        try container.encode(nomOffre, forKey: .nomOffre)
        try container.encode(consumed, forKey: .consumed)
        try container.encode(remaining, forKey: .remaining)
        try container.encode(credit, forKey: .credit)
        try container.encode(consoProgress, forKey: .consoProgress)
        try container.encode(updateDate, forKey: .updateDate)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        numTel = try container.decode(String.self, forKey: .numTel)
        password = try container.decode(String.self, forKey: .password)
        isConnected = try container.decode(Bool.self, forKey: .isConnected)
        nomOffre = try container.decode(String.self, forKey: .nomOffre)
        consumed = try container.decode(Double.self, forKey: .consumed)
        remaining = try container.decode(Double.self, forKey: .remaining)
        credit = try container.decode(Double.self, forKey: .credit)
        consoProgress = try container.decode(Float.self, forKey: .consoProgress)
        updateDate = try container.decode(Date.self, forKey: .updateDate)
    }
    
    // TODO: utiliser le singleton dans toutes les classes appellantes
    private init() {
        self.numTel = UserDefaults.standard.object(forKey: "numTel") as? String ?? ""
        self.password = UserDefaults.standard.object(forKey: "password") as? String ?? ""
        self.isConnected = UserDefaults.standard.object(forKey: "isConnected") as? Bool ?? false
        self.nomOffre = UserDefaults.standard.object(forKey: "nomOffre") as? String ?? ""
        self.consumed = UserDefaults.standard.object(forKey: "consumed") as? Double ?? 0.0
        self.remaining = UserDefaults.standard.object(forKey: "remaining") as? Double ?? 0.0
        self.credit = UserDefaults.standard.object(forKey: "credit") as? Double ?? 0.0
        self.consoProgress = UserDefaults.standard.object(forKey: "consoProgress") as? Float ?? 0.0
        self.updateDate = UserDefaults.standard.object(forKey: "updateDate") as? Date ?? Date()
    }
    
    convenience init(isConnected: Bool, numTel: String, nomOffre: String, consumed: Double, remaining: Double, credit: Double) {
        self.init()
        self.password = "initial-password"
        self.isConnected = isConnected
        self.numTel = numTel
        self.nomOffre = nomOffre
        self.consumed = consumed
        self.remaining = remaining
        self.credit = credit
        if credit > 0 {
            self.consoProgress = Float(consumed/credit)
        }
        else {
            self.consoProgress = 0.0
        }
    }
    
}
