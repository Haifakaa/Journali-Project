import SwiftUI
import Foundation
import Observation

@Observable
class JournalViewModel {
    var entries: [JournalEntry] = [
        JournalEntry(title: "My Birthday", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh viverra non", date: Date(), isBookmarked: true),
        JournalEntry(title: "Today's Journal", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh viverra non", date: Date().addingTimeInterval(-86400), isBookmarked: false),
        JournalEntry(title: "Great Day", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh viverra non", date: Date().addingTimeInterval(-172800), isBookmarked: false)
    ]
    var searchText: String = ""
    var filterType: FilterType = .none

    enum FilterType {
        case none
        case byBookmark
        case byDate
    }

    var filteredEntries: [JournalEntry] {
        let result = entries.filter { entry in
            let matchesSearch = searchText.isEmpty ||
                entry.title.localizedCaseInsensitiveContains(searchText) ||
                entry.content.localizedCaseInsensitiveContains(searchText)
            
            let matchesBookmark = (filterType != .byBookmark) || entry.isBookmarked
            return matchesSearch && matchesBookmark
        }
        
        if filterType == .byDate {
            return result.sorted(by: { $0.date > $1.date })
        }
        return result
    }

    func addEntry(title: String, content: String, isBookmarked: Bool) {
        let newEntry = JournalEntry(title: title, content: content, date: Date(), isBookmarked: isBookmarked)
        entries.insert(newEntry, at: 0)
    }

    func updateEntry(_ entry: JournalEntry, title: String, content: String, isBookmarked: Bool) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].title = title
            entries[index].content = content
            entries[index].isBookmarked = isBookmarked
        }
    }

    func deleteEntry(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
    }
    
    func delete(_ entry: JournalEntry) {
        entries.removeAll(where: { $0.id == entry.id })
    }

    func toggleBookmark(_ entry: JournalEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].isBookmarked.toggle()
        }
    }
}

