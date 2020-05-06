//
//  Model.swift
//  WeatherForecast
//
//  Created by 양중창 on 2020/02/24.
//  Copyright © 2020 Giftbot. All rights reserved.
//


import MapKit
import Foundation

struct Model {
    let api = API()
    var current: [CurrentWeather] = []
    var forecast: [ForeCastWeather] = []
}

struct Location: Decodable {
    let city: String
    let county: String
    let village: String
}

struct Sky: Decodable {
    let code: String
    let name: String
}

struct Temperature: Decodable {
    let currentTemperature: String
    let maxTempertature: String
    let minTemperature: String
    
    private enum CodingKeys: String, CodingKey {
          case currentTemperature = "tc"
          case maxTempertature = "tmax"
          case minTemperature = "tmin"
      }
      
}

struct CurrentWeather: Decodable {
    
    let location: Location
    let sky: Sky
    let temperature: Temperature
    
    private enum CodingKeys: String, CodingKey {
        case location = "grid"
        case sky, temperature
    }
    
}

struct Result: Decodable {
    let code: Int
    let requestUrl: String
    let message: String
}



struct CurrentWeatherResponse: Decodable {
    
    let currentWeather: [CurrentWeather]
    
    let result:Result
    
    private enum WeatherKey: String, CodingKey {
        case weather, result
    }
    
    private enum HourlyKey: String, CodingKey {
        case hourly
    }
    
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WeatherKey.self)
        self.result = try container.decode(Result.self, forKey: .result)
        
        let nestedContainer = try container.nestedContainer(keyedBy: HourlyKey.self, forKey: .weather)
        self.currentWeather = try nestedContainer.decode([CurrentWeather].self, forKey: .hourly)
    }
    
}



struct ForeCastWearherResponse: Decodable {
    
    let result: Result
    let weathers: [ForeCastWeathers]
    
    private enum CodingKeys: String, CodingKey {
        case weather
        case result
    }
    private enum NestedKeys: String, CodingKey {
        case forecast3days
    }
//    private enum FinalNestedKeys: String, CodingKey {
//        case fcst3hour
//    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.result = try container.decode(Result.self, forKey: .result)
        
        let nestedContainer = try container.nestedContainer(keyedBy: NestedKeys.self, forKey: .weather)
        self.weathers = try nestedContainer.decode([ForeCastWeathers].self, forKey: .forecast3days)
//        let finalNestedContainer = try nestedContainer.nestedContainer(keyedBy: FinalNestedKeys.self, forKey: .forecast3days)
//        self.weathers = try finalNestedContainer.decode([ForeCastWeathers].self, forKey: .fcst3hour)
    }
    
}

struct ForeCastWeathers: Decodable {
    
    let skys: [String: String]
    let temperatures: [String: String]
    let timeRelease: String

    private enum CodingKeys: String, CodingKey {
        case timeRelease
        case fcst3hour
    }

    private enum NestedKeys: String, CodingKey {
        case skys = "sky"
        case temperatures = "temperature"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timeRelease = try container.decode(String.self, forKey: .timeRelease)
        
        let nestedContainer = try container.nestedContainer(keyedBy: NestedKeys.self, forKey: .fcst3hour)

        self.skys = try nestedContainer.decode([String: String].self, forKey: .skys)
        self.temperatures = try nestedContainer.decode([String: String].self, forKey: .temperatures)
        
    }
}

struct ForeCastWeather {
    let skyCode: String
    let skyName: String
    let temperature: String
    let date: Date
}



