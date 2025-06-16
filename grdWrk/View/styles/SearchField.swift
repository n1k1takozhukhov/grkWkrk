import SwiftUI

struct SearchField: View {
    @Binding var searchText: String
    let onSearch: (String) -> Void
    let onTextChange: (String) -> Void
    
    var body: some View {
        
        TextField("Search...".localized, text: $searchText)
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .autocorrectionDisabled()
            .onChange(of: searchText) { oldValue, newValue in
                onTextChange(newValue)
            }
            .onSubmit {
                if !searchText.isEmpty {
                    onSearch(searchText)
                    searchText = ""
                    onTextChange("")
                }
            }
            .onTapGesture {
                searchText = ""
                onTextChange("")
            }
    }
}

#Preview {
    @Previewable @State var previewText = ""
    
    SearchField(
        searchText: $previewText,
        onSearch: {
            print("Text changed to: %s\n", $0)
        },
        onTextChange: {
            print("Text changed to: %s\n", $0)
        }
    )
}
