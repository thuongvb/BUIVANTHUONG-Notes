//
//  LoginView.swift
//  BUIVANTHUONG-Notes
//
//  Created by thuong.vb on 27/06/2023.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var showAlert: Bool = false
    private let maxLength: Int = 32
    @ObservedObject private var viewModel: LoginViewModel = .init()

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                usernameTextField
                    .padding(.horizontal)
                    .padding(.vertical, 120)
                    .frame(maxHeight: .infinity, alignment: .top)
                
                actionView
                    .padding()
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Text("Sign in"))
            .toolbarBackground(
                Color.navBar,
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .onChange(of: username) { newValue in
            checkingUsernameRule(newValue: newValue)
        }
        .onChange(of: viewModel.isExist) {
            if $0 == false {
                showAlert = true
            }
        }
        .alert("Alert", isPresented: $showAlert) {
            Button(role: .none) {
                viewModel.createAUser(with: username)
            } label: {
                Text("OK")
            }

            Button(role: .cancel) {
                showAlert = false
            } label: {
                Text("Cancel")
            }

        } message: {
            Text("Would you like to create an account with username: **\(username)**?")
        }

    }
    
    private var actionView: some View {
        VStack {
            loginButton
            
            if self.username.count == maxLength {
                Text("The maximum total length of a user name is \(maxLength) characters.")
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
    
    private var loginButton: some View {
        Button {
            guard !username.isEmpty else { return }
            viewModel.checkUsername(with: username)
        } label: {
            HStack {
                Text("Sign in")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Capsule().foregroundColor(Color.cyan))
        }
    }
    
    private var usernameTextField: some View {
        TextField("Enter your username", text: $username)
            .frame(height: 56)
            .padding(.horizontal)
            .background(
                RoundedRectangle(
                    cornerRadius: 8,
                    style: .continuous
                )
                .stroke(lineWidth: 2)
                .foregroundColor(Color.cyan)
            )
    }
    
    private func checkingUsernameRule(newValue: String) {
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789._-"
        let filtered = newValue.prefix(maxLength).filter { allowedCharacters.contains($0) }
        if filtered != newValue {
            self.username = filtered.lowercased()
        }

    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
