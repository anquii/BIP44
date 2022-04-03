import BIP32

public protocol NeuteredAccountAddressProviding {
    func address(index: UInt32) -> String
}

public struct NeuteredAccountAddressProvider {
    private let neuteredAccount: NeuteredAccount
    private let addressVersion: UInt8
    private let addressDerivator: KeyAddressDerivating
    private let publicChildKeyDerivator: PublicChildKeyDerivating
    private let publicChangeChildKey: ExtendedKeyable

    public init(
        neuteredAccount: NeuteredAccount,
        addressType: AddressType,
        addressVersion: UInt8,
        addressDerivator: KeyAddressDerivating = KeyAddressDerivator(),
        publicChildKeyDerivator: PublicChildKeyDerivating = PublicChildKeyDerivator()
    ) {
        self.neuteredAccount = neuteredAccount
        self.addressVersion = addressVersion
        self.addressDerivator = addressDerivator
        self.publicChildKeyDerivator = publicChildKeyDerivator
        publicChangeChildKey = try! publicChildKeyDerivator.publicKey(
            publicParentKey: neuteredAccount.extendedKey,
            index: addressType.rawValue
        )
    }
}

// MARK: - NeuteredAccountAddressProviding
extension NeuteredAccountAddressProvider: NeuteredAccountAddressProviding {
    public func address(index: UInt32) -> String {
        let publicAddressIndexChildKey = try! publicChildKeyDerivator.publicKey(
            publicParentKey: publicChangeChildKey,
            index: index
        )
        return addressDerivator.address(
            publicKey: publicAddressIndexChildKey.key,
            version: addressVersion
        )
    }
}
