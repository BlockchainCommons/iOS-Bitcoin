//
//  Base10.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/24/18.
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

import CBitcoin
import WolfFoundation
import WolfPipe

public enum Base10Tag { }
public typealias Base10 = Tagged<Base10Tag, String>
public func tagBase10(_ string: String) -> Base10 { return Base10(rawValue: string) }

public enum FragmentsTag { }
public typealias Fragments = Tagged<FragmentsTag, UInt64>
public func tagFragments(_ value: UInt64) -> Fragments { return Fragments(rawValue: value) }

public enum SatoshisTag { }
public typealias Satoshis = Tagged<SatoshisTag, UInt64>
public func tagSatoshis(_ amount: UInt64) -> Satoshis { return Satoshis(rawValue: amount) }

/// The number of decimal places in a bitcoin.
public let btcDecimalPlaces: Int = {
    return Int(_btcDecimalPlaces())
}()

/// The number of decimal places in a milli-bitcoin.
public let mbtcDecimalPlaces: Int = {
    return Int(_mbtcDecimalPlaces())
}()

/// The number of decimal places in a micro-bitcoin.
public let ubtcDecimalPlaces: Int = {
    return Int(_ubtcDecimalPlaces())
}()

/// Converts a Bitcoin amount to a string, following the BIP 21 grammar.
/// Avoids the rounding issues often seen with floating-point methods.
///
/// This is a curried function suitable for use with the pipe operator.
///
/// - parameter decimalPlaces: The location of the decimal point. The default
///   is zero, which treats the input as a normal integer.
public func toBase10(decimalPlaces: Int) -> (_ amount: Fragments) -> Base10 {
    return { amount in
        var bytes: UnsafeMutablePointer<Int8>!
        var count: Int = 0
        _encodeBase10(amount®, &bytes, &count, UInt8(decimalPlaces))
        return receiveString(bytes: bytes, count: count) |> tagBase10
    }
}

/// Converts a Bitcoin amount to a string, following the BIP 21 grammar.
/// Avoids the rounding issues often seen with floating-point methods.
///
/// This is a single-argument function suitable for use with the pipe operator.
///
/// - parameter amount: The amount to be encoded.
public func toBase10(_ amount: Fragments) -> Base10 {
    return amount |> toBase10(decimalPlaces: 0)
}

/// Converts a bitcoin amount (in satoshis) to a string.
///
/// This is a single-argument function suitable for use with the pipe operator.
///
/// - parameter satoshi: The amount (in satoshis) to be encoded.
public func satoshiToBTC(_ satoshi: Satoshis) -> Base10 {
    return satoshi® |> tagFragments |> toBase10(decimalPlaces: btcDecimalPlaces)
}

/// Converts a string to a Bitcoin amount according to the BIP 21 grammar.
///
/// This is a curried function suitable for use with the pipe operator.
///
/// Throws if the string fails to validate.
///
/// - parameter decimalPlaces: The location of the decimal point. The default
///   is zero, which treats the input as a normal integer.
/// - parameter strict: true to treat fractional results as an error,
///   or false to round them upwards.
public func toFragments(decimalPlaces: Int, strict: Bool = true) -> (_ base10: Base10) throws -> Fragments {
    return { base10 in
        var out: UInt64 = 0
        try base10®.withCString { (stringBytes) in
            try withUnsafeMutablePointer(to: &out) { (outPointer: UnsafeMutablePointer<UInt64>) in
                if let error = BitcoinError(rawValue: _decodeBase10(stringBytes, outPointer, decimalPlaces, strict)) {
                    throw error
                }
            }
        }
        return out |> tagFragments
    }
}

/// Converts a string to a Bitcoin amount according to the BIP 21 grammar.
///
/// This is a single-argument function suitable for use with the pipe operator.
///
/// Throws if the string fails to validate.
///
/// - parameter string: The amount to be decoded.
/// - returns: The amount.
public func toFragments(_ base10: Base10) throws -> Fragments {
    return try base10 |> toFragments(decimalPlaces: 0)
}

/// Converts a string in Bitcoin to an amount (in satoshis).
///
/// This is a single-argument function suitable for use with the pipe operator.
///
/// - parameter string: The amount (in BTC) to be decoded.
/// - returns: The amount (in satoshis).
public func btcToSatoshi(_ base10: Base10) throws -> Satoshis {
    return try base10 |> toFragments(decimalPlaces: btcDecimalPlaces) |> rawValue |> tagSatoshis
}
