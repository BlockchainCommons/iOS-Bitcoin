import CBitcoin

public var minimumSeedSize: Int = {
    return _minimumSeedSize()
}()

public func hdNew(version: UInt32) -> (_ seed: Data) throws -> String {
    return { seed in
        guard seed.count >= minimumSeedSize else {
            throw BitcoinError("Seed size too small")
        }
        var key: UnsafeMutablePointer<Int8>!
        var keyLength: Int = 0
        let success = seed.withUnsafeBytes { (seedBytes: UnsafePointer<UInt8>) in
            _hdNew(seedBytes, seed.count, version, &key, &keyLength)
        }
        guard success else {
            throw BitcoinError("Invalid seed")
        }
        return receiveString(bytes: key, count: keyLength)
    }
}
