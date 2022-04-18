struct NeuteredAccountTestVector {
    static let base58CheckEncodedKey =
        """
        xpub6D8nZuJ574M2Tr2piBbpNDZQEGQmXQsw9
        xxFYq7bcDEzRQnbtPt9a3E5GHsJfLz2A5tqJN
        rBmNPAYEVGXitoQMnEpH2JLnSX3qfGVpHfm4o
        """
        .components(separatedBy: .newlines)
        .joined()

    static let name = "Savings"
    static let coinType = Bitcoin()
    static let version = UInt32(0x0488B21E)

    private init() {}
}
