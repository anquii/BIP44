import Foundation
import BIP32

public protocol PrivateAccountProviding {
    func privateAccount(seed: Data, configuration: AccountConfiguration) throws -> Account
}

public struct PrivateAccountProvider {
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

// MARK: - PrivateAccountProviding
extension PrivateAccountProvider: PrivateAccountProviding {
    public func privateAccount(seed: Data, configuration: AccountConfiguration) throws -> Account {
        do {
            let privateMasterKey = try privateMasterKeyDerivator.privateMasterKey(
                seed: seed
            )
            let privatePurposeChildKey = try privateChildKeyDerivator.privateChildKey(
                privateParentKey: privateMasterKey,
                index: Self.hardenedPurposeIndex
            )
            let privateCoinTypeChildKey = try privateChildKeyDerivator.privateChildKey(
                privateParentKey: privatePurposeChildKey,
                index: try keyIndexHardener.hardenedIndex(normalIndex: configuration.coinType.index)
            )
            let privateAccountChildKey = try privateChildKeyDerivator.privateChildKey(
                privateParentKey: privateCoinTypeChildKey,
                index: try keyIndexHardener.hardenedIndex(normalIndex: configuration.index)
            )
            return Account(
                name: configuration.name,
                coinType: configuration.coinType,
                extendedKey: privateAccountChildKey,
                keyAccessControl: .`private`
            )
        } catch {
            throw AccountProviderError.invalidAccount
        }
    }
}
