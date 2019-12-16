//
//  Fee.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/24/19.
//  Copyright © 2019 Blockchain Commons. All rights reserved.
//

import Foundation
import WolfPipe

public struct FeeRate: Codable {
    public let targetConfirmationMinutes: Int
    public let satoshisPerVbyte: Double

    public init(targetConfirmationMinutes: Int, satoshisPerVbyte: Double) {
        self.targetConfirmationMinutes = targetConfirmationMinutes
        self.satoshisPerVbyte = satoshisPerVbyte
    }
}

public struct FeeSchedule: Codable {
    // Array of fee estimates sorted ascending by confirmation time.
    public let feeRates: [FeeRate]

    public init(_ feeEstimates: [FeeRate]) {
        self.feeRates = feeEstimates.sorted { $0.targetConfirmationMinutes < $1.targetConfirmationMinutes }
    }

    public var fastest: FeeRate {
        return feeRates.first!
    }

    public var cheapest: FeeRate {
        return feeRates.last!
    }
}

extension Transaction {
    public func fee(with estimate: FeeRate) -> (fee: Satoshis, byteCount: Int) {
        let data = self |> serialize
        let byteCount = data.count
        let fee = Double(byteCount) * estimate.satoshisPerVbyte
        let roundedFee = fee.rounded()
        let satoshis = UInt64(roundedFee) |> tagSatoshis
        return (satoshis, byteCount)
    }
}
