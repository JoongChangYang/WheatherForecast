//
//  API.swift
//  WeatherForecast
//
//  Created by 양중창 on 2020/02/24.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import Foundation

enum WeatherQuery: String {
    case current = "/current/hourly"
    case forecast = "/forecast/3days"
}

enum APIResult<Success, Failure> where Failure: Error {
    case success(Success)
    case failure(Failure)
}

enum APIError: Error {
    case badURL
    case noData
}

struct APIManager {
    
    let url = "https://apis.openapi.sk.com/weather"
    let key = AppKey.key.rawValue
//    let group: DispatchGroup
    
    
    func request (
        latitude: String,
        longitude: String,
        query: WeatherQuery,
        completionHandler: @escaping (APIResult<Data, Error>) -> Void) {
        
        let stringURL = self.url + query.rawValue
        var urlComponent = URLComponents(string: stringURL)
        urlComponent?.queryItems = [
        URLQueryItem(name: "appKey", value: key),
        URLQueryItem(name: "lat", value: latitude),
        URLQueryItem(name: "lon", value: longitude)
        ]
        guard let url = urlComponent?.url else {
            completionHandler(.failure(APIError.badURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            }else {
                guard let data = data else {
                    completionHandler(.failure(APIError.noData))
                    return
                }
//                dump(try! JSONSerialization.jsonObject(with: data, options: []))
//                print(String(data: data, encoding: .utf8))
                completionHandler(.success(data))
            }
            })
        
        task.resume()
    }
    
    
    
}
// 현재 날씨(시간별)
// 단기 예보

