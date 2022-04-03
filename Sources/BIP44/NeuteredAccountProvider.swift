import BIP32

public protocol NeuteredAccountProviding {
    func neuteredAccount(account: Account) -> NeuteredAccount
}

public struct NeuteredAccountProvider {
    private let publicChildKeyDerivator: PublicChildKeyDerivating

    public init(publicChildKeyDerivator: PublicChildKeyDerivating = PublicChildKeyDerivator()) {
        self.publicChildKeyDerivator = publicChildKeyDerivator
    }
}

// MARK: - NeuteredAccountProviding
extension NeuteredAccountProvider: NeuteredAccountProviding {
    public func neuteredAccount(account: Account) -> NeuteredAccount {
        let publicAccountChildKey = try! publicChildKeyDerivator.publicKey(
            privateKey: account.extendedKey
        )
        return NeuteredAccount(
            name: account.name,
            coinType: account.coinType,
            extendedKey: publicAccountChildKey
        )
    }
}
