//
//  ReviewsRequestManager.swift
//  ReviewsTest
//
//  Created by Marcin Jędrzejak on 29/04/2024.
//

import Foundation

final class ReviewsRequestManager: ObservableObject {
    
    private let userDefaults: UserDefaults
    private let lastReviewedVersionKey = "mj.ReviewsTest.lastReviewedVersionKey"
    
    let limit = 30
    let reviewCountKey = "mj.ReviewsTest.reviewCountKey"
    
    @Published private(set) var count: Int
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.count = userDefaults.integer(forKey: reviewCountKey)
    }
    
    func canAskForReview(
        lastReviewedVersion: String? = nil,
        currentVersion: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    ) -> Bool {
        let mostRecentReviewed = lastReviewedVersion ?? userDefaults.string(forKey: lastReviewedVersionKey)
        
        guard let currentVersion = currentVersion as? String else {
            fatalError("Expected to find a bundle version in the info dictionary.")
        }
        
        let hasReachedLimit = userDefaults.integer(forKey: reviewCountKey).isMultiple(of: limit)
        let isNewVersion = currentVersion != mostRecentReviewed
        
        guard hasReachedLimit && isNewVersion else {
            return false
        }
        
        userDefaults.set(currentVersion, forKey: lastReviewedVersionKey)
        return true
    }
    
    func increase() {
        count += 1
        userDefaults.set(count, forKey: reviewCountKey)
    }
}
