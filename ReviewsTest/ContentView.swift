//
//  ContentView.swift
//  ReviewsTest
//
//  Created by Marcin Jędrzejak on 29/04/2024.
//
// Link: https://www.youtube.com/watch?v=iuZgccibgjE&ab_channel=tundsdev

import SwiftUI
import StoreKit

struct ContentView: View {
    
    @EnvironmentObject private var reviewsManager: ReviewsRequestManager
    @Environment(\.requestReview) var requestReview: RequestReviewAction
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack {
            Text("\(reviewsManager.count)")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
            Button {
                reviewsManager.increase()
                
                if reviewsManager.canAskForReview() {
                    requestReview()
                }
            } label: {
                Text("Increase")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            Button {
                if let link = reviewsManager.reviewLink {
                    openURL(link)
                }
            } label: {
                Text("Leave Review")
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environmentObject(ReviewsRequestManager())
}
