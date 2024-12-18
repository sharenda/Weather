//
//  Logger.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation
import os

/// A type-safe logging utility that wraps `os.Logger` for consistent application-wide logging.
/// Uses Apple's unified logging system for efficient log collection and filtering.
public struct Logger {
    // MARK: - Properties
    
    /// The shared logger instance using the app's bundle identifier
    private static let logger = os.Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.example.app",
        category: "Default"
    )
    
    // MARK: - Initialization
    
    /// Prevents initialization as this is a utility type
    private init() {}
    
    // MARK: - Logging Methods
    
    /// Logs a message with a specified log level
    /// - Parameters:
    ///   - message: The message to be logged
    ///   - level: The severity level of the log (default: .default)
    ///   - file: The file where the log was called (automatically inserted)
    ///   - function: The function where the log was called (automatically inserted)
    ///   - line: The line where the log was called (automatically inserted)
    public static func log(
        _ message: String,
        level: OSLogType = .default,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let metadata = "[\(sourceFileName(filePath: file)):\(line)] \(function)"
        logger.log(level: level, "\(metadata) - \(message, privacy: .private)")
    }
    
    /// Logs a debug message with public visibility
    /// - Parameters:
    ///   - message: The debug message to be logged
    ///   - file: The file where the log was called (automatically inserted)
    ///   - function: The function where the log was called (automatically inserted)
    ///   - line: The line where the log was called (automatically inserted)
    public static func debug(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let metadata = "[\(sourceFileName(filePath: file)):\(line)] \(function)"
        logger.debug("🔍 DEBUG: \(metadata) - \(message, privacy: .public)")
    }
    
    /// Logs an error message with optional error details
    /// - Parameters:
    ///   - message: The error message to be logged
    ///   - error: Optional error object containing additional details
    ///   - file: The file where the log was called (automatically inserted)
    ///   - function: The function where the log was called (automatically inserted)
    ///   - line: The line where the log was called (automatically inserted)
    public static func error(
        _ message: String,
        error: Error? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let metadata = "[\(sourceFileName(filePath: file)):\(line)] \(function)"
        if let error = error {
            logger.error("❌ ERROR: \(metadata) - \(message) | Details: \(error.localizedDescription, privacy: .private)")
        } else {
            logger.error("❌ ERROR: \(metadata) - \(message, privacy: .private)")
        }
    }
    
    /// Logs an info message with public visibility
    /// - Parameters:
    ///   - message: The info message to be logged
    ///   - file: The file where the log was called (automatically inserted)
    ///   - function: The function where the log was called (automatically inserted)
    ///   - line: The line where the log was called (automatically inserted)
    public static func info(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let metadata = "[\(sourceFileName(filePath: file)):\(line)] \(function)"
        logger.info("ℹ️ INFO: \(metadata) - \(message, privacy: .public)")
    }
    
    // MARK: - Helper Methods
    
    /// Extracts the file name from a file path
    /// - Parameter filePath: The full file path
    /// - Returns: The file name without extension
    private static func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        guard let fileName = components.last else { return "" }
        return fileName.components(separatedBy: ".").first ?? ""
    }
}
