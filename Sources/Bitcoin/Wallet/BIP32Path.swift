//
//  BIP32Path.swift
//  Bitcoin
//
//  Created by Wolf McNally on 2/2/19.
//

public struct BIP32Path {
    public let components: [PathComponent]

    public init(_ components: [PathComponent]) {
        self.components = components
    }

    public init(_ string: String) throws {
        var componentStrings = string.split(separator: "/").map { String($0) }
        guard !componentStrings.isEmpty else { throw BitcoinError.invalidFormat }
        if componentStrings.first! == "m" {
            componentStrings = Array(componentStrings.dropFirst())
        }
        components = try componentStrings.map { try PathComponent($0) }
    }

    public struct PathComponent {
        public let index: Int
        public let isHardened: Bool

        public init(index: Int, isHardened: Bool) {
            self.index = index
            self.isHardened = isHardened
        }

        public init(_ string: String) throws {
            guard !string.isEmpty else { throw BitcoinError.invalidFormat }
            let s: String
            if string.last! == "'" {
                isHardened = true
                s = String(string.dropLast())
            } else {
                isHardened = false
                s = string
            }
            guard let i = Int(s) else { throw BitcoinError.invalidFormat }
            index = i
        }
    }
}

extension BIP32Path: CustomStringConvertible {
    public var description: String {
        return components.map({ $0.description }).joined(separator: "/")
    }
}

extension BIP32Path: ExpressibleByArrayLiteral {
    public init(arrayLiteral: PathComponent...) {
        self.init(arrayLiteral)
    }
}

extension BIP32Path.PathComponent: ExpressibleByStringLiteral {
    public init(stringLiteral: String) {
        try! self.init(stringLiteral)
    }
}

extension BIP32Path.PathComponent: CustomStringConvertible {
    public var description: String {
        if isHardened {
            return "\(index)'"
        } else {
            return "\(index)"
        }
    }
}
