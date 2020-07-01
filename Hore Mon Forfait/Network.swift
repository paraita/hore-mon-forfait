//
//  Network.swift
//  Hore Mon Forfait
//
//  Created by Paraita Wohler on 6/25/20.
//  Copyright © 2020 Paraita.io. All rights reserved.
//

import Foundation

// MARK: Response structs

struct APIConsoRequest: Codable {
    let content: String = "conso"
    let msisdn: String
    let password: String
}

struct APIInternetMobilePremium: Codable {
    let consumed_mo: Double
    let remaining_mo: Double
    let units: [String] = ["mo"]
    let credits_mo: Double
}

struct APIDetailForfait: Codable {
    let internet_mobile_premium: APIInternetMobilePremium
}

struct APIConsoSuccessResponse: Codable {
    let numero_vini: String
    let detail_forfait: APIDetailForfait
    let type: String
    let offre: String
    let update_date: Double
}

// MARK: API

protocol APIEndpoint {
    func endpoint() -> String
}

class APIRequest {
    
    struct ErrorResponse: Codable {
        let status: String
        let code: Int
        let message: String
    }
    
    enum APIError: Error {
        case invalidEndpoint
        case ErrorResponseDetected
        case noData
    }
}

extension APIConsoRequest: APIEndpoint {
    
    func endpoint() -> String {
        return "https://apps.vini.pf/SLFCR/APPS"
    }
    
    func dispatch(
        onSuccess successHandler: @escaping ((_: APIConsoSuccessResponse) -> Void),
        onFailure failureHandler: @escaping ((_: APIRequest.ErrorResponse?, _: Error) -> Void)) {
        APIRequest.post(request: self, onSuccess: successHandler, onError: failureHandler)
    }
}

extension APIRequest {
    
    public static func post<R: Codable & APIEndpoint, T: Codable, E: Codable>(
        request: R,
        onSuccess: @escaping ((_: T) -> Void),
        onError: @escaping ((_: E?, _: Error) -> Void)) {

        guard var endpointRequest = self.urlRequest(from: request) else {
            onError(nil, APIError.invalidEndpoint)
            return
        }
        endpointRequest.httpMethod = "POST"
        endpointRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        endpointRequest.httpBody = "content=conso&msisdn=87344266&password=8CnXXPRPXykf".data(using: .utf8)

        URLSession.shared.dataTask(
            with: endpointRequest,
            completionHandler: { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    self.processResponse(data, urlResponse, error, onSuccess: onSuccess, onError: onError)
                }
        }).resume()
    }
}

extension APIRequest {
    public static func processResponse<T: Codable, E: Codable>(
        _ dataOrNil: Data?,
        _ urlResponseOrNil: URLResponse?,
        _ errorOrNil: Error?,
        onSuccess: ((_: T) -> Void),
        onError: ((_: E?, _: Error) -> Void)) {

        if let data = dataOrNil {
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                onSuccess(decodedResponse)
            } catch {
                let originalError = error

                do {
                    let errorResponse = try JSONDecoder().decode(E.self, from: data)
                    onError(errorResponse, APIError.ErrorResponseDetected)
                } catch {
                    onError(nil, originalError)
                }
            }
        } else {
            onError(nil, errorOrNil ?? APIError.noData)
        }
    }
}

extension APIRequest {
    public static func urlRequest(from request: APIEndpoint) -> URLRequest? {
        guard let endpointUrl = URL(string: request.endpoint()) else {
            return nil
        }

        var endpointRequest = URLRequest(url: endpointUrl)
        endpointRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        return endpointRequest
    }
}
