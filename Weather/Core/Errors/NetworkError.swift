//
//  NetworkError.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case decodingFailed
    case badURL
    case invalidIconURL
}
