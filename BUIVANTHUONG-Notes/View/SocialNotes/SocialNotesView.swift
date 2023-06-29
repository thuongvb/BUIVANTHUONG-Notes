//
//  SocialNotesView.swift
//  BUIVANTHUONG-Notes
//
//  Created by thuong.vb on 26/06/2023.
//

import SwiftUI

struct SocialNotesView: View {
    @ObservedObject var viewModel: MyNotesViewModel

    var body: some View {
        ZStack {
            listNotesView
        }
        .onAppear(perform: viewModel.getListNotes)
    }
    // - List notes
    private var listNotesView: some View {
        List(viewModel.notes, id: \.self) { item in
            Text(item.noteText)
        }
    }
}

struct SocialNotesView_Previews: PreviewProvider {
    static var previews: some View {
        SocialNotesView(viewModel: .init())
    }
}
