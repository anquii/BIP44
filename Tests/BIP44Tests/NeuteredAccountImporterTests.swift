import XCTest
import BIP44

final class NeuteredAccountImporterTests: XCTestCase {
    private func sut() -> NeuteredAccountImporter {
        .init()
    }

    func testGivenVectorKey_WithValidDepth_WhenImportNeuteredAccount_ThenValid() throws {
        let neuteredAccount = try sut().neuteredAccount(
            name: NeuteredAccountTestVector.name,
            coinType: NeuteredAccountTestVector.coinType,
            base58CheckEncodedPublicKey: NeuteredAccountTestVector.base58CheckEncodedKey
        )
        XCTAssertEqual(neuteredAccount.name, NeuteredAccountTestVector.name)
        XCTAssertEqual(neuteredAccount.coinType.name, NeuteredAccountTestVector.coinType.name)
        XCTAssertEqual(neuteredAccount.serializedKey.depth, UInt8(3))
    }

    func testGivenVectorKey_WithInvalidDepth_WhenImportNeuteredAccount_ThenThrowInvalidAccountError() {
        XCTAssertThrowsError(
            try sut().neuteredAccount(
                name: InvalidNeuteredAccountTestVector.name,
                coinType: InvalidNeuteredAccountTestVector.coinType,
                base58CheckEncodedPublicKey: InvalidNeuteredAccountTestVector.base58CheckEncodedKey
            )
        ) { error in
            XCTAssertEqual(error as! AccountImporterError, .invalidAccount)
        }
    }

    func testGivenInvalidKey_WhenImportNeuteredAccount_ThenThrowInvalidInputError() {
        XCTAssertThrowsError(
            try sut().neuteredAccount(
                name: NeuteredAccountTestVector.name,
                coinType: NeuteredAccountTestVector.coinType,
                base58CheckEncodedPublicKey: ""
            )
        ) { error in
            XCTAssertEqual(error as! AccountImporterError, .invalidInput)
        }
    }
}
