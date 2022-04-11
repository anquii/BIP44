import BIP32

public struct NeuteredAccount {
    public let name: String
    public let coinType: CoinType
    public let serializedKey: SerializedKeyable
}
