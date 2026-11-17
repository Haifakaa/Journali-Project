import SwiftUI

struct MainPageView: View {
    @Bindable var viewModel: JournalViewModel
    @State private var showingNewEntry = false
    @State private var entryToEdit: JournalEntry? = nil
    @State private var entryToDelete: JournalEntry? = nil
    @State private var showDeleteAlert = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Journal")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)

                    if viewModel.filteredEntries.isEmpty {
                        Spacer()
                        VStack(spacing: 16) {
                            Image("3333")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            
                            Text("Begin Your Journal")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Craft your personal diary, tap the\nplus icon to begin.")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hexString: "A39A9A"))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        Spacer()
                    } else {
                        List {
                            ForEach(viewModel.filteredEntries) { entry in
                                EntryRowView(entry: entry) {
                                    entryToEdit = entry
                                } onBookmark: {
                                    viewModel.toggleBookmark(entry)
                                }
                                .listRowBackground(Color.black)
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        entryToDelete = entry
                                        showDeleteAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(Color(hexString: "D4453C"))
                                }
                            }
                            .onDelete(perform: viewModel.deleteEntry)
                            
                            Color.clear
                                .frame(height: 70)
                                .listRowBackground(Color.black)
                                .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .padding(.top, 8)
                    }
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(hexString: "A39A9A"))
                    TextField("Search", text: $viewModel.searchText)
                        .foregroundColor(.white)
                    Image(systemName: "mic.fill")
                        .foregroundColor(Color(hexString: "A39A9A"))
                }
                .padding(14)
                .background(Color(hexString: "1C1C1E").opacity(0.95))
                .cornerRadius(24)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color(hexString: "3A3A3C"), lineWidth: 0.5)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            viewModel.filterType = (viewModel.filterType == .byBookmark) ? .none : .byBookmark
                        }) {
                            Label("Sort by Bookmark", systemImage: viewModel.filterType == .byBookmark ? "checkmark" : "bookmark")
                        }
                        
                        Button(action: {
                            viewModel.filterType = .byDate
                        }) {
                            Label("Sort by Entry Date", systemImage: viewModel.filterType == .byDate ? "checkmark" : "calendar")
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        showingNewEntry = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showingNewEntry) {
                AddEditEntryView(viewModel: viewModel, entryToEdit: nil)
            }
            .sheet(item: $entryToEdit) { entry in
                AddEditEntryView(viewModel: viewModel, entryToEdit: entry)
            }
            .alert("Delete journal?", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    if let entry = entryToDelete {
                        viewModel.delete(entry)
                    }
                }
            } message: {
                Text("Are you sure you want to delete this journal?")
            }
        }
    }
}
