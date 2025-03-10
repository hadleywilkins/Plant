//
//  HomeView.swift
//  Plant
//
//  Created by redding sauter on 3/10/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Home")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            Image(systemName: "tree")
                .imageScale(.large)
                .foregroundStyle(.green)
        }
    }
}
