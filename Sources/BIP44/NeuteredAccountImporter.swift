import BIP32

public protocol NeuteredAccountImporting {
    func neuteredAccount(name: String, coinType: CoinType, base58CheckEncodedPublicKey: String) throws -> NeuteredAccount
}

public struct NeuteredAccountImporter {
    private static let depth = UInt8(3)

    private let serializedKeyDecoder: SerializedKeyDecoding

    public init(serializedKeyDecoder: SerializedKeyDecoding = SerializedKeyCoder()) {
        self.serializedKeyDecoder = serializedKeyDecoder
    }
}

// MARK: - NeuteredAccountImporting
extension NeuteredAccountImporter: NeuteredAccountImporting {
    public func neuteredAccount(name: String, coinType: CoinType, base58CheckEncodedPublicKey: String) throws -> NeuteredAccount {
        do {
            let serializedKey = try serializedKeyDecoder.decode(string: base58CheckEncodedPublicKey)
            guard serializedKey.depth == Self.depth else {
                throw AccountImporterError.invalidAccount
            }
            return NeuteredAccount(name: name, coinType: coinType, serializedKey: serializedKey)
        } catch {
            if error is AccountImporterError {
                throw error
            } else {
                throw AccountImporterError.invalidInput
            }
        }
    }
}
