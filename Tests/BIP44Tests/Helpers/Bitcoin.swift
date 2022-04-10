import BIP44

struct Bitcoin: CoinType {
    let name = "Bitcoin"
    let symbol = "BTC"
    let index = UInt32(0)
}
