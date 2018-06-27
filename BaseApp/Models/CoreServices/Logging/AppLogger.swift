//
//  AppLogger.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/7/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import SwiftyBeaver

// MARK: - Log Level Type

/// An enum that specifies the level type of logging.
enum LogLevelType: Int {
    case verbose
    case debug
    case info
    case warning
    case error
}


// MARK: - App Logger

/// A singleton responsible for logging operations in the application. Also an abstraction layer for managing
/// all logging communication to SwiftyBeaver.
final class AppLogger {
    
    // MARK: - Shared Instance
    static let shared = AppLogger()
    
    
    // MARK: - Private Instance Attributes
    fileprivate let _swiftyLogger: SwiftyBeaver.Type
    
    
    // MARK: - Initializers
    
    /// Initializes a shared instance of `AppLogger`.
    private init() {
        _swiftyLogger = SwiftyBeaver.self
        configureLogging()
    }
}


// MARK: - Public Instance Methods For Logging
extension AppLogger {

    /// Takes a message and logs it to SwiftyBeaver.
    ///
    /// - Parameters:
    ///   - message: A `String` representing the message that would be logged in the console and in the log
    ///              file of SwiftyBeaver.
    ///   - logLevelType: A `LogLevelType` representing the log level type to use when logging.
    ///   - debugOnly: A `Bool` indicating if it should log only when the application is running in `DEBUG`
    ///                or not.
    func logMessage(_ message: String, for logLevelType: LogLevelType, debugOnly: Bool = false) {
        #if !DEBUG
            if debugOnly { return }
        #endif
        guard let logLevel = SwiftyBeaver.Level(rawValue: logLevelType.rawValue) else { return }
        _swiftyLogger.custom(level: logLevel, message: message)
    }
}


// MARK: - Private Instance Methods
fileprivate extension AppLogger {

    /// Configures logging for the application at launch.
    fileprivate func configureLogging() {
        let loggingFormat = "$DHH:mm:ss$d $C$L$c: $M"
        let consoleDestination = ConsoleDestination()
        consoleDestination.format = loggingFormat
        _swiftyLogger.addDestination(consoleDestination)
        let fileDestinationOne = FileDestination()
        fileDestinationOne.format = loggingFormat
        _swiftyLogger.addDestination(fileDestinationOne)
        // Check if running in unit test target
        if ProcessInfo.isRunningUnitTests {
            // Only need standard cache directory
            // with special formatting
            fileDestinationOne.format = "$M"
            _swiftyLogger.addDestination(fileDestinationOne)
            return
        }
        fileDestinationOne.format = loggingFormat
        _swiftyLogger.addDestination(fileDestinationOne)
        let fileDestinationTwo = FileDestination()
        fileDestinationTwo.format = loggingFormat
        fileDestinationTwo.logFileURL = URL(fileURLWithPath: "/tmp/swiftybeaver.log")
        _swiftyLogger.addDestination(fileDestinationTwo)
    }
}
