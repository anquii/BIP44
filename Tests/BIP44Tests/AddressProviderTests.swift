import Foundation
import XCTest
import BIP32
@testable import BIP44

final class AddressProviderTests: XCTestCase {
    private var accountProvider: AccountProvider!
    private let accountConfiguration = AccountConfiguration(
        name: AccountTestVector.name,
        version: AccountTestVector.version,
        index: AccountTestVector.index
    )
    private let compressedWIFKeyCoder = CompressedWIFKeyCoder()
    private let jsonDecoder = JSONDecoder()
    private var testVectors: [AddressTestVector]!

    override func setUpWithError() throws {
        let seed = Data(hex: AccountTestVector.hexEncodedSeed)
        accountProvider = try AccountProvider(seed: seed, coinType: AccountTestVector.coinType)
        testVectors = try jsonDecoder.decode([AddressTestVector].self, from: addressTestData)
    }

    private func sut(account: Account, addressType: AddressType, addressVersion: UInt8) -> AddressProvider {
        .init(account: account, addressType: addressType, addressVersion: addressVersion)
    }

    func testGivenVectorAccount_WhenProvideAddress_ThenEqualVectorAddress() throws {
        let account = try accountProvider.account(configuration: accountConfiguration)
        let sut = self.sut(account: account, addressType: AddressTestVector.type, addressVersion: AddressTestVector.version)
        for testVector in testVectors {
            let address = sut.address(index: testVector.index)
            XCTAssertEqual(address, testVector.address)
        }
    }

    func testGivenVectorAccount_WhenProvideAddress_ThenEqualVectorAddressAndPrivateKey() throws {
        let account = try accountProvider.account(configuration: accountConfiguration)
        let sut = self.sut(account: account, addressType: AddressTestVector.type, addressVersion: AddressTestVector.version)
        for testVector in testVectors {
            let addressAndPrivateKey = sut.addressAndPrivateKey(index: testVector.index)
            let compressedWIFEncodedPrivateKey = compressedWIFKeyCoder.encode(
                privateKey: addressAndPrivateKey.privateKey,
                version: AddressTestVector.compressedWIFEncodedPrivateKeyVersion
            )
            XCTAssertEqual(addressAndPrivateKey.address, testVector.address)
            XCTAssertEqual(compressedWIFEncodedPrivateKey, testVector.compressedWIFEncodedPrivateKey)
        }
    }
}
