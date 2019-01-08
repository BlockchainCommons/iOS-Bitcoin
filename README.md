# Bitcoin

[![CI Status](https://img.shields.io/travis/wolfmcnally/Bitcoin.svg?style=flat)](https://travis-ci.org/wolfmcnally/Bitcoin)
[![Version](https://img.shields.io/cocoapods/v/Bitcoin.svg?style=flat)](https://cocoapods.org/pods/Bitcoin)
[![License](https://img.shields.io/cocoapods/l/Bitcoin.svg?style=flat)](https://cocoapods.org/pods/Bitcoin)
[![Platform](https://img.shields.io/cocoapods/p/Bitcoin.svg?style=flat)](https://cocoapods.org/pods/Bitcoin)

## Requirements

* Swift 4.2

* The `Bitcoin` framework depends on the [CBitcoin](https://github.com/BlockchainCommons/iOS-CBitcoin) framework, which includes a pre-made build of [libbitcoin](https://github.com/libbitcoin). To properly install this, you need to first install the latest version of Git and the Git Large File Storage handler:

```bash
$ brew install git
$ brew install git-lfs
$ which git
/usr/local/bin/git
$ git --version
git version 2.20.1
```

## Installation

Bitcoin is available through [Cocoapods](https://github.com/cocoapods.org). To install it, add the following line to your Podfile:

```ruby
pod 'Bitcoin'
```

## Author

Wolf McNally, wolf@wolfmcnally.com

## License

Bitcoin is available under the MIT license. See the LICENSE file for more info.
