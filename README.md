# Inflect

[![CI Status](http://img.shields.io/travis/mukeshydv/Inflect.svg?style=flat)](https://travis-ci.org/mukeshydv/Inflect)
[![Version](https://img.shields.io/cocoapods/v/Inflect.svg?style=flat)](https://cocoapods.org/pods/Inflect)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://mit-license.org)
[![Platform](https://img.shields.io/cocoapods/p/Inflect.svg?style=flat)](https://cocoapods.org/pods/Inflect)
[![Language](https://img.shields.io/badge/swift-4.2.1-orange.svg)](https://developer.apple.com/swift)
[![codecov](https://codecov.io/gh/mukeshydv/Inflect/branch/master/graph/badge.svg)](https://codecov.io/gh/mukeshydv/Inflect)

Swift implementation of PERL library [Lingua::EN::Inflect](https://metacpan.org/pod/release/DCONWAY/Lingua-EN-Inflect-1.902/lib/Lingua/EN/Inflect.pm)

## Installation

### Swift Package Manager
To install `Inflect` via SPM add following dependency in your `Package.swift` file.

```swift
// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    dependencies: [
        .package(url: "https://github.com/mukeshydv/Inflect.git", from: "0.0.3"),
    ]
)
```

### CocoaPods
`Inflect` is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Inflect"
```

