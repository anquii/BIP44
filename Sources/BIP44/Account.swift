import BIP32

public struct Account {
    public let name: String
    public let coinType: CoinType
    public let extendedKey: ExtendedKeyable
    public let isNeutered: Bool

    init(
        name: String,
        coinType: CoinType,
        extendedKey: ExtendedKeyable,
        isNeutered: Bool
    ) {
        self.name = name
        self.coinType = coinType
        self.extendedKey = extendedKey
        self.isNeutered = isNeutered
    }
}
