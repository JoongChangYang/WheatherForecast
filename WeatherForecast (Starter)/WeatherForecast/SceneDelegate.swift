//
//  SceneDelegate.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    let window = UIWindow(windowScene: windowScene)
    let viewController = ViewController()
    let navigationController = UINavigationController(rootViewController: viewController)
//    window.backgroundColor = .white
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    self.window = window
    
    
  }
}
