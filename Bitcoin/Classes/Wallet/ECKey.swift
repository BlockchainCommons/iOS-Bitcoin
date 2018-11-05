//
//  ECKey.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/4/18.
//

import WolfPipe

public protocol ECKey {
    var data: Data { get }
}

public func base16Encode(_ key: ECKey) -> String {
    return key.data |> base16Encode
}
