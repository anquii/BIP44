struct AccountTestVector {
    static let hexEncodedSeed =
        """
        ae9e8fdbf3e67e24d93bc0c85aa9d3b3903057ac198
        1d4b568582e0ca39dbb2476d4e852b812ab00a0dced
        20909560d70b0243afbb4439adf4764b39ccd70981
        """
        .components(separatedBy: .newlines)
        .joined()

    static let base58CheckEncodedPrivateKey =
        """
        xprv9z9SAPmBGgnjFMxMcA4p15cfgEaH7xA5n
        k2ekShz3si1YcTTLrZu2EubR2X3i9we8pyC9A
        QfDDinP4w42wTdTHYvEm5yQ12gfk5c5GhK9ER
        """
        .components(separatedBy: .newlines)
        .joined()

    static let name = "Savings"
    static let index = UInt32(0)

    private init() {}
}
