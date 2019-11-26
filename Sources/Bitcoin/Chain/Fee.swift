//
//  Fee.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/24/19.
//  Copyright © 2019 Blockchain Commons. All rights reserved.
//

import Foundation
import WolfCore

public struct FeeEstimate: Codable {
    public let targetConfirmationMinutes: Int
    public let satoshisPerVbyte: Double

    public init(targetConfirmationMinutes: Int, satoshisPerVbyte: Double) {
        self.targetConfirmationMinutes = targetConfirmationMinutes
        self.satoshisPerVbyte = satoshisPerVbyte
    }
}

public struct FeeSchedule: Codable {
    // Array of fee estimates sorted ascending by confirmation time.
    public let feeEstimates: [FeeEstimate]

    public init(_ feeEstimates: [FeeEstimate]) {
        self.feeEstimates = feeEstimates.sorted { $0.targetConfirmationMinutes < $1.targetConfirmationMinutes }
    }

    public var fastest: FeeEstimate {
        return feeEstimates.first!
    }

    public var cheapest: FeeEstimate {
        return feeEstimates.last!
    }
}

extension Transaction {
    public func fee(with estimate: FeeEstimate) -> (fee: Satoshis, byteCount: Int) {
        let data = self |> serialize
        let byteCount = data.count
        let fee = Double(byteCount) * estimate.satoshisPerVbyte
        let roundedFee = fee.rounded()
        let satoshis = UInt64(roundedFee) |> tagSatoshis
        return (satoshis, byteCount)
    }
}
