//
//  String.swift
//  Podcasts
//
//  Created by Artem Ekimov on 11.09.2021.
//

import Foundation

extension String {
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
