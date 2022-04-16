import Foundation
import BIP44

struct AddressTestVector: Decodable {
    static let type = AddressType.`external`
    static let version = UInt8(0)
    static let compressedWIFEncodedPrivateKeyVersion = UInt8(128)

    let index: UInt32
    let compressedWIFEncodedPrivateKey: String
    let address: String
}
