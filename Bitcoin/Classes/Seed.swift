//
//  Seed.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/28/18.
//

import Foundation
import Security

private var randomNumberGenerator = SecureRandomNumberGenerator()

public final class SecureRandomNumberGenerator: RandomNumberGenerator {
    public func next() -> UInt64 {
        var result: UInt64 = 0
        precondition(SecRandomCopyBytes(kSecRandomDefault, MemoryLayout<UInt64>.size, &result) == errSecSuccess)
        return result
    }
}

public func seed<T>(count: Int, using generator: inout T) -> Data where T: RandomNumberGenerator {
    var data = Data()
    for _ in 0 ..< count {
        data.append(UInt8.random(in: UInt8.min ... UInt8.max, using: &generator))
    }
    return data
}

public func seed(count: Int) -> Data {
    return seed(count: count, using: &randomNumberGenerator)
}

public func seed<T>(bits: Int, using generator: inout T) -> Data where T: RandomNumberGenerator {
    let count = (bits / 8) + ((bits % 8) > 0 ? 1 : 0)
    return seed(count: count, using: &generator)
}

public func seed(bits: Int) -> Data {
    return seed(bits: bits, using: &randomNumberGenerator)
}
