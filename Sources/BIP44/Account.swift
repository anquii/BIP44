import BIP32

public struct Account {
    public let name: String
    public let coinType: CoinType
    public let privateKey: ExtendedKeyable

    init(
        name: String,
        coinType: CoinType,
        privateKey: ExtendedKeyable
    ) {
        self.name = name
        self.coinType = coinType
        self.privateKey = privateKey
    }
}
