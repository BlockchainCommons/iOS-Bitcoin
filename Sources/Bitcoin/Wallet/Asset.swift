//
//  Asset.swift
//  Bitcoin
//
//  Created by Wolf McNally on 2/2/19.
//

public struct Asset: Codable {
    public let name: String
    public let symbol: String
    public let decimalPlaces: Int
    public let coinType: CoinType

    public init(name: String, symbol: String, decimalPlaces: Int, coinType: CoinType) {
        self.name = name
        self.symbol = symbol
        self.decimalPlaces = decimalPlaces
        self.coinType = coinType
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let symbol = try container.decode(String.self)
        self = assetsBySymbol[symbol]!
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(symbol)
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

let ethDecimalPlaces = 18

extension Asset {
    static let bch = Asset(name: "Bitcoin Cash", symbol: "BCH", decimalPlaces: btcDecimalPlaces, coinType: .bch)
    static let btc = Asset(name: "Bitcoin", symbol: "BTC", decimalPlaces: btcDecimalPlaces, coinType: .btc)
    static let etc = Asset(name: "Ethereum Classic", symbol: "ETC", decimalPlaces: ethDecimalPlaces, coinType: .etc)
    static let eth = Asset(name: "Ethereum", symbol: "ETH", decimalPlaces: ethDecimalPlaces, coinType: .eth)
    static let ltc = Asset(name: "Litecoin", symbol: "LTC", decimalPlaces: btcDecimalPlaces, coinType: .ltc)
}

var assetsBySymbol: [String: Asset] = [
    "BCH": .bch,
    "BTC": .btc,
    "ETC": .etc,
    "ETH": .eth,
    "LTC": .ltc
]
