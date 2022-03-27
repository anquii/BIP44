public struct AccountConfiguration {
    public let name: String
    public let coinType: CoinType
    public let index: UInt32

    public init(
        name: String,
        coinType: CoinType,
        index: UInt32
    ) {
        self.name = name
        self.coinType = coinType
        self.index = index
    }
}
