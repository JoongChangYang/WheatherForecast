//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    private let weatherView = WeatherView()
    private var model = Model()
    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    private var lastDate = Date(timeIntervalSinceNow: -10)

  override func viewDidLoad() {
    super.viewDidLoad()
    
//    test()
    setupUI()
    checkAuthorizationStatus()
    
  }
    
    override func loadView() {
        view = weatherView
    }
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    private func setupUI() {
//        view.addSubview(weatherView)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.rightBarButtonItem?.customView = UIImageView(image: UIImage(systemName: "arrow.clockwise"))
        
        let customButton = UIButton()
        customButton.tintColor = .white
        customButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        customButton.addTarget(self, action: #selector(reLoadWeather(_:)), for: .touchUpInside)

        let barButton = UIBarButtonItem(customView: customButton)
        barButton.tintColor = .black
        
        navigationItem.rightBarButtonItem = barButton
        
        weatherView.tableView.dataSource = self
        weatherView.tableView.delegate = self
        
    }
    
    @objc private func reLoadWeather(_ sender: UIButton) {
        
        
        let spinAnimation = CABasicAnimation(keyPath: "transform.rotation")
        spinAnimation.duration = 0.5
        spinAnimation.toValue = CGFloat.pi * 2
        sender.layer.add(spinAnimation, forKey: "spinAnimation")
        
        configure()
        
    }
    
    private func checkAuthorizationStatus() {
        
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedWhenInUse:
            configure()
        case .authorizedAlways:
            configure()
        default:
            break
        }
    }
    
    private func configure() {
        let status = CLLocationManager.authorizationStatus()
        guard status == .authorizedWhenInUse else { return }
        guard CLLocationManager.locationServicesEnabled() else { return }
        locationManager.startUpdatingLocation()
        
    }
    
    private func request(latitude: String, longitude: String) {
        let weatherRequestGroup = DispatchGroup()
        
        requestCurrentWeather(latitude: latitude, logitude: longitude, group: weatherRequestGroup)
        requestForecast(latitude: latitude, longitude: longitude, group: weatherRequestGroup)
        let workItem = DispatchWorkItem(block: {
            [weak self] in
            self?.weatherView.reloadTableView()
            print("Finished all request")
        })
        weatherRequestGroup.notify(queue: .main, work: workItem)
    }
    
    
    private func requestCurrentWeather(latitude: String, logitude: String, group: DispatchGroup) {
        group.enter()
        APIManager().request(
            latitude: latitude,
            longitude: logitude,
            query: .current,
            completionHandler: {
                [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let data):
                    self.decodingCurrentWeather(data: data)
                }
                group.leave()
        })
    }
    
    private func decodingCurrentWeather(data: Data) {
        guard let response = try? JSONDecoder().decode(CurrentWeatherResponse.self, from: data) else { print("Current Decoding Error"); return }
        guard response.result.code == 9200
            else {
                print(response.result.message)
                return
        }
        self.model.current = response.currentWeather
        print("Finished", #function)
    }
    
    private func requestForecast(latitude: String, longitude: String, group: DispatchGroup) {
        group.enter()
        APIManager().request(
            latitude: latitude,
            longitude: longitude,
            query: .forecast,
            completionHandler: {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                self.decodingForecast(data: data)
            }
                group.leave()
        })
    }
    
    private func decodingForecast(data: Data) {
        guard let response = try? JSONDecoder().decode(ForeCastWearherResponse.self, from: data) else { print("ForeCast Decoding Error"); return }
        guard let result = response.weathers.first ,response.result.code == 9200
            else {
                print(response.result.message)
                return
        }
            sortedDatas(weathers: result)
        
    }
    
    private func sortedDatas(weathers: ForeCastWeathers) {
        
        var i = 4
        var tempWeathers: [ForeCastWeather] = []
        while i <= 67 {
            defer {
                i += 3
            }

            let codeKey = "code\(i)hour"
            let nameKey = "name\(i)hour"
            let tempKey = "temp\(i)hour"
            
            guard
                let skyCode = weathers.skys[codeKey],
                let skyName = weathers.skys[nameKey],
                let temperature = weathers.temperatures[tempKey]
                else { return }
            guard !skyCode.isEmpty && !skyName.isEmpty && !temperature.isEmpty else { break }
            guard let date = makeDate(responseDate: weathers.timeRelease, interval: i) else { break }
            let weather = ForeCastWeather(skyCode: skyCode, skyName: skyName, temperature: temperature, date: date)
            tempWeathers.append(weather)
        }
        
        model.forecast = tempWeathers
        print("Finished", #function)
    }
    
    private func setupBackgroundImage(weatherCode: String) {
        
        guard let codeNumber = Int(weatherCode.replacingOccurrences(of: "SKY_O", with: "")) else { return }
        var imageName = ""
        
        switch codeNumber {
        case 1, 2:
            imageName = "sunny"
        case 3, 7:
            imageName = "cloudy"
        case (4...6), (8...10):
            imageName = "rainy"
        case (11...14):
            imageName = "lightning"
        default:
            return
        }
        weatherView.backgroundImageView.image = UIImage(named: imageName)
    }
    
    private func makeDate(responseDate: String, interval: Int) -> Date?{
        let formatter = DateFormatter()
        let timeInterval = Double(3600 * interval)
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: responseDate) else { return nil }
        let resultDate = Date(timeInterval: timeInterval, since: date)
        return resultDate
    }
    
    
    private func setupCurrentWeather(location: Location, weatherCode: String) {
        navigationItem.title = location.city + " " + location.county
        setupBackgroundImage(weatherCode: weatherCode)
    }

}

extension ViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        model.current.count
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        
        let data = model.forecast[indexPath.row]
        
        cell.configure(date: data.date, skyCode: data.skyCode, skyName: data.skyName, temperature: data.temperature)
        
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableView.frame.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height / 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let data = model.current[section]
        setupCurrentWeather(location: data.location, weatherCode: data.sky.code)
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! CustomHeaderView 
            headerView.configure(
                data.temperature.currentTemperature,
                data.temperature.minTemperature,
                data.temperature.maxTempertature,
                data.sky.code,
                data.sky.name
                )
            return headerView
            
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let maxOffset = scrollView.frame.height * 0.6
        
        guard offset >= 0 && offset <= maxOffset else { return }
        
        weatherView.modifyBackgroundImageView(offset: offset, maxOffset: maxOffset)
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        configure()
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationManager.stopUpdatingLocation()
        self.location = location
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        let current = Date()
        
        if abs(lastDate.timeIntervalSince(current)) > 2 {
            request(latitude: latitude, longitude: longitude)
            lastDate = current
        }
        
        
    }
    
}
