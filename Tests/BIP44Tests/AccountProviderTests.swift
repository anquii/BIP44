import Foundation
import XCTest
import BIP32
@testable import BIP44

final class AccountProviderTests: XCTestCase {
    private let serializedKeyCoder = SerializedKeyCoder()

    private func sut(seed: Data, coinType: CoinType) throws -> AccountProvider {
        try .init(seed: seed, coinType: coinType)
    }

    func testGivenVectorSeed_AndCoinType_WhenProvideAccount_ThenEqualVectorAccount() throws {
        let seed = Data(hex: AccountTestVector.hexEncodedSeed)
        let sut = try self.sut(seed: seed, coinType: Bitcoin())
        let configuration = AccountConfiguration(
            name: AccountTestVector.name,
            version: AccountTestVector.version,
            index: AccountTestVector.index
        )
        let account = try sut.account(configuration: configuration)
        let base58CheckEncodedPrivateKey = serializedKeyCoder.encode(serializedKey: account.serializedKey)
        XCTAssertEqual(base58CheckEncodedPrivateKey, AccountTestVector.base58CheckEncodedKey)
    }
}
