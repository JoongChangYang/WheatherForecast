//
//  View.swift
//  WeatherForecast
//
//  Created by 양중창 on 2020/02/24.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

class WeatherView: UIView {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    let backgroundImageView = UIImageView()
    private let blurEffectView = UIVisualEffectView()
    private var constraint = NSLayoutConstraint()
    private let backgroundImagePoint: CGFloat = 40
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        backgroundColor = .white
        addSubViews(views: [backgroundImageView, tableView])
        backgroundImageView.addSubview(blurEffectView)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
        tableView.register(CustomCell.self, forCellReuseIdentifier: "Cell")
        
        
//        backgroundImageView.image = UIImage(named: "cloudy")
        backgroundImageView.contentMode = .scaleAspectFill
        
        blurEffectView.effect = UIBlurEffect(style: .dark)
        blurEffectView.alpha = 0
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        
        let guide = safeAreaLayoutGuide
        let margin: CGFloat = 8
//        let widthMargin: CGFloat = 16
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        constraint = backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -backgroundImagePoint)
        constraint.isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: widthAnchor, constant: backgroundImagePoint).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: margin).isActive = true
        tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -margin).isActive = true
        
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor).isActive = true
        
        
        
//
//        currentWeatherView.translatesAutoresizingMaskIntoConstraints = false
//        currentWeatherView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        currentWeatherView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        currentWeatherView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//        currentWeatherView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
//        currentWeatherView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
//
//        currentTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
//        currentTemperatureLabel.bottomAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutYAxisAnchor>#>, constant: <#T##CGFloat#>)
//
        
    }
    
    func modifyBackgroundImageView(offset: CGFloat, maxOffset: CGFloat) {
        blurEffectView.alpha = (0.8 / maxOffset ) * offset
        let currentOffset = backgroundImagePoint - (backgroundImagePoint / maxOffset) * offset
        constraint.constant = -currentOffset
//        print(-currentOffset)
    }
    
    func reloadTableView() {
        tableView.alpha = 0
        tableView.transform = .init(translationX: frame.maxX, y: 0)
        tableView.reloadData()
        UIView.animate(withDuration: 1, animations: {
            self.tableView.alpha = 1
            self.tableView.transform = .identity
        })
    }
}
