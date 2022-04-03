import Foundation
import BIP32

public protocol AccountProviding {
    func account(name: String, index: UInt32) throws -> Account
}

public struct AccountProvider {
    private static let hardenedPurposeIndex = UInt32(0x8000002C)

    private let coinType: CoinType
    private let privateMasterKeyDerivator: PrivateMasterKeyDerivating
    private let privateChildKeyDerivator: PrivateChildKeyDerivating
    private let keyIndexHardener: KeyIndexHardening
    private let privateCoinTypeChildKey: ExtendedKeyable

    public init(
        seed: Data,
        coinType: CoinType,
        privateMasterKeyDerivator: PrivateMasterKeyDerivating = PrivateMasterKeyDerivator(),
        privateChildKeyDerivator: PrivateChildKeyDerivating = PrivateChildKeyDerivator(),
        keyIndexHardener: KeyIndexHardening = KeyIndexHardener()
    ) throws {
        do {
            let privateMasterKey = try privateMasterKeyDerivator.privateKey(
                seed: seed
            )
            let privatePurposeChildKey = try privateChildKeyDerivator.privateKey(
                privateParentKey: privateMasterKey,
                index: Self.hardenedPurposeIndex
            )
            privateCoinTypeChildKey = try privateChildKeyDerivator.privateKey(
                privateParentKey: privatePurposeChildKey,
                index: try keyIndexHardener.hardenedIndex(normalIndex: coinType.index)
            )
        } catch {
            throw AccountProviderError.invalidInput
        }
        self.coinType = coinType
        self.privateMasterKeyDerivator = privateMasterKeyDerivator
        self.privateChildKeyDerivator = privateChildKeyDerivator
        self.keyIndexHardener = keyIndexHardener
    }
}

// MARK: - AccountProviding
extension AccountProvider: AccountProviding {
    public func account(name: String, index: UInt32) throws -> Account {
        do {
            let privateAccountChildKey = try privateChildKeyDerivator.privateKey(
                privateParentKey: privateCoinTypeChildKey,
                index: try keyIndexHardener.hardenedIndex(normalIndex: index)
            )
            return Account(
                name: name,
                coinType: coinType,
                extendedKey: privateAccountChildKey,
                isNeutered: false
            )
        } catch {
            throw AccountProviderError.invalidAccount
        }
    }
}
