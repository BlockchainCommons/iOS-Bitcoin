//
//  Base10.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/24/18.
//

import CBitcoin

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
public func encodeBase10(decimalPlaces: Int) -> (_ amount: UInt64) -> String {
    return { amount in
        var bytes: UnsafeMutablePointer<Int8>!
        var count: Int = 0
        _encodeBase10(amount, &bytes, &count, UInt8(decimalPlaces))
        return receiveString(bytes: bytes, count: count)
    }
}

/// Converts a Bitcoin amount to a string, following the BIP 21 grammar.
/// Avoids the rounding issues often seen with floating-point methods.
///
/// This is a single-argument function suitable for use with the pipe operator.
///
/// - parameter amount: The amount to be encoded.
public func encodeBase10(_ amount: UInt64) -> String {
    return encodeBase10(decimalPlaces: 0)(amount)
}

/// Converts a bitcoin amount (in satoshis) to a string.
///
/// This is a single-argument function suitable for use with the pipe operator.
///
/// - parameter satoshi: The amount (in satoshis) to be encoded.
public func satoshiToBTC(_ satoshi: UInt64) -> String {
    return encodeBase10(decimalPlaces: btcDecimalPlaces)(satoshi)
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
public func decodeBase10(decimalPlaces: Int, strict: Bool = true) -> (String) throws -> UInt64 {
    return { string in
        var out: UInt64 = 0
        let success = string.withCString { (stringBytes) in
            withUnsafeMutablePointer(to: &out) { (outPointer: UnsafeMutablePointer<UInt64>) in
                _decodeBase10(stringBytes, outPointer, decimalPlaces, strict)
            }
        }
        guard success else {
            throw BitcoinError("Invalid base10 format.")
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
public func decodeBase10(_ string: String) throws -> UInt64 {
    return try decodeBase10(decimalPlaces: 0)(string)
}

/// Converts a string in Bitcoin to an amount (in satoshis).
///
/// This is a single-argument function suitable for use with the pipe operator.
///
/// - parameter string: The amount (in BTC) to be decoded.
/// - returns: The amount (in satoshis).
public func btcToSatoshi(_ string: String) throws -> UInt64 {
    return try decodeBase10(decimalPlaces: btcDecimalPlaces)(string)
}
