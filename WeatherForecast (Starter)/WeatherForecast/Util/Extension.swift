//
//  Extension.swift
//  WeatherForecast
//
//  Created by 양중창 on 2020/02/24.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit


extension UIView {
    
    
    func addSubViews(views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
    
    
}

extension String {
    func componentOfDeleting(of strings: String...) -> String {
        var result = self
        strings.forEach({
            result = result.replacingOccurrences(of: $0, with: "")
        })
        return result
    }
}
