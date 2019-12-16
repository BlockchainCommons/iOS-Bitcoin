//
//  Asset.swift
//  Bitcoin
//
//  Created by Wolf McNally on 2/2/19.
//

import WolfPipe

public typealias PaymentAddressValidator = (PaymentAddress, Network) -> String?

public struct Asset: Codable {
    public let name: String
    public let symbol: String
    public let network: Network
    public let decimalPlaces: Int
    public let coinType: CoinType
    public let paymentAddressValidator: PaymentAddressValidator?

    public init(name: String, symbol: String, network: Network, decimalPlaces: Int, coinType: CoinType, paymentAddressValidator: PaymentAddressValidator? = nil) {
        self.name = name
        self.symbol = symbol
        self.network = network
        self.decimalPlaces = decimalPlaces
        self.coinType = coinType
        self.paymentAddressValidator = paymentAddressValidator
    }

    public init(symbol: String) throws {
        guard let asset = assetsBySymbol[symbol] else {
            throw BitcoinError.unknownAsset
        }
        self = asset
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let symbol = try container.decode(String.self)
        try self.init(symbol: symbol)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(symbol)
    }

    public func validatePaymentAddress(_ address: PaymentAddress) -> String? {
        guard let validator = paymentAddressValidator else {
            return "I can't parse that kind of address yet."
        }
        return validator(address, network)
    }

    public func coinType(for network: Network) -> CoinType {
        switch network {
        case .mainnet:
            return coinType
        case .testnet:
            return .testnet
        }
    }
}

extension Asset: Equatable {
    public static func == (lhs: Asset, rhs: Asset) -> Bool {
        return lhs.symbol == rhs.symbol
    }
}

private func btcPaymentAddressValidator(address: PaymentAddress, network: Network) -> String? {
    do {
        let wrappedData = try address |> addressDecode
        guard let version = PaymentAddressVersion(version: wrappedData.prefix) else {
            return "This is not a recognized Bitcoin address."
        }
        let addressNetwork = version.network
        guard addressNetwork == network else {
            return "This Bitcoin address is for \(addressNetwork). It may not be used on \(network)."
        }
    } catch {
        return "The Bitcoin address is not valid."
    }
    return nil
}

public func identifyAsset(from address: PaymentAddress) -> Asset? {
    do {
        let wrappedData = try address |> addressDecode
        guard let version = PaymentAddressVersion(version: wrappedData.prefix) else {
            return nil
        }
        switch version.network {
        case .mainnet:
            return .btc
        case .testnet:
            return .btct
        }
    } catch {
        return nil
    }
}

public let ethDecimalPlaces = 18

public extension Asset {
    static let bch = Asset(name: "Bitcoin Cash", symbol: "BCH", network: .mainnet, decimalPlaces: btcDecimalPlaces, coinType: .bch)
    static let btc = Asset(name: "Bitcoin", symbol: "BTC", network: .mainnet, decimalPlaces: btcDecimalPlaces, coinType: .btc, paymentAddressValidator: btcPaymentAddressValidator)
    static let btct = Asset(name: "Bitcoin Testnet", symbol: "BTCT", network: .testnet, decimalPlaces: btcDecimalPlaces, coinType: .testnet, paymentAddressValidator: btcPaymentAddressValidator)
    static let etc = Asset(name: "Ethereum Classic", symbol: "ETC", network: .mainnet, decimalPlaces: ethDecimalPlaces, coinType: .etc)
    static let eth = Asset(name: "Ethereum", symbol: "ETH", network: .mainnet, decimalPlaces: ethDecimalPlaces, coinType: .eth)
    static let ltc = Asset(name: "Litecoin", symbol: "LTC", network: .mainnet, decimalPlaces: btcDecimalPlaces, coinType: .ltc)
}

public var assetsBySymbol: [String: Asset] = [
    "BCH": .bch,
    "BTC": .btc,
    "BTCT": .btct,
    "ETC": .etc,
    "ETH": .eth,
    "LTC": .ltc
]

public func toBase10(_ asset: Asset) -> (_ amount: Fragments) -> Base10 {
    { amount in
        amount |> toBase10(decimalPlaces: asset.decimalPlaces)
    }
}

public func toFragments(_ asset: Asset, strict: Bool = true) -> (_ base10: Base10) throws -> Fragments {
    { base10 in
        try base10 |> toFragments(decimalPlaces: asset.decimalPlaces, strict: strict)
    }
}
