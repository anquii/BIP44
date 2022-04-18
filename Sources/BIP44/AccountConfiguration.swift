public struct AccountConfiguration {
    public let name: String
    public let version: UInt32
    public let index: UInt32

    public init(name: String, version: UInt32, index: UInt32) {
        self.name = name
        self.version = version
        self.index = index
    }
}
