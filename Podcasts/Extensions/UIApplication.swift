//
//  UIApplication.swift
//  Podcasts
//
//  Created by Artem Ekimov on 15.09.2021.
//

import UIKit

extension UIApplication {
    static func mainTabBarController() -> MainTabBarController? {
        return shared.windows.first { $0.isKeyWindow }?.rootViewController as? MainTabBarController
    }
}
