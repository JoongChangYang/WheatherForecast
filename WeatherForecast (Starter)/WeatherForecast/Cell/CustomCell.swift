//
//  CustomCellTableViewCell.swift
//  WeatherForecast
//
//  Created by 양중창 on 2020/02/24.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    let dayLabel = UILabel()
    let timeLabel = UILabel()
    let weatherImageView = UIImageView()
    let underLine = UIView()
    let temperatureLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        backgroundColor = .clear
        
        contentView.addSubViews(views: [
        dayLabel,
        timeLabel,
        weatherImageView,
        underLine,
        temperatureLabel
        ])
     
        dayLabel.textColor = .white
        dayLabel.font = .systemFont(ofSize: frame.height * 0.3, weight: .light)
        timeLabel.textColor = .white
        timeLabel.font = .systemFont(ofSize: frame.height * 0.5, weight: .regular)
        
        temperatureLabel.textColor = .white
        temperatureLabel.font = .systemFont(ofSize: frame.height  * 0.9, weight: .ultraLight)
        
        underLine.backgroundColor = .lightGray
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        
        let margin: CGFloat = 8
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin).isActive = true
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin).isActive = true
        
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        weatherImageView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        weatherImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8).isActive = true
        weatherImageView.widthAnchor.constraint(equalTo: weatherImageView.heightAnchor).isActive = true
        
        underLine.translatesAutoresizingMaskIntoConstraints = false
        underLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        underLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        underLine.leadingAnchor.constraint(equalTo: weatherImageView.leadingAnchor).isActive = true
        underLine.trailingAnchor.constraint(equalTo: weatherImageView.trailingAnchor).isActive = true
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin).isActive = true
        temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        
        
    }
    
    func configure(date: Date, skyCode: String, skyName: String, temperature: String) {
        
        let temperature = Int(Double(temperature) ?? 0)
        
        let dayString = setDateToString(date: date, format: "M.d(E)")
        let timeString = setDateToString(date: date, format: "HH:mm")
        
        dayLabel.text = dayString
        timeLabel.text = timeString
        temperatureLabel.text = "\(temperature)º"
        let image = UIImage(named: skyCode.replacingOccurrences(of: "_S", with: "_"))
        weatherImageView.image = image
        
        
    }
    
    func setDateToString(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let result = formatter.string(from: date)
        
        return result
    }
    
    
}
