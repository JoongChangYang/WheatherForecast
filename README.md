# WeatherForecast



## Description

현재 위치의 날씨 정보를 알려주는 간단한 날씨 정보 앱 입니다.

- 개발 기간: 2020.02.24 ~ 2020.02.25 (2일)

- 현재 날씨: 1시간 단위로 현재 날씨 정보를 제공 합니다.
- 단기 예보: 현재 시간으로 부터 3시간 간격으로 67시간 까지의 날씨 예보를 제공합니다.


​      
## Using skill

- language: Swift
- Frame Work: UIKit, CoreLocation
- Open API: SK Weather Planet Open API



## Implementation

<img src="Accets/WeatherForecast.gif"></img>

- `CLLocationManager` class 를 이용하여 디바이스의 위치 정보 권한을 확인하고 권한이 없는 경우 요청
- 위치 정보에 대한 권한이 있으면 현재 위치 정보를 가지고 현재 위치의 날씨 정보를 요청
- 응답 받은 날씨 정보의 JSON data를 `Codable`을 이용하여 파싱 후 UI  업데이트 



## Troubleshooting

- 현재 날씨, 단기예보 두개의 다른 request를 보내고 response를 받는 과정에서 UI를 업데이트하는 시점의 문제
  	- ***SK Weather Planet Open API*** 구조상 현재날씨와 단기예보의 request를 따로 보내야 하는데 어떤 request가 먼저 끝날지 알 수 없기때문에 UI를 업데이트하는 시점이 정확하지 않음
  	- `DispatchGroup`의 `notify` 함수를 이용하여 두개의 request가 정상적으로 종료되면 안전하게 UI를 업데이트하게 함.

