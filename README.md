# Bitcoin

[![License](https://img.shields.io/cocoapods/l/Bitcoin.svg?style=flat)](https://cocoapods.org/pods/Bitcoin)
[![Platform](https://img.shields.io/cocoapods/p/Bitcoin.svg?style=flat)](https://cocoapods.org/pods/Bitcoin)

## Blog Post

On January 25, 2019 I published an announcement for this framework on my blog [here](https://wolfmcnally.com/125/announcing-open-source-bitcoin-framework-for-ios/).

## Requirements

* Swift 5

* Xcode 11

* The `Bitcoin` framework depends on the [CBitcoin](https://github.com/BlockchainCommons/iOS-CBitcoin) framework, which includes a pre-made build of [libbitcoin](https://github.com/libbitcoin). To properly install this, you need to first install the latest version of Git and the Git Large File Storage handler:

```bash
$ brew install git
$ brew install git-lfs
$ which git
/usr/local/bin/git
$ git --version
git version 2.21.0
```

## Installation

`Bitcoin` no longer supports building via Cocoapods, but since it relies on embedding the `CBitcoin` framework, which in turn embeds several third-party pre-built binary frameworks (libbitcoin etc.) it is also not suitable for distribution via the Swift Package Manager at this time. So for now, it is built directly as an Xcode project.

The Bitcoin and CBitcoin project directories should be siblings in the same directory:

MyProjects
|
+—— CBitcoin
|   |
|   +—— CBitcoin.xcodeproj
|
+—— Bitcoin
    |
    +—— Bitcoin.xcodeproj

```bash
$ cd MyProjects
$ git clone https://github.com/BlockchainCommons/iOS-CBitcoin.git CBitcoin
$ git clone https://github.com/BlockchainCommons/iOS-Bitcoin.git Bitcoin
$ cd CBitcoin/Sources
$ unzip -q Frameworks.zip
$ cd ../../Bitcoin
$ open Bitcoin.xcodeproj/
```

Within Xcode:

* Wait for the required Swift Packages to resolve, then Build the `Bitcoin` target for an available platform.

## Unit Tests

The `BitcoinDemo` app is simply an iOS container for the test suite. To run the unit tests, select the `BitcoinDemo` target and then `Product > Test`.

## Author

Wolf McNally, wolf@wolfmcnally.com

## License

Bitcoin is available under the Apache 2 license. See the LICENSE file for more info.
