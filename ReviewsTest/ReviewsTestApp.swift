//
//  ReviewsTestApp.swift
//  ReviewsTest
//
//  Created by Marcin Jędrzejak on 29/04/2024.
//

import SwiftUI

@main
struct ReviewsTestApp: App {
    
    @StateObject private var reviewsManager = ReviewsRequestManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(reviewsManager)
        }
    }
}
