import Foundation
import SwiftUI

@MainActor
final class grdWrkCoordinator {
    
    let container: DIContainer
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    private lazy var mainScreenViewModel = MainScreenViewModel(
        apiManager: container.apiManager,
        coordinator: self
    )
    
    private lazy var newsListScreenViewModel = NewsScreenViewModel(
        apiManager: container.apiManager,
        coordinator: self
    )
    
    private lazy var stockPreviewViewModel = StockPreviewViewModel(
        apiManager: container.apiManager,
        coordinator: self
    )
    
    private lazy var snapsViewModel = SnapsViewModel(
        apiManager: container.apiManager,
        snapsService: container.stockService,
        balanceService: container.balanceService,
        coordinator: self
    )
    
    private lazy var watchListViewModel = WatchListViewModel(
        apiManager: container.apiManager,
        stockService: container.stockService,
        coordinator: self
    )
    
    init(navigationController: UINavigationController, container: DIContainer) {
        self.container = container
        self.navigationController = navigationController
        
        start()
    }
}

extension grdWrkCoordinator: Coordinator {
    func start() {
        print("Starting Coordinator")
        let signInViewController = makeTabView()
        navigationController.setViewControllers([signInViewController], animated: true)
    }
}

// MARK: Factories
private extension grdWrkCoordinator {
    func makeTabView() -> UIViewController {
        let view = TabController(
            viewModel: self.mainScreenViewModel,
            newsListScreenViewModel: self.newsListScreenViewModel, snapsViewModel: self.snapsViewModel, watchListViewModel: self.watchListViewModel
        )
        return UIHostingController(rootView: view)
    }
}

private extension grdWrkCoordinator {
    func makeStockDetailView() -> UIViewController {
        let view = StockPreview(
            snapsViewModel: self.snapsViewModel,
            viewModel: self.stockPreviewViewModel,
            watchlistViewModel: self.watchListViewModel
        )
        return UIHostingController(rootView: view)
    }
}

private extension grdWrkCoordinator {
    func makeNewsDetailView(newsItem: NewsItem) -> UIViewController {
        let view = NewsDetailView(
            coordinator: self, newsItem: newsItem
        )
        return UIHostingController(rootView: view)
    }
}

private extension grdWrkCoordinator {
    func makeNewsListView() -> UIViewController {
        let view = NewsListView(
            viewModel: self.newsListScreenViewModel, coordinator: self
        )
        return UIHostingController(rootView: view)
    }

}


// MARK: Navigating
extension grdWrkCoordinator: StockPreviewEventHandling {
    func handle(event: StockPreviewViewModel.Event) {
        switch event {
        case .close:
            navigationController.topViewController?.dismiss(animated: true)
        case .updateTimeFrame(let symbol, let timeframe):
                stockPreviewViewModel.fetchChart(symbol: symbol, timeframe: timeframe)
        case .fetchChart(let symbol):
                stockPreviewViewModel.fetchChart(symbol: symbol)
        case .addToWatchlist(var stock):
            if(watchListViewModel.isInWatchlist(stock: stock)){
                watchListViewModel.unwatch(stock: stock)
            }
            else{
                stock.is_watchlist = true
                stock.is_snaps = false
                watchListViewModel.addStockToWatchList(stock: stock)
            }
            watchListViewModel.initWatchList()
            watchListViewModel.fetchWatchList()
        case .addToSnapslist(var stock, let amount): //here the amount is actually price I want to buy the stock for
            stock.is_snaps = true
            stock.is_watchlist = false
            stock.ammount = (Double(amount) ?? 1) / stock.price
            stock.priceWhenBought = stock.price
            snapsViewModel.addStockToSnapsList(stock: stock)
            snapsViewModel.initSnapsList()
            snapsViewModel.fetchSnapsList()
        }
    }
}

extension grdWrkCoordinator: TabControllerEventHandling {
    func handle(event: TabController.Event) {
        switch event {
        case .close:
            navigationController.topViewController?.dismiss(animated: true)
        }
    }
}
extension grdWrkCoordinator: WatchListEventHandling {
    func handle(event: WatchListViewModel.Event) {
        switch event{
            
        case let .detailStockPreview(stockItem):
            let viewController = makeStockDetailView()
            stockPreviewViewModel.stockItem = stockItem
            navigationController.present(viewController, animated: true)
        case .initWatchlist:
            watchListViewModel.initWatchList()
        case .fetchWatchlist:
            watchListViewModel.fetchWatchList()
        }
    }
}

extension grdWrkCoordinator: MainViewEventHandling {
    func handle(event: MainScreenViewModel.Event) {
        switch event {
        case let .detailStockPreview(stockItem):
            let viewController = makeStockDetailView()
            stockPreviewViewModel.stockItem = stockItem
            navigationController.present(viewController, animated: true)
            
        case let .fetchChart(symbol):
            mainScreenViewModel.fetchChart(symbol: symbol)
        case .fetchMarketList:
            mainScreenViewModel.fetchMarketList()
        case .initChart:
            mainScreenViewModel.fetchChart(symbol: mainScreenViewModel.marketList.first?.symbol ?? "BTC-USD")
        case let .getStockItemFromSymbol(searchQuery):
            Task {
                let stockItem = await mainScreenViewModel.getStockItemFromSymbol(symbol: searchQuery)
                mainScreenViewModel.send(.didTapStockPreview(stockItem))
            }
        case let .updateTimeFrame(symbol, timeframe):
            mainScreenViewModel.fetchChart(symbol: symbol, timeframe: timeframe)
            
        case let .fetchSearchItems(search):
            mainScreenViewModel.fetchSearch(symbol: search)
        }
    }}

extension grdWrkCoordinator: NewsDetailViewEventHandling {
    func handle(event: NewsDetailView.Event) {
        switch event {
        case .close:
            navigationController.topViewController?.dismiss(animated: true)
        }
    }
}

extension grdWrkCoordinator: NewsListViewEventHandling {
    func handle(event: NewsScreenViewModel.NewsListScreenEvent) {
        switch event {
        case let .detailNews(newsItem):
            let viewController = makeNewsDetailView(newsItem: newsItem)
            navigationController.present(viewController, animated: true)
        case .fetch:
            newsListScreenViewModel.fetchNews()
        }
    }
    
    func handle(event: NewsListView.Event) {
        switch event {
        case .close:
            navigationController.topViewController?.dismiss(animated: true)
        }
    }
}

extension grdWrkCoordinator: SnapsListViewEventHandling {
    func handle(event: SnapsViewModel.SnapsEvent) {
        switch event{
            
        case .detailStockPreview(let stockItem):
            let viewController = makeStockDetailView()
            stockPreviewViewModel.stockItem = stockItem
            navigationController.present(viewController, animated: true)
        case .initSnapsList:
            snapsViewModel.initSnapsList()
        case .fetchSnapsList:
            snapsViewModel.fetchSnapsList()
        case .initBalance:
            snapsViewModel.initBalance()
        case .addBalance(let balance):
            snapsViewModel.addBalance(money: balance)
        case .sellStockItem(let stockItem):
            snapsViewModel.sellStock(stock: stockItem)
            snapsViewModel.initSnapsList()
        case .resetBalance:
            snapsViewModel.resetBalance()
            snapsViewModel.deleteSnaps()
            snapsViewModel.initSnapsList()
        }
    }
}
