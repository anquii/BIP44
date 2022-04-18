import BIP32

public protocol AccountImporting {
    func account(name: String, coinType: CoinType, base58CheckEncodedPrivateKey: String) throws -> Account
}

public struct AccountImporter {
    private static let depth = UInt8(3)

    private let serializedKeyDecoder: SerializedKeyDecoding

    public init(serializedKeyDecoder: SerializedKeyDecoding = SerializedKeyCoder()) {
        self.serializedKeyDecoder = serializedKeyDecoder
    }
}

// MARK: - AccountImporting
extension AccountImporter: AccountImporting {
    public func account(name: String, coinType: CoinType, base58CheckEncodedPrivateKey: String) throws -> Account {
        do {
            let serializedKey = try serializedKeyDecoder.decode(string: base58CheckEncodedPrivateKey)
            guard serializedKey.depth == Self.depth else {
                throw AccountImporterError.invalidAccount
            }
            return Account(name: name, coinType: coinType, serializedKey: serializedKey)
        } catch {
            if error is AccountImporterError {
                throw error
            } else {
                throw AccountImporterError.invalidInput
            }
        }
    }
}
