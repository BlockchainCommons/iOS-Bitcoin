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
import WolfPipe

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
public func base10Encode(decimalPlaces: Int) -> (_ amount: UInt64) -> String {
    return { amount in
        var bytes: UnsafeMutablePointer<Int8>!
        var count: Int = 0
        _base10Encode(amount, &bytes, &count, UInt8(decimalPlaces))
        return receiveString(bytes: bytes, count: count)
    }
}

/// Converts a Bitcoin amount to a string, following the BIP 21 grammar.
/// Avoids the rounding issues often seen with floating-point methods.
///
/// This is a single-argument function suitable for use with the pipe operator.
///
/// - parameter amount: The amount to be encoded.
public func base10Encode(_ amount: UInt64) -> String {
    return amount |> base10Encode(decimalPlaces: 0)
}

/// Converts a bitcoin amount (in satoshis) to a string.
///
/// This is a single-argument function suitable for use with the pipe operator.
///
/// - parameter satoshi: The amount (in satoshis) to be encoded.
public func satoshiToBTC(_ satoshi: UInt64) -> String {
    return satoshi |> base10Encode(decimalPlaces: btcDecimalPlaces)
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
public func base10Decode(decimalPlaces: Int, strict: Bool = true) -> (_ string: String) throws -> UInt64 {
    return { string in
        var out: UInt64 = 0
        try string.withCString { (stringBytes) in
            try withUnsafeMutablePointer(to: &out) { (outPointer: UnsafeMutablePointer<UInt64>) in
                if let error = BitcoinError(rawValue: _base10Decode(stringBytes, outPointer, decimalPlaces, strict)) {
                    throw error
                }
            }
        }
        return out
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
public func base10Decode(_ string: String) throws -> UInt64 {
    return try string |> base10Decode(decimalPlaces: 0)
}

/// Converts a string in Bitcoin to an amount (in satoshis).
///
/// This is a single-argument function suitable for use with the pipe operator.
///
/// - parameter string: The amount (in BTC) to be decoded.
/// - returns: The amount (in satoshis).
public func btcToSatoshi(_ string: String) throws -> UInt64 {
    return try string |> base10Decode(decimalPlaces: btcDecimalPlaces)
}
