struct InvalidNeuteredAccountTestVector {
    static let base58CheckEncodedKey =
        """
        xpub6DpDuWtK8rCaaK4cZiNFHZKZcbzLW5LzX
        AUvvxndzedgqX4BZQURgvoAAvaLNrv7gXo2QJ
        ACa7Mj2KPeJjBWN9QV2TaHJXTmY3CuXaZGUZk
        """
        .components(separatedBy: .newlines)
        .joined()

    static let name = "Savings"
    static let coinType = Bitcoin()

    private init() {}
}
