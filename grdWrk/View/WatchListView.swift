import SwiftUI

struct WatchListView: View {
    @StateObject var mainViewModel: MainScreenViewModel
    @StateObject var viewModel: WatchListViewModel
    @State private var searchText = ""
    
    var body: some View {
        
        NavigationView{
            ZStack{
                //MARK: BackgroundLinearGradient
                BackgroundLinearGradient()
                
                ZStack{
                    VStack{
                        
                        //MARK: SeatchFiled
                        VStack{
                            seartFiled()
                        }.padding(.horizontal)
                        
                        
                        HStack{
                            Text("Watchlist".localized).font(.title)
                            
                            Spacer()
                        }.padding(.top, 20)
                            .padding()
                        
                        
                        //MARK: ContentView
                        ScrollView{
                            VStack(spacing: 8) {
                                forEatchStockItem()
                            }
                        }
                        .padding()
                    }
                    .onAppear(){
                        searchText = ""
                        mainViewModel.send(.searchTextChanged(""))
                        viewModel.send(.appear)
                    }
                    
                    
                    //MARK: Search to ViewModel
                    seartchViewModel()
                }
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
    
    private func forEatchStockItem() -> some View {
        ForEach(viewModel.watchList, id: \.title) { watchedStock in
            HStack {
                VStack(alignment: .leading) {
                    Text(watchedStock.title)
                        .font(.headline)
                    Text(watchedStock.symbol)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .trailing){
                    Text("$\(String(format: "%.2f", watchedStock.price))")
                        .font(.headline)
                    Text("\(String(format: "%.2f", watchedStock.percentChange ?? 0))%")
                        .font(.body)
                        .foregroundColor(watchedStock.color)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .onTapGesture {
                self.viewModel.send(.didTapStockPreview(watchedStock))
            }
        }
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
}
