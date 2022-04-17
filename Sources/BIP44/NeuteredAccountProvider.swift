import BIP32

public protocol NeuteredAccountProviding {
    func neuteredAccount(account: Account, version: UInt32) throws -> NeuteredAccount
}

public struct NeuteredAccountProvider {
    private let publicChildKeyDerivator: PublicChildKeyDerivating
    private let keySerializer: KeySerializing

    public init(
        publicChildKeyDerivator: PublicChildKeyDerivating = PublicChildKeyDerivator(),
        keySerializer: KeySerializing = KeySerializer()
    ) {
        self.publicChildKeyDerivator = publicChildKeyDerivator
        self.keySerializer = keySerializer
    }
}

// MARK: - NeuteredAccountProviding
extension NeuteredAccountProvider: NeuteredAccountProviding {
    public func neuteredAccount(account: Account, version: UInt32) throws -> NeuteredAccount {
        do {
            let privateAccountChildKey = ExtendedKey(
                serializedKey: account.serializedKey,
                accessControl: .`private`
            )
            let publicAccountChildKey = try publicChildKeyDerivator.publicKey(
                privateKey: privateAccountChildKey
            )
            let publicAccountChildKeyAttributes = ChildKeyAttributes(
                accessControl: .`public`,
                version: version,
                depth: account.serializedKey.depth,
                parentKeyFingerprint: account.serializedKey.parentKeyFingerprint,
                index: account.serializedKey.index
            )
            let publicAccountSerializedChildKey = try keySerializer.serializedKey(
                extendedKey: publicAccountChildKey,
                attributes: publicAccountChildKeyAttributes
            )
            return try NeuteredAccount(
                name: account.name,
                coinType: account.coinType,
                serializedKey: publicAccountSerializedChildKey
            )
        } catch {
            throw AccountError.invalidInput
        }
    }
}
