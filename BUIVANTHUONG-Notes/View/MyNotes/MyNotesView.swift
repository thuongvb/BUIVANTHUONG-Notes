//
//  MyNotesView.swift
//  BUIVANTHUONG-Notes
//
//  Created by thuong.vb on 26/06/2023.
//

import SwiftUI

struct MyNotesView: View {
    @ObservedObject var viewModel: MyNotesViewModel

    @State private var isShowCreatingNote: Bool = false
    @State private var showMenu: Bool = false
    
    @State private var noteText: String = ""
    @State private var noteSelectedId: String? = nil

    var body: some View {
        ZStack {
            listNotesView
            bottomBarView
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding([.trailing, .bottom], 28)
                .animation(.spring(), value: showMenu)
        }
        .onChange(of: noteText) { newText in
            guard !newText.isEmpty, !isShowCreatingNote else {
                return
            }
            
            viewModel.updateANote(noteText: newText, id: noteSelectedId) {
                noteText = ""
                noteSelectedId = nil
            }
        }
        .sheet(isPresented: $isShowCreatingNote) {
            NoteEditorView(noteText: $noteText)
        }
        .onAppear(perform: viewModel.getMyListNotes)
    }
    // - List notes
    private var listNotesView: some View {
        List(viewModel.notes, id: \.self) { item in
            Text(item.noteText)
                .swipeActions(allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        viewModel.deleteANote(id: item.id ?? "")
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                    
                    Button {
                        self.noteSelectedId = item.id
                        self.noteText = item.noteText
                        self.isShowCreatingNote = true
                        
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.indigo)

                }
        }
    }
    
    // -
    var bottomBarView: some View {
        ZStack {
            if showMenu {
                VStack {
                    Button {
                        showMenu = false
                        viewModel.logoutUser()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .rotationEffect(.degrees(-180))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 52, height: 52)
                            .background(Circle().foregroundColor(.cyan))
                    }

                    Button {
                        showMenu = false
                        isShowCreatingNote = true
                    } label: {
                        Image(systemName: "note.text.badge.plus")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 52, height: 52)
                            .background(Circle().foregroundColor(.cyan))

                    }

                }
            } else {
                Button {
                    showMenu = true
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 52, height: 52)
                        .background(Circle().foregroundColor(.cyan))
                }
            }
        }
    }
}

struct MyNotesView_Previews: PreviewProvider {
    static var previews: some View {
        MyNotesView(viewModel: MyNotesViewModel())
    }
}
