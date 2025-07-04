import SwiftUI
import Charts

struct SnapsListView: View {
    @StateObject var mainViewModel: MainScreenViewModel
    @ObservedObject var viewModel: SnapsViewModel
    @State private var searchText = ""
    @State private var showAlert = false
    @State private var showAddMoneyAlert = false
    @State private var enteredAmount = ""
    
    var body: some View {
        @State var balance = viewModel.balance
        NavigationView{
            
            ZStack {
                //MARK: BackgroundLinearGradient
                BackgroundLinearGradient()
                
                ZStack{
                    VStack{
                        VStack{
                            
                            //MARK: seartFiled
                            seartFiled()
                        }.padding(.horizontal)
                        
                        
                        VStack{
                            
                            //MARK: setPortfolio
                            portfolioBlock()
                                .padding(8)
                            
                            
                            //MARK: moneyToIndestBlock
                            moneyToIndestBlock()
                                .padding(8)
                        }
                        .background(.ultraThickMaterial)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        
                        HStack{
                            Button(action: { showAddMoneyAlert = true }){
                                Text("Add money".localized)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .frame(width: 180, height: 50)
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }.alert("Add Money Amount".localized, isPresented: $showAddMoneyAlert, actions: {
                                TextField("Enter amount of money".localized, text: $enteredAmount)
                                    .keyboardType(.decimalPad)
                                Button("Add".localized) {
                                    print("Added amount \(enteredAmount)")
                                    viewModel.send(.didTapAddBalance(Double(enteredAmount) ?? 0))
                                    enteredAmount = ""
                                }
                                Button("Cancel".localized, role: .cancel) {
                                    enteredAmount = ""
                                }
                            })
                            
                            
                            Spacer()
                            
                            
                            Button(action: { showAlert = true}){
                                Text("Reset account".localized)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .frame(width: 180, height: 50)
                                    .background(Color.red)
                                    .cornerRadius(10)
                            }.alert(
                                "Are you sure you want to reset your account?".localized,
                                isPresented: $showAlert
                            ) {
                                Button("Delete".localized, role: .destructive) {
                                    viewModel.send(.didTapReset)
                                    print("Account deleted")
                                }
                                Button("Cancel".localized, role: .cancel) {
                                    print("Deletion canceled")
                                }
                            }
                        }.padding()
                        
                        
                        HStack{
                            Text("Snaps".localized).font(.title)
                            Spacer()
                        }
                        .padding()
                        
                        
                        //MARK: contentScrollView
                        contentScrollView()
                            .padding(.horizontal)
                        
                    }.onAppear(){
                        searchText = ""
                        mainViewModel.send(.searchTextChanged(""))
                        viewModel.send(.appear)
                    }.onTapGesture(perform: {
                        searchText = ""
                        mainViewModel.send(.searchTextChanged(""))
                    })
                    
                    
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
    
    private func portfolioBlock() -> some View {
        @State var balance = viewModel.balance
        
        return HStack{
            VStack(alignment: .leading){
                Text("Profit".localized).font(.title)
            }
            Spacer()
            VStack(alignment: .trailing){
                Text("\(String(format: "%0.2f",balance.total))$").font(.title)
                Text("\(String(format: "%0.2f",balance.profit))%").font(.title3).foregroundStyle(.green)
            }
        }
    }
    
    private func moneyToIndestBlock() -> some View {
        @State var balance = viewModel.balance
        
        return HStack{
            Text("Money to invest".localized).font(.title2).foregroundStyle(.gray)
            Spacer()
            VStack(alignment: .trailing){
                Text("\(String(format: "%0.2f",balance.moneyToInvest))$").font(.title2).foregroundStyle(.gray)
            }
        }
    }
    
    private func contentScrollView() -> some View {
        ScrollView{
            VStack(spacing: 8) {
                
                ForEach(viewModel.snapsList) { stock in
                    let calc1 = (stock.price) * stock.ammount
                    HStack {
                        VStack(alignment: .leading) {
                            Text(stock.title)
                                .font(.headline)
                            Text(stock.symbol)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        HStack{
                            VStack(alignment: .trailing){
                                Text("$\(String(format: "%.3f", calc1))")
                                    .font(.headline)
                                Text("\(String(format: "%.3f", (stock.profit ?? 1) * 100))%")
                                    .font(.body)
                                    .foregroundColor(stock.colorProfit)
                            }
                            Button(action: {
                                viewModel.send(.didTapSell(stock))
                            }){
                                Text("Sell".localized)
                            }.buttonStyle(.dismissButtonStyle)
                        }
                        
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .onTapGesture {
                        mainViewModel.send(.didTapStockPreview(stock))
                    }
                }
            }
        }
    }
    
    
}

// MARK: - Preview Helpers
class MockStockItemService: StockItemServicing {
    func fetchStocks() -> [StockEntity] { return [] }
    func fetchStockItems() -> [StockItem] { return [] }
    func addNewStockItem(stockItem: StockItem) {}
    func addSampleData() {}
    func deleteStockItem(stockItem: StockItem) {}
    func fetchSnapsItems() -> [StockItem] { return [] }
    func fetchWatchlistItems() -> [StockItem] { return [] }
}

class MockBalanceService: BalanceServicing {
    func fetchBalanceItem() -> BalanceItem {
        return BalanceItem(total: 1000, profit: 5.5, moneyToInvest: 500, allMoneyToInvest: 1000)
    }
    func addNewBalance(moneyToInvest: Double) {}
    func resetBalance() {}
    func buyStock(stock: StockItem) {}
    func sellStock(stock: StockItem) {}
}

#Preview {
    SnapsListView(
        mainViewModel: MainScreenViewModel(
            apiManager: APIManager(),
            coordinator: nil
        ),
        viewModel: SnapsViewModel(
            apiManager: APIManager(),
            snapsService: MockStockItemService(),
            balanceService: MockBalanceService()
        )
    )
}
