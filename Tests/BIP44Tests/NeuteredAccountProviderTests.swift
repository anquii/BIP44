import XCTest
import BIP32
@testable import BIP44

final class NeuteredAccountProviderTests: XCTestCase {
    private var accountProvider: AccountProvider!
    private let serializedKeyCoder = SerializedKeyCoder()

    override func setUpWithError() throws {
        let seed = Data(hex: AccountTestVector.hexEncodedSeed)
        accountProvider = try AccountProvider(seed: seed, coinType: Bitcoin())
    }

    private func sut() -> NeuteredAccountProvider {
        .init()
    }

    func testGivenAccount_WhenNeutered_ThenEqualVectorAccount() throws {
        let configuration = AccountConfiguration(
            name: AccountTestVector.name,
            version: AccountTestVector.version,
            index: AccountTestVector.index
        )
        let account = try accountProvider.account(configuration: configuration)
        let neuteredAccount = try sut().neuteredAccount(account: account, version: NeuteredAccountTestVector.version)
        let base58CheckEncodedPublicKey = serializedKeyCoder.encode(serializedKey: neuteredAccount.serializedKey)
        XCTAssertEqual(base58CheckEncodedPublicKey, NeuteredAccountTestVector.base58CheckEncodedKey)
    }
}
