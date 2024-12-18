//
//  City.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation

struct City: Codable, Hashable {
    let name: String
    let latitude: Double
    let longitude: Double
}
