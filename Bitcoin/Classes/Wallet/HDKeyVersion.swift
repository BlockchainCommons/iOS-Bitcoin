//
//  HDKeyVersion.swift
//  Bitcoin
//
//  Created by Wolf McNally on 2/2/19.
//

import WolfFoundation
import WolfPipe

public struct HDKeyVersion {
    public let network: Network
    public let purpose: HDKeyPurpose?
    public let coinType: CoinType
    public let publicVersion: UInt32
    public let publicPrefix: Base58
    public let privateVersion: UInt32
    public let privatePrefix: Base58
    public let encodings: Set<PaymentAddressEncoding>

    //
    // Note that version bytes are specific to particular lengths of payloads.
    //
    // Python code to derive version from prefix is here:
    // https://bitcoin.stackexchange.com/questions/28380/i-want-to-generate-a-bip32-version-number-for-namecoin-and-other-altcoins/56639#56639
    //

    public init(coinType: CoinType, network: Network, purpose: HDKeyPurpose? = nil, publicVersion: UInt32, publicPrefix: Base58, privateVersion: UInt32, privatePrefix: Base58, encodings: Set<PaymentAddressEncoding>) {
        self.coinType = coinType
        self.network = network
        self.purpose = purpose
        self.publicVersion = publicVersion
        self.publicPrefix = publicPrefix
        self.privateVersion = privateVersion
        self.privatePrefix = privatePrefix
        self.encodings = encodings
    }

    public var bip32Path: BIP32Path? {
        guard let purpose = purpose else { return nil }
        return [
            .init(index: purpose®, isHardened: true),
            .init(index: coinType®, isHardened: true)
        ]
    }

    public static func findVersion(coinType: CoinType, network: Network, encoding: PaymentAddressEncoding) -> HDKeyVersion? {
        return hdKeyVersions.first { $0.coinType == coinType && $0.network == network && $0.encodings.contains(encoding) }
    }
}

public func network(_ version: HDKeyVersion) -> Network {
    return version.network
}

/// SLIP-0132 : Registered HD version bytes for BIP-0032
/// https://github.com/satoshilabs/slips/blob/master/slip-0132.md
public var hdKeyVersions: [HDKeyVersion] = [
    .init(coinType: .btc, network: .mainnet, purpose: .accountTree,  publicVersion: 0x0488b21e, publicPrefix: "xpub", privateVersion: 0x0488ade4, privatePrefix: "xprv", encodings: [.p2pkh, .p2sh]),
    .init(coinType: .btc, network: .mainnet, purpose: .p2wpkhInP2sh, publicVersion: 0x049d7cb2, publicPrefix: "ypub", privateVersion: 0x049d7878, privatePrefix: "yprv", encodings: [.p2wpkhInP2sh]),
    .init(coinType: .btc, network: .mainnet, purpose: .p2wpkh,       publicVersion: 0x04b24746, publicPrefix: "zpub", privateVersion: 0x04b2430c, privatePrefix: "zprv", encodings: [.p2wpkh]),
    .init(coinType: .btc, network: .mainnet,                         publicVersion: 0x0295b43f, publicPrefix: "Ypub", privateVersion: 0x0295b005, privatePrefix: "Yprv", encodings: [.p2wshInP2sh]),
    .init(coinType: .btc, network: .mainnet,                         publicVersion: 0x02aa7ed3, publicPrefix: "Zpub", privateVersion: 0x02aa7a99, privatePrefix: "Zprv", encodings: [.p2wsh]),

    .init(coinType: .btc, network: .testnet, purpose: .accountTree,  publicVersion: 0x043587cf, publicPrefix: "tpub", privateVersion: 0x04358394, privatePrefix: "tprv", encodings: [.p2pkh, .p2sh]),
    .init(coinType: .btc, network: .testnet, purpose: .p2wpkhInP2sh, publicVersion: 0x044a5262, publicPrefix: "upub", privateVersion: 0x044a4e28, privatePrefix: "uprv", encodings: [.p2wpkhInP2sh]),
    .init(coinType: .btc, network: .testnet, purpose: .p2wpkh,       publicVersion: 0x045f1cf6, publicPrefix: "vpub", privateVersion: 0x045f18bc, privatePrefix: "vprv", encodings: [.p2wpkh]),
    .init(coinType: .btc, network: .testnet,                         publicVersion: 0x024289ef, publicPrefix: "Upub", privateVersion: 0x024285b5, privatePrefix: "Uprv", encodings: [.p2wshInP2sh]),
    .init(coinType: .btc, network: .testnet,                         publicVersion: 0x02575483, publicPrefix: "Vpub", privateVersion: 0x02575048, privatePrefix: "Vprv", encodings: [.p2wsh]),
]
