import Foundation
import BIP32

public protocol AddressProviding {
    func address(index: UInt32) -> (value: String, privateKey: Data)
    func address(index: UInt32) -> String
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
        self.account = account
        self.addressVersion = addressVersion
        self.addressDerivator = addressDerivator
        self.privateChildKeyDerivator = privateChildKeyDerivator
        self.publicChildKeyDerivator = publicChildKeyDerivator
        privateChangeChildKey = try! privateChildKeyDerivator.privateKey(
            privateParentKey: account.extendedKey,
            index: addressType.rawValue
        )
    }
}

// MARK: - AddressProviding
extension AddressProvider: AddressProviding {
    public func address(index: UInt32) -> (value: String, privateKey: Data) {
        let privateAddressIndexChildKey = try! privateChildKeyDerivator.privateKey(
            privateParentKey: privateChangeChildKey,
            index: index
        )
        let address = address(privateKey: privateAddressIndexChildKey)
        return (address, privateAddressIndexChildKey.key)
    }

    public func address(index: UInt32) -> String {
        let privateAddressIndexChildKey = try! privateChildKeyDerivator.privateKey(
            privateParentKey: privateChangeChildKey,
            index: index
        )
        return address(privateKey: privateAddressIndexChildKey)
    }
}

// MARK: - Helpers
fileprivate extension AddressProvider {
    func address(privateKey: ExtendedKeyable) -> String {
        let publicKey = try! publicChildKeyDerivator.publicKey(privateKey: privateKey)
        return addressDerivator.address(publicKey: publicKey.key, version: addressVersion)
    }
}
