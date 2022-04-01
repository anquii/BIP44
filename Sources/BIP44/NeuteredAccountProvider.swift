import BIP32

public protocol NeuteredAccountProviding {
    func neuteredAccount(account: Account) throws -> Account
}

public struct NeuteredAccountProvider {
    private let publicChildKeyDerivator: PublicChildKeyDerivating

    public init(publicChildKeyDerivator: PublicChildKeyDerivating = PublicChildKeyDerivator()) {
        self.publicChildKeyDerivator = publicChildKeyDerivator
    }
}

// MARK: - NeuteredAccountProviding
extension NeuteredAccountProvider: NeuteredAccountProviding {
    public func neuteredAccount(account: Account) throws -> Account {
        do {
            let publicAccountChildKey = try publicChildKeyDerivator.publicKey(
                privateKey: account.extendedKey
            )
            return Account(
                name: account.name,
                coinType: account.coinType,
                extendedKey: publicAccountChildKey
            )
        } catch {
            throw AccountProviderError.invalidAccount
        }
    }
}
