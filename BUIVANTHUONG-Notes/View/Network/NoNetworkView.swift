//
//  NoNetworkView.swift
//  BUIVANTHUONG-Notes
//
//  Created by thuong.vb on 26/06/2023.
//

import SwiftUI

struct NoNetworkView: View {
    var body: some View {
        VStack {
            Image(systemName: "wifi.slash")
                .font(.system(size: 56))
            Text("Network connection seems to be offline.")
                .padding()
            Button("Perform Network Request") {
            }
        }
    }
}

struct NoNetworkView_Previews: PreviewProvider {
    static var previews: some View {
        NoNetworkView()
    }
}
