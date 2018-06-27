//
//  main.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/7/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import UIKit

private func delegateClassName() -> String? {
    if ProcessInfo.isRunningUnitTests {
        // Use test AppDelegate for unit tests
        return NSStringFromClass(TestAppDelegate.self)
    }
    // Use regular AppDelegate for UI tests and application running
    return NSStringFromClass(AppDelegate.self)
}

let commandLineArguments = CommandLine.argc
let argumentList = UnsafeMutableRawPointer(CommandLine.unsafeArgv)
let typePointer = argumentList.bindMemory(
    to: UnsafeMutablePointer<Int8>.self,
    capacity: Int(CommandLine.argc)
)
let className = delegateClassName()
UIApplicationMain(commandLineArguments, typePointer, nil, className)
