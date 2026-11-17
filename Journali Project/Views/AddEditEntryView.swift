import SwiftUI

struct AddEditEntryView: View {
    var viewModel: JournalViewModel
    var entryToEdit: JournalEntry?

    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var isBookmarked: Bool = false
    @State private var showDiscardAlert: Bool = false

    var isEditing: Bool {
        entryToEdit != nil
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 16) {
                    TextField("Title", text: $title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(hexString: "1C1C1E"))
                        .cornerRadius(10)

                    ZStack(alignment: .topLeading) {
                        if content.isEmpty {
                            Text("Lorem ipsum dolor sit amet...")
                                .foregroundColor(Color(hexString: "A39A9A").opacity(0.5))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                        }
                        TextEditor(text: $content)
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                            .padding(8)
                    }
                    .background(Color(hexString: "1C1C1E"))
                    .cornerRadius(10)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle(isEditing ? "Edit Journal" : "New Journal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        if !title.isEmpty || !content.isEmpty {
                            showDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        isBookmarked.toggle()
                    }) {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .foregroundColor(Color(hexString: "AF99FD"))
                    }

                    Button(action: {
                        if isEditing, let existing = entryToEdit {
                            viewModel.updateEntry(existing, title: title, content: content, isBookmarked: isBookmarked)
                        } else {
                            viewModel.addEntry(title: title, content: content, isBookmarked: isBookmarked)
                        }
                        dismiss()
                    }) {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color(hexString: "AF99FD"))
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                if let entry = entryToEdit {
                    title = entry.title
                    content = entry.content
                    isBookmarked = entry.isBookmarked
                }
            }
            .alert("Are you sure you want to discard changes in this journal?", isPresented: $showDiscardAlert) {
                Button("Keep Editing", role: .cancel) {}
                Button("Discard", role: .destructive) {
                    dismiss()
                }
            }
        }
    }
}
