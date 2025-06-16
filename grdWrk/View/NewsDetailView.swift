import SwiftUI

struct NewsDetailView: View {
    enum Event {
        case close
    }
    weak var coordinator: NewsDetailViewEventHandling?
    var newsItem: NewsItem
    
    var body: some View {
        ZStack {
            BackgroundLinearGradient()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Title
                    Text(newsItem.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.top)
                    
                    Divider()
                    
                    AsyncImage(url: URL(string: newsItem.imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 200)
                                .cornerRadius(20)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .cornerRadius(20)
                        case .failure:
                            Image("empty")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .cornerRadius(20)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    Divider()
                    
                    Text("Description".localized)
                    Text(newsItem.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
            }
        }
    }
}

#Preview {
    NewsDetailView(
        coordinator: nil,
        newsItem: NewsItem(
            title: "Test News Title",
            description: "This is a test news description that shows how the news detail view looks with some sample content. The description can be quite long and will wrap to multiple lines.",
            imageUrl: "https://example.com/test-image.jpg"
        )
    )
}

