import Foundation

class NewsScreenViewModel: ObservableObject{
    
    private weak var coordinator: NewsListViewEventHandling?
    @Published var newsItems: [NewsItem] = []
    @Published var isLoading: Bool = true
    let apiManager: APIManaging
    
    init(apiManager: APIManaging, coordinator: NewsListViewEventHandling? = nil) {
        self.apiManager = apiManager
        self.coordinator = coordinator
    }
    
    func send(_ action: NewsListScreenAction) {
        switch action {
        case .didTapNewsItem(let newsItem):
            coordinator?.handle(event: .detailNews(newsItem))
        case .refetchNews:
            coordinator?.handle(event: .fetch)
        }
    }
    
    
}

// MARK: Event
extension NewsScreenViewModel {
    enum NewsListScreenEvent {
        case detailNews(NewsItem)
        case fetch
    }
}

// MARK: Action
extension NewsScreenViewModel {
    enum NewsListScreenAction {
        case didTapNewsItem(NewsItem)
        case refetchNews
    }
}

@MainActor
extension NewsScreenViewModel{
    func fetchNews() {
        isLoading = true
        Task {
            do {
                let newsData: NewsData = try await apiManager.request(
                    NewsDataRouter.search
                )
                let newsItems = newsData.Data.map { query in
                    NewsItem(
                        title: query.title,
                        description: query.body,
                        imageUrl: query.imageurl
                    )
                }
                self.newsItems = newsItems
                isLoading = false
            } catch {
                print(error)
            }
            
        }
    }
}
