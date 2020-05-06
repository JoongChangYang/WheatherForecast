//
//  CustomHeaderView.swift
//  WeatherForecast
//
//  Created by 양중창 on 2020/02/24.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {
    
//    private let currentWeatherView = UIView()
    let dot = "º"
    let currentWeatherImageView = UIImageView()
    let currentWeatherNameLabel = UILabel()
    
    let currentMinTemperatureImageView = UIImageView()
    let currentMinTemperatureLabel = UILabel()
    
    let currentMaxTemperatureImageView = UIImageView()
    let currentMaxTemperatureLabel = UILabel()
    
    let currentTemperatureLabel = CustomLabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubViews(views: [
            currentTemperatureLabel,
            currentMinTemperatureImageView,
            currentMinTemperatureLabel,
            currentMaxTemperatureImageView,
            currentMaxTemperatureLabel,
            currentWeatherImageView,
            currentWeatherNameLabel
        ])
        
        currentTemperatureLabel.text = "19.2º"
        
        
        currentMaxTemperatureLabel.text = "최고기온"
        currentMaxTemperatureLabel.textColor = .white
        
        currentMinTemperatureLabel.text = "최저기온"
        currentMinTemperatureLabel.textColor = .white
        
        currentMinTemperatureImageView.image = UIImage(systemName: "arrow.down.to.line")
        currentMinTemperatureImageView.tintColor = .white
        
        currentMaxTemperatureImageView.image = UIImage(systemName: "arrow.up.to.line")
        currentMaxTemperatureImageView.tintColor = .white
        
        currentWeatherImageView.image = UIImage(named: "SKY_01")
        currentWeatherImageView.contentMode = .scaleAspectFit
        
        currentWeatherNameLabel.text = "맑음"
        currentWeatherNameLabel.textColor = .white
        currentWeatherNameLabel.font = .systemFont(ofSize: 20)
        
        
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        let margin: CGFloat = 8
        
        currentTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTemperatureLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        currentTemperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        currentTemperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
        currentTemperatureLabel.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35).isActive = true
        
        currentMinTemperatureImageView.translatesAutoresizingMaskIntoConstraints = false
        currentMinTemperatureImageView.bottomAnchor.constraint(equalTo: currentTemperatureLabel.topAnchor).isActive = true
        currentMinTemperatureImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        currentMinTemperatureImageView.heightAnchor.constraint(equalTo: currentMinTemperatureLabel.heightAnchor).isActive = true
        currentMinTemperatureImageView.widthAnchor.constraint(equalTo: currentMinTemperatureImageView.widthAnchor).isActive = true
        
        currentMinTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        currentMinTemperatureLabel.bottomAnchor.constraint(equalTo: currentTemperatureLabel.topAnchor).isActive = true
        currentMinTemperatureLabel.leadingAnchor.constraint(equalTo: currentMinTemperatureImageView.trailingAnchor, constant: margin).isActive = true
        
        currentMaxTemperatureImageView.translatesAutoresizingMaskIntoConstraints = false
        currentMaxTemperatureImageView.leadingAnchor.constraint(equalTo: currentMinTemperatureLabel.trailingAnchor, constant: margin * 2).isActive = true
        currentMaxTemperatureImageView.bottomAnchor.constraint(equalTo: currentTemperatureLabel.topAnchor).isActive = true
        currentMaxTemperatureImageView.heightAnchor.constraint(equalTo: currentMaxTemperatureLabel.heightAnchor).isActive = true
        currentMaxTemperatureImageView.widthAnchor.constraint(equalTo: currentMaxTemperatureImageView.heightAnchor).isActive = true
        
        currentMaxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        currentMaxTemperatureLabel.bottomAnchor.constraint(equalTo: currentTemperatureLabel.topAnchor).isActive = true
        currentMaxTemperatureLabel.leadingAnchor.constraint(equalTo: currentMaxTemperatureImageView.trailingAnchor, constant: margin).isActive = true
        
        currentWeatherImageView.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherImageView.bottomAnchor.constraint(equalTo: currentMinTemperatureImageView.topAnchor, constant: -margin).isActive = true
        currentWeatherImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        currentWeatherImageView.heightAnchor.constraint(equalTo: currentWeatherNameLabel.heightAnchor, multiplier: 2).isActive = true
        currentWeatherImageView.widthAnchor.constraint(equalTo: currentWeatherImageView.heightAnchor).isActive = true
        
        currentWeatherNameLabel.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherNameLabel.leadingAnchor.constraint(equalTo: currentWeatherImageView.trailingAnchor, constant: margin).isActive = true
        currentWeatherNameLabel.bottomAnchor.constraint(equalTo: currentMinTemperatureImageView.topAnchor, constant: -margin).isActive = true
        currentWeatherNameLabel.heightAnchor.constraint(equalToConstant: currentWeatherNameLabel.font.pointSize).isActive = true
    }
    
    
    func configure(
        _ currentTemperature: String,
        _ currentMinTemperature: String,
        _ currentMaxTemperature: String,
        _ currentWeatherCode: String,
        _ currentWeatherName: String) {
        
        currentTemperatureLabel.text = setTemperatureFormatter(string: currentTemperature)
        currentMinTemperatureLabel.text = setTemperatureFormatter(string: currentMinTemperature)
        currentMaxTemperatureLabel.text = setTemperatureFormatter(string: currentMaxTemperature)
        currentWeatherNameLabel.text = currentWeatherName
        let imageName = currentWeatherCode.replacingOccurrences(of: "_O", with: "_")
//        print(imageName)
        currentWeatherImageView.image = UIImage(named: imageName)
    }
    
    func setTemperatureFormatter(string: String) -> String {
        guard let temp = Double(string) else { return "nil" }
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        let result = (formatter.string(from: temp as NSNumber) ?? "nil") + dot
        return result
    }
    
    
}
