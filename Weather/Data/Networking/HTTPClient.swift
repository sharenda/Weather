//
//  HTTPClient.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation

final class HTTPClient {
    func request<T: Decodable>(_ url: URL) async throws -> T {
        Logger.info("Starting network request to: \(url.absoluteString)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        Logger.debug("Received response with \(data.count) bytes")
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            Logger.error("Invalid HTTP response received")
            throw NetworkError.invalidResponse
        }
        
        do {
            Logger.debug("Attempting to decode response as \(String(describing: T.self))")
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            Logger.info("Successfully decoded response")
            return decodedResponse
        } catch {
            Logger.error("Failed to decode response", error: error)
            throw NetworkError.decodingFailed
        }
    }
}
