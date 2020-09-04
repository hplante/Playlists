//
//  ContentView.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-02.
//  Copyright © 2020 HPS. All rights reserved.
//

import GoogleSignIn
import SwiftUI

struct SignInButton: UIViewRepresentable {
    func makeUIView(context: Context) -> GIDSignInButton {
        let button = GIDSignInButton()
        // Customize button here
        button.colorScheme = .light
        return button
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct ContentView: View {
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @EnvironmentObject var playlistViewModel: PlaylistListViewModel
    var body: some View {
        VStack {
            if googleDelegate.signedIn {
                PlaylistListView(viewModel: playlistViewModel)
            } else {
                SignInButton()
            }
        }
        .onAppear {
            GIDSignIn.sharedInstance().restorePreviousSignIn()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
