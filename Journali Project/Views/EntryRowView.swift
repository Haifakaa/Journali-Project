import SwiftUI

struct EntryRowView: View {
    let entry: JournalEntry
    var onTap: () -> Void
    var onBookmark: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hexString: "AF99FD"))
                    
                    Text(entry.date, style: .date)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hexString: "A39A9A"))
                }
                Spacer()
                Button(action: onBookmark) {
                    Image(systemName: entry.isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(Color(hexString: "AF99FD"))
                }
            }
            
            Text(entry.content)
                .font(.system(size: 14))
                .foregroundColor(Color(hexString: "A39A9A"))
                .lineLimit(4)
                .padding(.top, 4)
        }
        .padding(16)
        .background(Color(hexString: "1C1C1E"))
        .cornerRadius(16)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}
