import SwiftUI

struct SearchResultsView: View {
    let quotes: [StockQuote]
    let onQuoteSelected: (String) async -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack {
            if !quotes.isEmpty {
                ForEach(quotes, id: \.self.symbol) { quote in
                    Text(quote.shortname)
                        .onTapGesture {
                            Task {
                                await onQuoteSelected(quote.symbol)
                                onDismiss()
                            }
                        }
                        .padding()
                }
            }
        }
        .background(.ultraThickMaterial)
        .cornerRadius(8)
        .shadow(radius: 4)
        .padding(.top, 60)
        .onTapGesture(perform: onDismiss)
    }
}

#Preview {
    let mockQuotes = [
        StockQuote(symbol: "AAPL", shortname: "Apple Inc.", longname: "Apple Inc."),
        StockQuote(symbol: "GOOGL", shortname: "Alphabet Inc.", longname: "Alphabet Inc."),
        StockQuote(symbol: "MSFT", shortname: "Microsoft Corporation", longname: "Microsoft Corporation")
    ]
    
    return SearchResultsView(
        quotes: mockQuotes,
        onQuoteSelected: { symbol in
            print("Selected quote: \(symbol)")
        },
        onDismiss: {
            print("Dismissed search results")
        }
    )
    .padding()
}
