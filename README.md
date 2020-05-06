# WeatherForecast



## Description

- 현재 위치의 날씨 정보를 알려주는 간단한 날씨 정보 앱 입니다.
- 현재 날씨: 1시간 단위로 현재 날씨 정보를 제공 합니다.
- 단기 예보: 현재 시간으로 부터 3시간 간격으로 67시간 까지의 날씨 예보를 제공합니다.



## Sample clip

<img src="https://github.com/JoongChangYang/WeatherForecast/blob/master/Accets/WeatherForecast.gif"></img>





## Trouble Shooting

- 현재 날씨, 단기예보 두개의 다른 request 보내고 response를 받는 과정에서 UI를 업데이트하는 시점의 문제
  	- SK Weather Planet Open API 구조상 현재날씨와 단기예보의 request를 따로 보내야 하는데 어떤 request가 먼저 끝날지 알 수 없기때문에 UI를 업데이트하는 시점이 정확하지 않음
  	- DispatchGroup의 notify 함수를 이용하여 두개의 request가 정상적으로 종료되면 안전하게 UI를 업데이트하게 함.



