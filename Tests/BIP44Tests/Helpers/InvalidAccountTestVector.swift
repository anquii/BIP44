struct InvalidAccountTestVector {
    static let base58CheckEncodedKey =
        """
        xprv9zpsW1MRJUeHMpz9TgqEvRNq4a9r6cd99
        wZL8aP2SK6hxij31sAB98UgKgLbyXo1HCAGS9
        ZK6STEk6Ljr8i1rdELUGGYs5y3oevPiotPsyB
        """
        .components(separatedBy: .newlines)
        .joined()

    static let name = "Savings"
    static let coinType = Bitcoin()

    private init() {}
}
