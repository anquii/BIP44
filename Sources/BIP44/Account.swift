import BIP32

public struct Account {
    private static let depth = UInt8(3)

    public let name: String
    public let coinType: CoinType
    public let serializedKey: SerializedKeyable

    public init(
        name: String,
        coinType: CoinType,
        serializedKey: SerializedKeyable
    ) throws {
        guard serializedKey.depth == Self.depth else {
            throw AccountError.invalidInput
        }
        self.name = name
        self.coinType = coinType
        self.serializedKey = serializedKey
    }
}
