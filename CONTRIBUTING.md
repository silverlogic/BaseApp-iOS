# Contributing Guidelines

## Swift Code

### Code Style

* Use the official Ray Wenderlich Swift style guide for code style (found in https://github.com/raywenderlich/swift-style-guide)
* Use Swift's official API Design Guidelines as well (found in https://swift.org/documentation/api-design-guidelines/)
* Complie the application to run SwiftLint and fix linting errors that are reported

### Tests

Tests are written using XCTest, KIF, and OHHTTPStubs. Unit tests can be found in
the `UnitTests` directory. Integration tests can be found in the
`IntegrationTests` directory.
For all new features added and implemented, all code **must** be accompanied by
unit tests, integration tests or both depending on the type of feature being implemented.

#### Definitions

* Unit test - A test suite for testing an individually component in isolation. For example, testing `CoreDataStack` by itself.
* Integration test - A test suite for testing different components working together that drives a feature. For example, testing your `UIViewController`. These test would be considered UI tests using KIF.

#### Running Tests

* To run all unit tests in Xcode, select the scheme `BaseApp`. Then go to Test navigator to run the tests.
* To run all integration tests in Xcode, select the scheme `IntegrationTests`. Then go to Test navigator to run the tests.

## Documentation

** Any changes or new features added to BaseApp iOS V2 must have documentation. **

Documentation is required for the following:

* functions
* class declarations
* structs
* protocols
* enums
* getters/setters

When writing documentation, use Swift's documentation style guide (found in http://nshipster.com/swift-documentation/)

## Source files

The only source files that are allowed at the root of the project is the following:

* AppDelegate.swift
* TestAppDelegate.swift
* main.swift
* Constants.swift
* Assets.xcassets
* Info.plist
* BaseAppV2.entitlements
* BaseAppV2-Bridging-Header.h

Any other source files added must be place in the correct directory both in Xcode and in the actually, equivalent source directory of the project. It should also follow the current architecture of the application.

## Pull requests

* A pull request should be created for all feature branches requesting a merge into master.
* All pull requests should only have one commit.
* All tests must pass and code coverage should not decrease in order to get approved.
* There should be at least two approvals for a pull request to be merge.
