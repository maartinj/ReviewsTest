//
//  ContentView.swift
//  ReviewsTest
//
//  Created by Marcin Jędrzejak on 29/04/2024.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    
    @Environment(\.requestReview) var requestReview: RequestReviewAction
    @State private var counter = 0
    
    var body: some View {
        VStack {
            Text("\(counter)")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
            Button {
                counter += 1
                
                if counter.isMultiple(of: 5) {
                    requestReview()
                }
            } label: {
                Text("Increase")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
