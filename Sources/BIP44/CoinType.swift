public struct CoinType {
    public let name: String
    public let symbol: String
    public let index: UInt32

    public init(
        name: String,
        symbol: String,
        index: UInt32
    ) {
        self.name = name
        self.symbol = symbol
        self.index = index
    }
}
