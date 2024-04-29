//
//  ReviewsRequestManager.swift
//  ReviewsTest
//
//  Created by Marcin Jędrzejak on 29/04/2024.
//

import Foundation

final class ReviewsRequestManager: ObservableObject {
    
    private let userDefaults = UserDefaults.standard
    private let reviewCountKey = "mj.ReviewsTest.reviewCountKey"
    private let lastReviewedVersionKey = "mj.ReviewsTest.lastReviewedVersionKey"
    private let limit = 30
    
    @Published private(set) var count: Int
    
    init() {
        self.count = userDefaults.integer(forKey: reviewCountKey)
    }
    
    func canAskForReview() -> Bool {
        let mostRecentReviewed = userDefaults.string(forKey: lastReviewedVersionKey)
        
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
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
