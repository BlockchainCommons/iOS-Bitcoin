//
//  ECPublicKey.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/1/18.
//

import CBitcoin

public let ecCompressedPublicKeySize: Int = { return _ecCompressedPublicKeySize() }()
public let ecUncompressedPublicKeySize: Int = { return _ecUncompressedPublicKeySize() }()

public class ECPublicKey {
    public let data: Data

    init(data: Data) {
        self.data = data
    }
}

public class ECCompressedPublicKey: ECPublicKey {
    public init(_ data: Data) throws {
        guard data.count == ecCompressedPublicKeySize else {
            throw BitcoinError.invalidDataSize
        }
        super.init(data: data)
    }
}

public class ECUncompressedPublicKey: ECPublicKey {
    public init(_ data: Data) throws {
        guard data.count == ecUncompressedPublicKeySize else {
            throw BitcoinError.invalidDataSize
        }
        super.init(data: data)
    }
}
