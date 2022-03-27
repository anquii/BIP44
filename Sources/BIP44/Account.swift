import BIP32

public struct Account {
    public let name: String
    public let coinType: CoinType
    private let privateKey: ExtendedKeyable

    public init(
        name: String,
        coinType: CoinType,
        privateKey: ExtendedKeyable
    ) {
        self.name = name
        self.coinType = coinType
        self.privateKey = privateKey
    }
}
