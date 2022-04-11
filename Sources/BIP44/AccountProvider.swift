import Foundation
import BIP32

public protocol AccountProviding {
    func account(configuration: AccountConfiguration) throws -> Account
}

public struct AccountProvider {
    private static let depth = UInt8(3)
    private static let hardenedPurposeIndex = UInt32(0x8000002C)

    private let coinType: CoinType
    private let privateChildKeyDerivator: PrivateChildKeyDerivating
    private let keyIndexHardener: KeyIndexHardening
    private let keySerializer: KeySerializing
    private let privateCoinTypeChildKey: ExtendedKeyable
    private let publicCoinTypeChildKeyFingerprint: UInt32

    public init(
        seed: Data,
        coinType: CoinType,
        privateMasterKeyDerivator: PrivateMasterKeyDerivating = PrivateMasterKeyDerivator(),
        privateChildKeyDerivator: PrivateChildKeyDerivating = PrivateChildKeyDerivator(),
        publicChildKeyDerivator: PublicChildKeyDerivating = PublicChildKeyDerivator(),
        keyFingerprintDerivator: KeyFingerprintDerivating = KeyFingerprintDerivator(),
        keyIndexHardener: KeyIndexHardening = KeyIndexHardener(),
        keySerializer: KeySerializing = KeySerializer()
    ) throws {
        do {
            let privateMasterKey = try privateMasterKeyDerivator.privateKey(seed: seed)
            let privatePurposeChildKey = try privateChildKeyDerivator.privateKey(
                privateParentKey: privateMasterKey,
                index: Self.hardenedPurposeIndex
            )
            privateCoinTypeChildKey = try privateChildKeyDerivator.privateKey(
                privateParentKey: privatePurposeChildKey,
                index: try keyIndexHardener.hardenedIndex(normalIndex: coinType.index)
            )
            let publicCoinTypeChildKey = try publicChildKeyDerivator.publicKey(privateKey: privateCoinTypeChildKey)
            publicCoinTypeChildKeyFingerprint = keyFingerprintDerivator.fingerprint(publicKey: publicCoinTypeChildKey.key)
        } catch {
            throw AccountProviderError.invalidInput
        }
        self.coinType = coinType
        self.privateChildKeyDerivator = privateChildKeyDerivator
        self.keyIndexHardener = keyIndexHardener
        self.keySerializer = keySerializer
    }
}

// MARK: - AccountProviding
extension AccountProvider: AccountProviding {
    public func account(configuration: AccountConfiguration) throws -> Account {
        do {
            let hardenedIndex = try keyIndexHardener.hardenedIndex(normalIndex: configuration.index)
            let privateAccountChildKey = try privateChildKeyDerivator.privateKey(
                privateParentKey: privateCoinTypeChildKey,
                index: hardenedIndex
            )
            let privateAccountChildKeyAttributes = ChildKeyAttributes(
                accessControl: .`private`,
                version: configuration.version,
                depth: Self.depth,
                parentKeyFingerprint: publicCoinTypeChildKeyFingerprint,
                index: hardenedIndex
            )
            let privateAccountSerializedChildKey = try keySerializer.serializedKey(
                extendedKey: privateAccountChildKey,
                attributes: privateAccountChildKeyAttributes
            )
            return Account(
                name: configuration.name,
                coinType: coinType,
                serializedKey: privateAccountSerializedChildKey
            )
        } catch {
            throw AccountProviderError.invalidInput
        }
    }
}
