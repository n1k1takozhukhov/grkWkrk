import Foundation

enum StockDataRouter: Endpoint {
    case search(symbol: String)
    case chart(symbol: String, timeframe: String?)
    case info(symbol: String)
    
    var host: String {
        return "https://query2.finance.yahoo.com"
    }
    
    var path: String {
        switch self {
        case .search:
            return "/v1/finance/search"
        case let .chart(symbol, _):
            return "/v8/finance/chart/\(symbol)"
        case .info(symbol: let symbol):
            return "/v1/finance/quoteType/\(symbol)"
        }
    }
    
    var urlParameters: [String: Any] {
        switch self {
        case let .search(symbol):
            return ["q": symbol]
        case let .chart(_, timeframe):
            guard let timeframe = timeframe else { return [:] }
            
            
            var parameters: [String: Any] = [:]
            switch timeframe {
            case "1d", "5d":
                parameters["range"] = timeframe
                parameters["interval"] = "1m"
            case "1mo":
                parameters["range"] = timeframe
                parameters["interval"] = "2m"
            case "3mo", "6mo", "1y":
                parameters["range"] = timeframe
                parameters["interval"] = "1d"
            default:
                break
            }
            return parameters
        case .info:
            return [:]
        }
    }
}
