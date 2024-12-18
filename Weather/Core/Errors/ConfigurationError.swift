//
//  ConfigurationError.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation

enum ConfigurationError: Error {
    case missingConfigFile
    case invalidConfigData
    case invalidAPIKey
}
