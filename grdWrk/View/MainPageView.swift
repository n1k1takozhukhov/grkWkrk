import SwiftUI
import Charts

struct MainPageView: View {
    @StateObject var viewModel: MainScreenViewModel
    @State private var searchText = ""
    @State private var selectedTimeframe: String = "1d"
    @State private var selectedMarketIndex: Int = 0
    
    
    let pastelColors: [Color] = [
        Color(red: 0.5, green: 0.6, blue: 0.7),
        Color(red: 0.7, green: 0.5, blue: 0.6),
        Color(red: 0.6, green: 0.7, blue: 0.5),
        Color(red: 0.7, green: 0.6, blue: 0.5),
        Color(red: 0.5, green: 0.7, blue: 0.6)
    ]
    
    var body: some View {
        @State var marketList = viewModel.marketList
        @State var emptyChartData = viewModel.chartData
        
        NavigationView {
            ZStack{
                BackgroundLinearGradient()
                
                VStack {
                    VStack{
                        SearchField(
                            searchText: $searchText,
                            onSearch: { text in
                                viewModel.send(.searchConfirmed(text))
                            },
                            onTextChange: { text in
                                viewModel.send(.searchTextChanged(text))
                            })
                    }
                    .padding(.horizontal)
                    
                    StockChartView(data: emptyChartData)
                        .frame(width: 370,height: 230)
                        .foregroundStyle(.gray)
                        .cornerRadius(15)
                    
                    HStack {
                        let timeframes = ["1d", "3mo", "6mo", "1y"]
                        ForEach(timeframes, id: \.self) { timeframe in
                            Button(action: {
                                selectedTimeframe = timeframe
                                viewModel.send(.timeframeSelected(marketList[selectedMarketIndex].symbol, selectedTimeframe))
                            }) {
                                Text(timeframe)
                            }.buttonStyle(.timeframe(isSelected: selectedTimeframe == timeframe))
                            
                        }
                    }
                    .padding(.horizontal)
                    
                    ScrollView{
                        VStack(spacing: 8) {
                            ForEach(marketList.indices, id: \.self) { index in
                                let market = marketList[index]
                                
                                HStack {
                                    Circle()
                                        .frame(width: 55, height: 55)
                                        .foregroundColor(self.pastelColors[index])
                                        .overlay(
                                            Text(market.title.prefix(3))
                                                .foregroundColor(.white)
                                                .font(.headline)
                                        )
                                    
                                    VStack(alignment: .leading) {
                                        Text(market.title)
                                            .font(.headline)
                                        Text(market.symbol)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing){
                                        Text("$\(String(format: "%.2f", market.price))")
                                            .font(.headline)
                                        Text("\(String(format: "%.2f", market.percentChange ?? 0))%")
                                            .font(.body)
                                            .foregroundColor(market.color)
                                    }
                                }
                                .padding()
                                .background(selectedMarketIndex == index ? Color.green.opacity(0.2) : Color(.systemGray6))
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedMarketIndex = index
                                    viewModel.send(.didTapStock(marketList[selectedMarketIndex]))
                                }
                                .onAppear(){
                                    searchText = ""
                                    viewModel.send(.searchTextChanged(""))
                                    viewModel.send(.appear)
                                }
                                
                                
                            }
                        }.padding()
                    }
                    .frame(maxHeight: 300)
                }
                .padding()
                .onTapGesture(perform: {
                    searchText = ""
                    viewModel.send(.searchTextChanged(""))
                })
                
                if let search = viewModel.search {
                    SearchResultsView(
                        quotes: search.quotes,
                        onQuoteSelected: { symbol in
                            Task {
                                let stock = await viewModel.getStockItemFromSymbol(symbol: symbol)
                                await MainActor.run {
                                    viewModel.send(.didTapStockPreview(stock))
                                    searchText = ""
                                    viewModel.send(.searchTextChanged(""))
                                }
                            }
                        },
                        onDismiss: {
                            searchText = ""
                            viewModel.send(.searchTextChanged(""))
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    MainPageView(viewModel: MainScreenViewModel(
        apiManager: APIManager(),
        coordinator: nil
    ))
}
