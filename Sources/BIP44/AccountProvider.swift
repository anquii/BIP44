import Foundation
import BIP32

public protocol AccountProviding {
    func account(seed: Data, configuration: AccountConfiguration) throws -> Account
}

public struct AccountProvider {
    private static let hardenedPurposeIndex = UInt32(0x8000002C)

    private let privateMasterKeyDerivator: PrivateMasterKeyDerivating
    private let privateChildKeyDerivator: PrivateChildKeyDerivating
    private let keyIndexHardener: KeyIndexHardening

    public init(
        privateMasterKeyDerivator: PrivateMasterKeyDerivating = PrivateMasterKeyDerivator(),
        privateChildKeyDerivator: PrivateChildKeyDerivating = PrivateChildKeyDerivator(),
        keyIndexHardener: KeyIndexHardening = KeyIndexHardener()
    ) {
        self.privateMasterKeyDerivator = privateMasterKeyDerivator
        self.privateChildKeyDerivator = privateChildKeyDerivator
        self.keyIndexHardener = keyIndexHardener
    }
}

// MARK: - AccountProviding
extension AccountProvider: AccountProviding {
    public func account(seed: Data, configuration: AccountConfiguration) throws -> Account {
        do {
            let privateMasterKey = try privateMasterKeyDerivator.privateKey(
                seed: seed
            )
            let privatePurposeChildKey = try privateChildKeyDerivator.privateKey(
                privateParentKey: privateMasterKey,
                index: Self.hardenedPurposeIndex
            )
            let privateCoinTypeChildKey = try privateChildKeyDerivator.privateKey(
                privateParentKey: privatePurposeChildKey,
                index: try keyIndexHardener.hardenedIndex(normalIndex: configuration.coinType.index)
            )
            let privateAccountChildKey = try privateChildKeyDerivator.privateKey(
                privateParentKey: privateCoinTypeChildKey,
                index: try keyIndexHardener.hardenedIndex(normalIndex: configuration.index)
            )
            return Account(
                name: configuration.name,
                coinType: configuration.coinType,
                extendedKey: privateAccountChildKey,
                isNeutered: false
            )
        } catch {
            throw AccountProviderError.invalidAccount
        }
    }
}
