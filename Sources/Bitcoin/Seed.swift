//
//  Seed.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/28/18.
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
    let extraBits = bits % 8
    let count = (bits / 8) + (extraBits > 0 ? 1 : 0)
    var s = seed(count: count, using: &generator)
    if extraBits > 0 {
        let mask = UInt8(0xFF) << (8 - extraBits)
        s[count - 1] = s.last! & mask
    }
    return s
}

public func seed(bits: Int) -> Data {
    return seed(bits: bits, using: &randomNumberGenerator)
}

public func seed() -> Data {
    return seed(count: minimumSeedSize)
}
