import Foundation
import SwiftUI

struct StockItem: Identifiable {
    var id = UUID()
    var symbol: String
    var title: String
    var price: Double
    var percentChange: Double?
    var ammount: Double
    var priceWhenBought: Double?
    var is_watchlist: Bool?
    var is_snaps: Bool?
    var profit: Double?
    var color: Color {
        guard let percentChange = percentChange else {
            return Color.black
        }
        return percentChange > 0 ? Color.green : Color.red
    }
    var colorProfit: Color {
        guard let profit = profit else {
            return Color.black
        }
        return profit >= 0 ? Color.green : Color.red
    }
}
