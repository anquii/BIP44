import BIP32

public protocol PublicAccountProviding {
    func publicAccount(privateAccount: Account) throws -> Account
}

public struct PublicAccountProvider {
    private let publicChildKeyDerivator: PublicChildKeyDerivating

    public init(publicChildKeyDerivator: PublicChildKeyDerivating = PublicChildKeyDerivator()) {
        self.publicChildKeyDerivator = publicChildKeyDerivator
    }
}

// MARK: - PublicAccountProviding
extension PublicAccountProvider: PublicAccountProviding {
    public func publicAccount(privateAccount: Account) throws -> Account {
        do {
            let publicAccountChildKey = try publicChildKeyDerivator.publicKey(
                privateKey: privateAccount.extendedKey
            )
            return Account(
                name: privateAccount.name,
                coinType: privateAccount.coinType,
                extendedKey: publicAccountChildKey,
                keyAccessControl: .`public`
            )
        } catch {
            throw AccountProviderError.invalidAccount
        }
    }
}
