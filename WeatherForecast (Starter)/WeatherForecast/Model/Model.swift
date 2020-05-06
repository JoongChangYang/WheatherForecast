//
//  Model.swift
//  WeatherForecast
//
//  Created by 양중창 on 2020/02/24.
//  Copyright © 2020 Giftbot. All rights reserved.
//


import MapKit
import Foundation

let jsonData =
"""
{
    "weather": {
        "hourly": [
            {
                "grid": {
                    "latitude": "36.10499",
                    "longitude": "127.13747",
                    "city": "충남",
                    "county": "논산시",
                    "village": "가야곡면"
                },
                "wind": {
                    "wdir": "281.00",
                    "wspd": "1.50"
                },
                "precipitation": {
                    "sinceOntime": "0.00",
                    "type": "0"
                },
                "sky": {
                    "code": "SKY_O01",
                    "name": "맑음"
                },
                "temperature": {
                    "tc": "15.00",
                    "tmax": "15.00",
                    "tmin": "-5.00"
                },
                "humidity": "30.00",
                "lightning": "0",
                "timeRelease": "2020-02-24 14:00:00"
            }
        ]
    },
    "common": {
        "alertYn": "Y",
        "stormYn": "N"
    },
    "result": {
        "code": 9200,
        "requestUrl": "/weather/current/hourly?appKey=l7xxedccea1442a042a78d31018e0cc04c10&lat=36.1234&lon=127.1234",
        "message": "성공"
    }
}
""".data(using: .utf8)

let jsonData2 =
"""
{
               "grid": {
                   "latitude": "36.10499",
                   "longitude": "127.13747",
                   "city": "충남",
                   "county": "논산시",
                   "village": "가야곡면"
               },
               "wind": {
                   "wdir": "281.00",
                   "wspd": "1.50"
               },
               "precipitation": {
                   "sinceOntime": "0.00",
                   "type": "0"
               },
               "sky": {
                   "code": "SKY_O01",
                   "name": "맑음"
               },
               "temperature": {
                   "tc": "15.00",
                   "tmax": "15.00",
                   "tmin": "-5.00"
               },
               "humidity": "30.00",
               "lightning": "0",
               "timeRelease": "2020-02-24 14:00:00"
           }
""".data(using: .utf8)

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

func test() {
//    guard let result = try? JSONSerialization.jsonObject(with: jsonData!, options: []) else { return }
//    let result = try! JSONDecoder().decode(CurrentWeather.self, from: jsonData2!)
//    dump(result)
    
    do {
//        let jsonObject = try JSONSerialization.jsonObject(with: foreCastTestData, options: [])
//        print(jsonObject)
        
        let result = try JSONDecoder().decode(ForeCastWearherResponse.self, from: foreCastTestData)
        dump(result)
    }catch {
        print(error.localizedDescription)
    }
    
    
}



let foreCastTestData =
"""
{
    "weather": {
        "forecast3days": [
            {
                "grid": {
                    "city": "충남",
                    "county": "논산시",
                    "village": "가야곡면",
                    "longitude": "127.13747",
                    "latitude": "36.10499"
                },
                "timeRelease": "2020-02-24 14:00:00",
                "fcst3hour": {
                    "wind": {
                        "wdir4hour": "196.00",
                        "wspd4hour": "0.80",
                        "wdir7hour": "124.00",
                        "wspd7hour": "0.80",
                        "wdir10hour": "101.00",
                        "wspd10hour": "0.60",
                        "wdir13hour": "117.00",
                        "wspd13hour": "0.50",
                        "wdir16hour": "153.00",
                        "wspd16hour": "0.70",
                        "wdir19hour": "174.00",
                        "wspd19hour": "0.90",
                        "wdir22hour": "186.00",
                        "wspd22hour": "1.80",
                        "wdir25hour": "213.00",
                        "wspd25hour": "1.70",
                        "wdir28hour": "100.00",
                        "wspd28hour": "1.00",
                        "wdir31hour": "49.00",
                        "wspd31hour": "0.90",
                        "wdir34hour": "50.00",
                        "wspd34hour": "0.70",
                        "wdir37hour": "39.00",
                        "wspd37hour": "0.60",
                        "wdir40hour": "27.00",
                        "wspd40hour": "0.70",
                        "wdir43hour": "16.00",
                        "wspd43hour": "0.80",
                        "wdir46hour": "345.00",
                        "wspd46hour": "1.40",
                        "wdir49hour": "331.00",
                        "wspd49hour": "1.70",
                        "wdir52hour": "333.00",
                        "wspd52hour": "1.20",
                        "wdir55hour": "324.00",
                        "wspd55hour": "0.80",
                        "wdir58hour": "315.00",
                        "wspd58hour": "0.50",
                        "wdir61hour": "",
                        "wspd61hour": "",
                        "wdir64hour": "",
                        "wspd64hour": "",
                        "wdir67hour": "",
                        "wspd67hour": ""
                    },
                    "precipitation": {
                        "type4hour": "0",
                        "prob4hour": "30.00",
                        "type7hour": "0",
                        "prob7hour": "30.00",
                        "type10hour": "1",
                        "prob10hour": "60.00",
                        "type13hour": "1",
                        "prob13hour": "80.00",
                        "type16hour": "1",
                        "prob16hour": "90.00",
                        "type19hour": "1",
                        "prob19hour": "90.00",
                        "type22hour": "1",
                        "prob22hour": "80.00",
                        "type25hour": "1",
                        "prob25hour": "90.00",
                        "type28hour": "1",
                        "prob28hour": "70.00",
                        "type31hour": "1",
                        "prob31hour": "60.00",
                        "type34hour": "0",
                        "prob34hour": "30.00",
                        "type37hour": "0",
                        "prob37hour": "30.00",
                        "type40hour": "0",
                        "prob40hour": "20.00",
                        "type43hour": "0",
                        "prob43hour": "30.00",
                        "type46hour": "0",
                        "prob46hour": "20.00",
                        "type49hour": "0",
                        "prob49hour": "30.00",
                        "type52hour": "0",
                        "prob52hour": "20.00",
                        "type55hour": "0",
                        "prob55hour": "0.00",
                        "type58hour": "0",
                        "prob58hour": "0.00",
                        "type61hour": "",
                        "prob61hour": "",
                        "type64hour": "",
                        "prob64hour": "",
                        "type67hour": "",
                        "prob67hour": ""
                    },
                    "sky": {
                        "code4hour": "SKY_S07",
                        "name4hour": "흐림",
                        "code7hour": "SKY_S07",
                        "name7hour": "흐림",
                        "code10hour": "SKY_S08",
                        "name10hour": "흐리고 비",
                        "code13hour": "SKY_S08",
                        "name13hour": "흐리고 비",
                        "code16hour": "SKY_S08",
                        "name16hour": "흐리고 비",
                        "code19hour": "SKY_S08",
                        "name19hour": "흐리고 비",
                        "code22hour": "SKY_S08",
                        "name22hour": "흐리고 비",
                        "code25hour": "SKY_S08",
                        "name25hour": "흐리고 비",
                        "code28hour": "SKY_S08",
                        "name28hour": "흐리고 비",
                        "code31hour": "SKY_S08",
                        "name31hour": "흐리고 비",
                        "code34hour": "SKY_S07",
                        "name34hour": "흐림",
                        "code37hour": "SKY_S07",
                        "name37hour": "흐림",
                        "code40hour": "SKY_S03",
                        "name40hour": "구름많음",
                        "code43hour": "SKY_S07",
                        "name43hour": "흐림",
                        "code46hour": "SKY_S03",
                        "name46hour": "구름많음",
                        "code49hour": "SKY_S07",
                        "name49hour": "흐림",
                        "code52hour": "SKY_S03",
                        "name52hour": "구름많음",
                        "code55hour": "SKY_S01",
                        "name55hour": "맑음",
                        "code58hour": "SKY_S01",
                        "name58hour": "맑음",
                        "code61hour": "",
                        "name61hour": "",
                        "code64hour": "",
                        "name64hour": "",
                        "code67hour": "",
                        "name67hour": ""
                    },
                    "temperature": {
                        "temp4hour": "11.00",
                        "temp7hour": "8.00",
                        "temp10hour": "7.00",
                        "temp13hour": "7.00",
                        "temp16hour": "8.00",
                        "temp19hour": "8.00",
                        "temp22hour": "8.00",
                        "temp25hour": "9.00",
                        "temp28hour": "10.00",
                        "temp31hour": "8.00",
                        "temp34hour": "7.00",
                        "temp37hour": "6.00",
                        "temp40hour": "5.00",
                        "temp43hour": "7.00",
                        "temp46hour": "12.00",
                        "temp49hour": "13.00",
                        "temp52hour": "10.00",
                        "temp55hour": "4.00",
                        "temp58hour": "2.00",
                        "temp61hour": "",
                        "temp64hour": "",
                        "temp67hour": ""
                    },
                    "humidity": {
                        "rh4hour": "65.00",
                        "rh64hour": "",
                        "rh67hour": "",
                        "rh7hour": "75.00",
                        "rh10hour": "85.00",
                        "rh13hour": "90.00",
                        "rh16hour": "85.00",
                        "rh19hour": "90.00",
                        "rh22hour": "95.00",
                        "rh25hour": "95.00",
                        "rh28hour": "90.00",
                        "rh31hour": "90.00",
                        "rh34hour": "85.00",
                        "rh37hour": "90.00",
                        "rh40hour": "90.00",
                        "rh43hour": "85.00",
                        "rh46hour": "70.00",
                        "rh49hour": "50.00",
                        "rh52hour": "55.00",
                        "rh55hour": "80.00",
                        "rh58hour": "95.00",
                        "rh61hour": ""
                    }
                },
                "fcst6hour": {
                    "rain6hour": "없음",
                    "rain12hour": "1~4mm",
                    "rain18hour": "20~39mm",
                    "rain24hour": "20~39mm",
                    "rain30hour": "10~19mm",
                    "rain36hour": "1~4mm",
                    "rain42hour": "없음",
                    "rain48hour": "없음",
                    "rain54hour": "없음",
                    "snow6hour": "없음",
                    "snow12hour": "없음",
                    "snow18hour": "없음",
                    "snow24hour": "없음",
                    "snow30hour": "없음",
                    "snow36hour": "없음",
                    "snow42hour": "없음",
                    "snow48hour": "없음",
                    "snow54hour": "없음",
                    "rain60hour": "없음",
                    "rain66hour": "",
                    "snow60hour": "없음",
                    "snow66hour": ""
                },
                "fcstdaily": {
                    "temperature": {
                        "tmax1day": "",
                        "tmax2day": "11.00",
                        "tmax3day": "14.00",
                        "tmin1day": "",
                        "tmin2day": "6.00",
                        "tmin3day": "4.00"
                    }
                }
            }
        ]
    },
    "common": {
        "alertYn": "Y",
        "stormYn": "N"
    },
    "result": {
        "code": 9200,
        "requestUrl": "/weather/forecast/3days?appKey=l7xxedccea1442a042a78d31018e0cc04c10&lat=36.1234&lon=127.1234",
        "message": "성공"
    }
}
""".data(using: .utf8)!
