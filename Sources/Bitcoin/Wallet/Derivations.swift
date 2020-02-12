//
//  Derivations.swift
//  Bitcoin
//
//  Created by Wolf McNally on 5/30/19.
//
//  Copyright © 2018 Blockchain Commons.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation
import WolfPipe

//
// See Docs/Derivations.pdf for diagrams of these derivations
//

public final class SeedDerivation {
    public let mnemonic: Mnemonic
    public let passphrase: String
    private var _seed: Data!

    public init(mnemonic: Mnemonic, passphrase: String) {
        self.mnemonic = mnemonic
        self.passphrase = passphrase
    }

    public var seed: Data {
        if _seed == nil {
            _seed = try! mnemonic |> toSeed(passphrase: passphrase)
        }
        return _seed
    }
}

public final class BIP44AccountPrivateKeyDerivation {
    public let seed: Data
    public let asset: Asset
    public let accountIndex: Int
    private var _network: Network!
    private var _masterHDKey: HDKey!
    private var _path: BIP32Path!
    private var _accountPrivateKey: HDKey!
    private var _accountPublicKey: HDKey!

    public init(seed: Data, asset: Asset, accountIndex: Int) {
        self.seed = seed
        self.asset = asset
        self.accountIndex = accountIndex
    }

    public var network: Network {
        if _network == nil {
            _network = asset.network
        }
        return _network
    }

    public var masterHDKey: HDKey {
        if _masterHDKey == nil {
            // version will be either `xprv` or `tprv`.
            let version = HDKeyVersion.findVersion(coinType: .btc, network: network, encoding: .p2pkh)!
            _masterHDKey = try! seed |> newHDPrivateKey(hdKeyVersion: version)
        }
        return _masterHDKey
    }

    public var accountPrivateKey: HDKey {
        if _accountPrivateKey == nil {
            _accountPrivateKey = try! masterHDKey |> deriveHDAccountPrivateKey(accountIndex: accountIndex)
        }
        return _accountPrivateKey
    }

    public var accountPublicKey: HDKey {
        if _accountPublicKey == nil {
            _accountPublicKey = try! accountPrivateKey |> toHDPublicKey
        }
        return _accountPublicKey
    }

    public var path: BIP32Path {
        if _path == nil {
            _path = try! hdAccountPrivateKeyDerivationPath(masterKey: masterHDKey, accountIndex: accountIndex)
        }
        return _path
    }
}

public final class BIP44PaymentAddressDerivation {
    public let addressPublicKey: HDKey
    public let asset: Asset
    private var _network: Network!
    private var _addressPublicECKey: ECCompressedPublicKey!
    private var _paymentAddress: PaymentAddress!

    public init(addressPublicKey: HDKey, asset: Asset) {
        self.addressPublicKey = addressPublicKey
        self.asset = asset
    }

    public var network: Network {
        if _network == nil {
            _network = asset.network
        }
        return _network
    }

    public var addressPublicECKey: ECCompressedPublicKey {
        if _addressPublicECKey == nil {
            _addressPublicECKey = try! (addressPublicKey |> toECKey) as! ECCompressedPublicKey
        }
        return _addressPublicECKey
    }

    public var paymentAddress: PaymentAddress {
        if _paymentAddress == nil {
            _paymentAddress = try! addressPublicECKey |> toECPaymentAddress(network: network, type: .p2kh)
        }
        return _paymentAddress
    }
}

public final class BIP44AddressPrivateKeyDerivation {
    public let accountPrivateKey: HDKey
    public let chainType: ChainType
    public let addressIndex: Int
    private var _addressPrivateKey: HDKey!
    private var _addressPrivateECKey: ECPrivateKey!
    private var _addressPublicKey: HDKey!
    private var _path: BIP32Path!

    public init(accountPrivateKey: HDKey, chainType: ChainType, addressIndex: Int) {
        self.accountPrivateKey = accountPrivateKey
        self.chainType = chainType
        self.addressIndex = addressIndex
    }

    public var addressPrivateKey: HDKey {
        if _addressPrivateKey == nil {
            _addressPrivateKey = try! accountPrivateKey |> deriveHDAddressPrivateKey(chainType: chainType, addressIndex: addressIndex)
        }
        return _addressPrivateKey
    }

    public var addressPrivateECKey: ECPrivateKey {
        if _addressPrivateECKey == nil {
            _addressPrivateECKey = try! (addressPrivateKey |> toECKey) as! ECPrivateKey
        }
        return _addressPrivateECKey
    }

    public var addressPublicKey: HDKey {
        if _addressPublicKey == nil {
            _addressPublicKey = try! addressPrivateKey |> toHDPublicKey
        }
        return _addressPublicKey
    }

    public var path: BIP32Path {
        if _path == nil {
            _path = hdAddressPrivateKeyDerivationPath(chainType: chainType, addressIndex: addressIndex)
        }
        return _path
    }
}

public final class BIP44AddressPublicKeyDerivation {
    public let accountPublicKey: HDKey
    public let chainType: ChainType
    public let addressIndex: Int
    private var _addressPublicKey: HDKey!

    public init(accountPublicKey: HDKey, chainType: ChainType, addressIndex: Int) {
        self.accountPublicKey = accountPublicKey
        self.chainType = chainType
        self.addressIndex = addressIndex
    }

    public var addressPublicKey: HDKey {
        if _addressPublicKey == nil {
            _addressPublicKey = try! accountPublicKey |> deriveHDAddressPublicKey(chainType: chainType, addressIndex: addressIndex)
        }
        return _addressPublicKey
    }
}

public final class BIP44SigningDerivation {
    public let seed: Data
    public let asset: Asset
    public let accountIndex: Int
    public let addressIndex: Int
    public let chainType: ChainType

    private var _accountPrivateKeyDerivation: BIP44AccountPrivateKeyDerivation!
    private var _addressPrivateKeyDerivation: BIP44AddressPrivateKeyDerivation!
    private var _paymentAddressDerivation: BIP44PaymentAddressDerivation!
    private var _path: BIP32Path!

    public init(seed: Data, asset: Asset, accountIndex: Int, addressIndex: Int, chainType: ChainType) {
        self.seed = seed
        self.asset = asset
        self.accountIndex = accountIndex
        self.addressIndex = addressIndex
        self.chainType = chainType
    }

    public var accountPrivateKeyDerivation: BIP44AccountPrivateKeyDerivation {
        if _accountPrivateKeyDerivation == nil {
            _accountPrivateKeyDerivation = .init(seed: seed, asset: asset, accountIndex: accountIndex)
        }
        return _accountPrivateKeyDerivation
    }

    public var addressPrivateKeyDerivation: BIP44AddressPrivateKeyDerivation {
        if _addressPrivateKeyDerivation == nil {
            _addressPrivateKeyDerivation = .init(accountPrivateKey: accountPrivateKeyDerivation.accountPrivateKey, chainType: chainType, addressIndex: addressIndex)
        }
        return _addressPrivateKeyDerivation
    }

    public var paymentAddressDerivation: BIP44PaymentAddressDerivation {
        if _paymentAddressDerivation == nil {
            _paymentAddressDerivation = .init(addressPublicKey: addressPrivateKeyDerivation.addressPublicKey, asset: asset)
        }
        return _paymentAddressDerivation
    }

    public var inputAddress: PaymentAddress {
        return paymentAddressDerivation.paymentAddress
    }

    public var inputPrivateECKey: ECPrivateKey {
        return addressPrivateKeyDerivation.addressPrivateECKey
    }

    public var inputPublicECKey: ECCompressedPublicKey {
        return paymentAddressDerivation.addressPublicECKey
    }

    public var path: BIP32Path {
        if _path == nil {
            _path = accountPrivateKeyDerivation.path.appending(addressPrivateKeyDerivation.path)
        }
        return _path
    }
}
