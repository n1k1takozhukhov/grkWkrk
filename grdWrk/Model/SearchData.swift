import Foundation

// MARK: Stock data models
struct SearchData: Codable {
    let quotes: [StockQuote]
}

struct StockQuote: Codable {
    let symbol: String
    let shortname: String
    let longname: String?

    enum CodingKeys: String, CodingKey {
        case symbol
        case shortname
        case longname
    }
}
