//
//  HDKeyPurpose.swift
//  Bitcoin
//
//  Created by Wolf McNally on 2/2/19.
//

public enum HDKeyPurpose: Int {
    case defaultAccount = 0 // BIP32
    case accountTree = 44 // BIP44
    case multisig = 45 // BIP45
    case p2wpkhInP2sh = 49 // BIP49
    case p2wpkh = 84 // BIP84
}
