//
//  NoteEditorView.swift
//  BUIVANTHUONG-Notes
//
//  Created by thuong.vb on 27/06/2023.
//

import SwiftUI

struct NoteEditorView: View {
    @Environment(\.dismiss) var dismiss
    @State private var editingText: String = ""
    @Binding var noteText: String
    
    init(noteText: Binding<String>) {
        self._noteText = noteText
        self.editingText = noteText.wrappedValue
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                TextEditor(text: $editingText)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                    .padding(.bottom, 70)
                
                bottomBarView
                    .frame(height: 70)
                    .frame(maxWidth: .infinity, alignment: .bottom)
                    .padding()
            }
            .navigationTitle("Create Your Note")
        }
        .onAppear {
            self.editingText = noteText
        }
    }
    
    var bottomBarView: some View {
        HStack {
            ForEach(BottomItem.allCases, id: \.self) { item in
                bottomBarItemView(item: item) {
                    if item == .close {
                        self.noteText = ""
                        dismiss()
                    } else {
                        self.noteText = editingText
                        dismiss()
                    }
                }
            }
        }
    }
}

extension NoteEditorView {
    enum BottomItem: Int, CaseIterable {
        case close = 0,
             save
        
        var title: String {
            switch self {
            case .close:
                return "Close"
            case .save:
                return "Save"
            }
        }
        
        var iconName: String {
            switch self {
            case .close:
                return "xmark"
            case .save:
                return "checkmark"
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .close:
                return .gray
            case .save:
                return .cyan
            }
        }
    }
    
    private func bottomBarItemView(item: BottomItem, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Spacer()
                Image(systemName: item.iconName)
                Text(item.title)
                Spacer()
            }
            .foregroundColor(.white)
            .fontWeight(.bold)
            .padding()
            .background(
                Capsule(style: .continuous)
                    .foregroundColor(item.backgroundColor)
            )
        }
        
    }
    
}

struct NoteEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NoteEditorView(noteText: .constant(""))
    }
}
