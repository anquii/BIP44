import Foundation
import BIP32

public protocol AddressProviding {
    func address(index: UInt32) -> String
    func address(index: UInt32) -> (value: String, privateKey: Data)
}

public struct AddressProvider {
    private let privateChildKeyDerivator: PrivateChildKeyDerivating
    private let publicChildKeyDerivator: PublicChildKeyDerivating
    private let addressDerivator: KeyAddressDerivating
    private let extendedKey: ExtendedKeyable
    private let isKeyNeutered: Bool

    public init(
        privateChildKeyDerivator: PrivateChildKeyDerivating = PrivateChildKeyDerivator(),
        publicChildKeyDerivator: PublicChildKeyDerivating = PublicChildKeyDerivator(),
        addressDerivator: KeyAddressDerivating = KeyAddressDerivator(),
        addressType: AddressType,
        account: Account
    ) {
        self.privateChildKeyDerivator = privateChildKeyDerivator
        self.publicChildKeyDerivator = publicChildKeyDerivator
        self.addressDerivator = addressDerivator

        if account.isNeutered {
            extendedKey = try! publicChildKeyDerivator.publicKey(
                publicParentKey: account.extendedKey,
                index: addressType.rawValue
            )
        } else {
            extendedKey = try! privateChildKeyDerivator.privateKey(
                privateParentKey: account.extendedKey,
                index: addressType.rawValue
            )
        }
        isKeyNeutered = account.isNeutered
    }
}

// MARK: - AddressProviding
extension AddressProvider: AddressProviding {
    public func address(index: UInt32) -> String {
        preconditionFailure()
    }

    public func address(index: UInt32) -> (value: String, privateKey: Data) {
        preconditionFailure()
    }
}
