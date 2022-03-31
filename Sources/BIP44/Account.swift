import BIP32

public struct Account {
    public let name: String
    public let coinType: CoinType
    public let extendedKey: ExtendedKeyable
    public let keyAccessControl: KeyAccessControl

    init(
        name: String,
        coinType: CoinType,
        extendedKey: ExtendedKeyable,
        keyAccessControl: KeyAccessControl
    ) {
        self.name = name
        self.coinType = coinType
        self.extendedKey = extendedKey
        self.keyAccessControl = keyAccessControl
    }
}
