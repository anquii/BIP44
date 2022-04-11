import Foundation
import BIP32

public protocol AddressProviding {
    func address(index: UInt32) -> String
    func addressAndPrivateKey(index: UInt32) -> (address: String, privateKey: Data)
}

public struct AddressProvider {
    private let account: Account
    private let addressVersion: UInt8
    private let addressDerivator: KeyAddressDerivating
    private let privateChildKeyDerivator: PrivateChildKeyDerivating
    private let publicChildKeyDerivator: PublicChildKeyDerivating
    private let privateChangeChildKey: ExtendedKeyable

    public init(
        account: Account,
        addressType: AddressType,
        addressVersion: UInt8,
        addressDerivator: KeyAddressDerivating = KeyAddressDerivator(),
        privateChildKeyDerivator: PrivateChildKeyDerivating = PrivateChildKeyDerivator(),
        publicChildKeyDerivator: PublicChildKeyDerivating = PublicChildKeyDerivator()
    ) {
        let privateAccountKey = ExtendedKey(serializedKey: account.serializedKey)
        privateChangeChildKey = try! privateChildKeyDerivator.privateKey(
            privateParentKey: privateAccountKey,
            index: addressType.rawValue
        )
        self.account = account
        self.addressVersion = addressVersion
        self.addressDerivator = addressDerivator
        self.privateChildKeyDerivator = privateChildKeyDerivator
        self.publicChildKeyDerivator = publicChildKeyDerivator
    }
}

// MARK: - AddressProviding
extension AddressProvider: AddressProviding {
    public func address(index: UInt32) -> String {
        addressAndPrivateKey(index: index).address
    }

    public func addressAndPrivateKey(index: UInt32) -> (address: String, privateKey: Data) {
        let privateAddressIndexChildKey = try! privateChildKeyDerivator.privateKey(
            privateParentKey: privateChangeChildKey,
            index: index
        )
        let publicAddressIndexChildKey = try! publicChildKeyDerivator.publicKey(privateKey: privateAddressIndexChildKey)
        let address = addressDerivator.address(publicKey: publicAddressIndexChildKey.key, version: addressVersion)
        return (address, privateAddressIndexChildKey.key)
    }
}
