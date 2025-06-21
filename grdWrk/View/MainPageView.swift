import SwiftUI
import Charts

struct MainPageView: View {
    @StateObject var mainViewModel: MainScreenViewModel
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
        @State var emptyChartData = mainViewModel.chartData
        
        NavigationView {
            ZStack{
                //MARK: BackgroundLinearGradient
                BackgroundLinearGradient()
                
                VStack {
                    //MARK: SeartFiled
                    VStack{
                        seartFiled()
                    }
                    .padding(.horizontal)
                    
                    
                    //MARK: StockChartView
                    StockChartView(data: emptyChartData)
                        .frame(width: 370,height: 230)
                        .foregroundStyle(.gray)
                        .cornerRadius(15)
                    
                    
                    //MARK: StockChartView
                    timeFrameView()
                        .padding(.horizontal)
                    
                    
                    //MARK: scrollViewContent
                    scrollViewContent()
                        .frame(maxHeight: 300)
                }
                .padding()
                .onTapGesture(perform: {
                    searchText = ""
                    mainViewModel.send(.searchTextChanged(""))
                })
                
                
                //MARK: Search to ViewModel
                seartchViewModel()
            }
        }
    }
    
    
    //MARK: - Content Block
    private func seartFiled() -> some View {
        SearchField(
            searchText: $searchText,
            onSearch: { text in
                mainViewModel.send(.searchConfirmed(text))
            },
            onTextChange: { text in
                mainViewModel.send(.searchTextChanged(text))
            }
        )
    }
    
    private func seartchViewModel() -> some View {
        Group {
            if let search = mainViewModel.search {
                SearchResultsView(
                    quotes: search.quotes,
                    onQuoteSelected: { symbol in
                        Task {
                            let stock = await mainViewModel.getStockItemFromSymbol(symbol: symbol)
                            await MainActor.run {
                                mainViewModel.send(.didTapStockPreview(stock))
                                searchText = ""
                                mainViewModel.send(.searchTextChanged(""))
                            }
                        }
                    },
                    onDismiss: {
                        searchText = ""
                        mainViewModel.send(.searchTextChanged(""))
                    }
                )
            }
        }
    }
    
    private func timeFrameView() -> some View {
        HStack {
            let timeframes = ["1d", "3mo", "6mo", "1y"]
            ForEach(timeframes, id: \.self) { timeframe in
                Button(action: {
                    selectedTimeframe = timeframe
                    mainViewModel.send(.timeframeSelected(mainViewModel.marketList[selectedMarketIndex].symbol, selectedTimeframe))
                }) {
                    Text(timeframe)
                }.buttonStyle(.timeframe(isSelected: selectedTimeframe == timeframe))
                
            }
        }
    }
    
    private func scrollViewContent() -> some View {
        @State var marketList = mainViewModel.marketList
        
        return ScrollView{
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
                        mainViewModel.send(.didTapStock(marketList[selectedMarketIndex]))
                    }
                    .onAppear(){
                        searchText = ""
                        mainViewModel.send(.searchTextChanged(""))
                        mainViewModel.send(.appear)
                    }
                }
            }.padding()
        }
    }
}

//MARK: - #Preview
#Preview {
    MainPageView(mainViewModel: MainScreenViewModel(
        apiManager: APIManager(),
        coordinator: nil
    ))
}
