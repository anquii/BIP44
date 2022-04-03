# BIP44

[![Platform](https://img.shields.io/badge/Platforms-macOS%20%7C%20iOS-blue)](#platforms)
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-orange)](#swift-package-manager)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/anquii/BIP44/blob/main/LICENSE)

An implementation of [BIP-0044](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki) in Swift.

## Platforms
- macOS 10.15+
- iOS 13+

## Installation

### Swift Package Manager

Add the following line to your `Package.swift` file:
```swift
.package(url: "https://github.com/anquii/BIP44.git", from: "1.0.0")
```
...or integrate with Xcode via `File -> Swift Packages -> Add Package Dependency...` using the URL of the repository.

## Usage

```swift
import BIP44

let accountProvider: AccountProviding = try AccountProvider(seed: seed, coinType: coinType)
let account = try accountProvider.account(name: "Savings", index: 0)

let addressProvider: AddressProviding = AddressProvider(account: account, addressType: .`external`, addressVersion: 0)
let address = addressProvider.address(index: 0)
// e.g. 1PRTTaJesdNovgne6Ehcdu1fpEdX7913CK
```

Find out more by exploring the public API (e.g. for neutered accounts), and by looking through the [tests](Tests/BIP44Tests). You should also read through the [BIP-0044](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki) requirements about [when to allow the creation of an account](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki#account), and [how to discover used accounts](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki#account-discovery) following the import of a master seed from an external source.

## License

`BIP44` is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file for more information.
