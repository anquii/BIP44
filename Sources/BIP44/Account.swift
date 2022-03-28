import BIP32

public struct Account {
    public let name: String
    public let coinType: CoinType
    public let extendedKey: ExtendedKeyable

    init(
        name: String,
        coinType: CoinType,
        extendedKey: ExtendedKeyable
    ) {
        self.name = name
        self.coinType = coinType
        self.extendedKey = extendedKey
    }
}
