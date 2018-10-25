//
//  Base10.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/24/18.
//

import CBitcoin

public let btcDecimalPlaces: Int = {
    return Int(_btcDecimalPlaces())
}()

public let mbtcDecimalPlaces: Int = {
    return Int(_mbtcDecimalPlaces())
}()

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
public func toBase10WithDecimal(at decimalPlaces: Int) -> (_ amount: UInt64) -> String {
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
public func toBase10(_ amount: UInt64) -> String {
    return toBase10WithDecimal(at: 0)(amount)
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
public func base10ToAmountWithDecimal(at decimalPlaces: Int, strict: Bool = true) -> (String) throws -> UInt64 {
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

public func base10ToAmount(_ string: String) throws -> UInt64 {
    return try base10ToAmountWithDecimal(at: 0)(string)
}
