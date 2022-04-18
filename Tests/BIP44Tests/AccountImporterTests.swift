import XCTest
import BIP44

final class AccountImporterTests: XCTestCase {
    private func sut() -> AccountImporter {
        .init()
    }

    func testGivenVectorKey_WithValidDepth_WhenImportAccount_ThenValid() throws {
        let account = try sut().account(
            name: AccountTestVector.name,
            coinType: AccountTestVector.coinType,
            base58CheckEncodedPrivateKey: AccountTestVector.base58CheckEncodedKey
        )
        XCTAssertEqual(account.name, AccountTestVector.name)
        XCTAssertEqual(account.coinType.name, AccountTestVector.coinType.name)
        XCTAssertEqual(account.serializedKey.depth, UInt8(3))
    }

    func testGivenVectorKey_WithInvalidDepth_WhenImportAccount_ThenThrowInvalidAccountError() {
        XCTAssertThrowsError(
            try sut().account(
                name: InvalidAccountTestVector.name,
                coinType: InvalidAccountTestVector.coinType,
                base58CheckEncodedPrivateKey: InvalidAccountTestVector.base58CheckEncodedKey
            )
        ) { error in
            XCTAssertEqual(error as! AccountImporterError, .invalidAccount)
        }
    }

    func testGivenInvalidKey_WhenImportAccount_ThenThrowInvalidInputError() {
        XCTAssertThrowsError(
            try sut().account(
                name: AccountTestVector.name,
                coinType: AccountTestVector.coinType,
                base58CheckEncodedPrivateKey: ""
            )
        ) { error in
            XCTAssertEqual(error as! AccountImporterError, .invalidInput)
        }
    }
}
