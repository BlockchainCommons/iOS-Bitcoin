# Libbitcoin Explorer Functions

[https://github.com/libbitcoin/libbitcoin-explorer/wiki](https://github.com/libbitcoin/libbitcoin-explorer/wiki)

## Wallet Commands

* ✅ ec-new (newECPrivateKey, toECPrivateKey)
* ✅ ec-to-address (toECPaymentAddress)
* ✅ ec-to-public (toECPublicKey)
* ✅ ec-to-wif (toWIF)
* electrum-new
* electrum-to-seed
* ✅ hd-new (newHDPrivateKey)
* ✅ hd-private (deriveHDPrivateKey)
* ✅ hd-public (deriveHDPublicKey)
* ✅ hd-to-ec (toECKey)
* ✅ hd-to-public (toHDPublicKey)
* ✅ mnemonic-new (newMnemonic)
* ✅ mnemonic-to-seed (mnemonicToSeed)
* qrcode
* ✅ seed (seed)
* uri-decode
* uri-encode
* ✅ wif-to-ec (wifToECPrivateKey)
* ✅ wif-to-public (wifToECPrivateKey |> toECPublicKey)

## Key Encryption Commands

* ec-to-ek
* ek-address
* ek-new
* ek-public
* ek-public-to-address
* ek-public-to-ec
* ek-to-address
* ek-to-ec
* token-new

## Stealth Commands

* stealth-decode
* stealth-encode
* stealth-public
* stealth-secret
* stealth-shared

## Messaging Commands

* ✅ message-sign (messageSign)
* ✅ message-validate (messageValidate)

## Transaction Commands

* input-set
* input-sign
* input-validate
* script-decode
* script-encode
* script-to-address
* tx-decode
* tx-encode
* tx-sign

## Online Commands

* fetch-balance
* fetch-block
* fetch-header
* fetch-height
* fetch-history
* fetch-public-key
* fetch-stealth
* fetch-tx
* fetch-tx-index
* fetch-utxo
* send-tx
* send-tx-node
* send-tx-p2p
* subscribe-block
* subscribe-tx
* validate-tx
* watch-address
* watch-stealth
* watch-tx

## Encoding Commands

* ✅ address-encode (addressEncode)
* ✅ address-decode (addressDecode)
* address-embed
* ✅ (bitcoinHashEncode)
* ✅ (bitcoinHashDecode)
* ✅ (encodeBase10)
* ✅ (decodeBase10)
* ✅ base16-encode (base16Encode)
* ✅ base16-decode (base16Decode)
* ✅ (base32Encode)
* ✅ (base32Decode)
* ✅ base58-encode (base58Encode)
* ✅ base58-decode (base58Decode)
* ✅ base64-encode (base64Encode)
* ✅ base64-decode (base64Decode)
* ✅ (base85Encode)
* ✅ (base85Decode)
* ✅ base58check-encode (base58CheckEncode)
* ✅ base58check-decode (base58CheckDecode)
* wrap-encode
* wrap-decode

## Hash Commands

* ✅ bitcoin160 (bitcoin160)
* ✅ bitcoin256 (bitcoin256)
* ✅ ripemd160 (ripemd160)
* ✅ sha160 (sha160)
* ✅ sha256 (sha256)
* ✅ sha512 (sha512)
* ✅ (sha256HMAC)
* ✅ (sha512HMAC)
* ✅ (pkcs5PBKDF2HMACSHA512)

## Math Commands

* ✅ btc-to-satoshi (btcToSatoshi)
* ✅ satoshi-to-btc (satoshiToBTC)
* cert-new
* cert-public
* ec-add
* ec-add-secrets
* ec-multiply
* ec-multiply-secrets
