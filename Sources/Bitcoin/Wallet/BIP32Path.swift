//
//  BIP32Path.swift
//  Bitcoin
//
//  Created by Wolf McNally on 2/2/19.
//

public struct BIP32Path {
    public let components: [Component]

    public init(_ components: [Component]) {
        self.components = components
    }

    public init(_ string: String) throws {
        let componentStrings = string.split(separator: "/").map { String($0) }
        guard !componentStrings.isEmpty else { throw BitcoinError.invalidFormat }
        components = try componentStrings.map { component in
            guard let c = Component(component) else {
                throw BitcoinError.invalidFormat
            }
            return c
        }
    }

    public enum Component {
        case master
        case index(Index)

        init?(_ string: String) {
            if string == "m" {
                self = .master
            } else {
                if let indexComponent = try? Index(string) {
                    self = .index(indexComponent)
                } else {
                    return nil
                }
            }
        }
    }

    public struct Index {
        public let index: Int
        public let isHardened: Bool

        public init(_ index: Int, isHardened: Bool) {
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

    public func appending(_ path: BIP32Path) -> BIP32Path {
        var c = components
        c.append(contentsOf: path.components)
        return BIP32Path(c)
    }
}

extension BIP32Path: CustomStringConvertible {
    public var description: String {
        return components.map({ $0.description }).joined(separator: "/")
    }
}

extension BIP32Path: ExpressibleByArrayLiteral {
    public init(arrayLiteral: Component...) {
        self.init(arrayLiteral)
    }
}

extension BIP32Path.Component: ExpressibleByStringLiteral {
    public init(stringLiteral: String) {
        self.init(stringLiteral)!
    }
}

extension BIP32Path.Component: CustomStringConvertible {
    public var description: String {
        switch self {
        case .master:
            return "m"
        case .index(let i):
            if i.isHardened {
                return "\(i.index)'"
            } else {
                return "\(i.index)"
            }
        }
    }
}
