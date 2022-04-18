import Foundation
import XCTest
@testable import BIP44

final class NeuteredAccountAddressProviderTests: XCTestCase {
    private var accountProvider: AccountProvider!
    private var neuteredAccountProvider = NeuteredAccountProvider()
    private let jsonDecoder = JSONDecoder()
    private var testVectors: [AddressTestVector]!

    override func setUpWithError() throws {
        let seed = Data(hex: AccountTestVector.hexEncodedSeed)
        accountProvider = try AccountProvider(seed: seed, coinType: AccountTestVector.coinType)
        testVectors = try jsonDecoder.decode([AddressTestVector].self, from: addressTestData)
    }

    private func sut(
        neuteredAccount: NeuteredAccount,
        addressType: AddressType,
        addressVersion: UInt8
    ) -> NeuteredAccountAddressProvider {
        .init(
            neuteredAccount: neuteredAccount,
            addressType: addressType,
            addressVersion: addressVersion
        )
    }

    func testGivenNeuteredVectorAccount_WhenProvideAddress_ThenEqualVectorAddress() throws {
        let accountConfiguration = AccountConfiguration(
            name: AccountTestVector.name,
            version: AccountTestVector.version,
            index: AccountTestVector.index
        )
        let account = try accountProvider.account(configuration: accountConfiguration)
        let neuteredAccount = try neuteredAccountProvider.neuteredAccount(
            account: account,
            version: NeuteredAccountTestVector.version
        )
        let sut = self.sut(
            neuteredAccount: neuteredAccount,
            addressType: AddressTestVector.type,
            addressVersion: AddressTestVector.version
        )
        for testVector in testVectors {
            let address = sut.address(index: testVector.index)
            XCTAssertEqual(address, testVector.address)
        }
    }
}
