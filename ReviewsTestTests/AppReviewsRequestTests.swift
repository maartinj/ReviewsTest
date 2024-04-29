//
//  AppReviewsRequestTests.swift
//  AppReviewsRequestTests
//
//  Created by Marcin Jędrzejak on 29/04/2024.
//

import XCTest
@testable import ReviewsTest

final class AppReviewsRequestTests: XCTestCase {
    
    private var userDefaults: UserDefaults!
    private var sut: ReviewsRequestManager!
    
    override func setUp() {
        super.setUp()
        
        userDefaults = UserDefaults(suiteName: #file)
        sut = ReviewsRequestManager(userDefaults: userDefaults)
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: #file)
        userDefaults = nil
        sut = nil
    }

    func testCountIsIncreasedWhenCalled() {
        XCTAssertEqual(sut.count, 0, "The initial value should be 0")
        sut.increase()
        XCTAssertEqual(sut.count, 1, "The new value should be 1")
        XCTAssertEqual(userDefaults.integer(forKey: sut.reviewCountKey), 1, "The value in userdefaults should be 1")
    }
    
    func testAppIsValidForRequestOnFreshLaunch() {
        for _ in 0..<sut.limit {
            sut.increase()
        }
        
        XCTAssertTrue(sut.canAskForReview(),
                      "The user has hit the limit \(sut.limit) they should be able to leave a review")
    }
    
    func testAppIsInvalidForRequestOnFreshLaunch() {
        for _ in 0..<sut.limit - 1 {
            sut.increase()
        }
        
        XCTAssertFalse(sut.canAskForReview(),
                      "The user hasn't hit the limit \(sut.limit) they shouldn't be able to leave a review")
    }
    
    func testAppIsInvalidForRequestAfterLimitReached() {
        
        func increase() {
            for _ in 0..<sut.limit  {
                sut.increase()
            }
        }
        increase()
        
        XCTAssertTrue(sut.canAskForReview(),
                      "The user has hit the limit \(sut.limit) they should be able to leave a review")
        
        increase()

        XCTAssertFalse(sut.canAskForReview(),
                      "The user hasn't hit the limit \(sut.limit) they shouldn't be able to leave a review")
    }
    
    func testAppIsInvalidForRequestForNewVersion() {
        let oldVersion = "1.0"
        let newVersion = "1.1"
        
        func increase() {
            for _ in 0..<sut.limit {
                sut.increase()
            }
        }
        
        increase()
        
        let canAskForReview = sut.canAskForReview(lastReviewedVersion: nil,
                                                  currentVersion: oldVersion)
        
        XCTAssertTrue(canAskForReview,
                      "The user has hit the limit \(sut.limit) they should be able to leave a review")
        
        increase()
        
        let canAskForReviewNewVersion = sut.canAskForReview(lastReviewedVersion: oldVersion,
                                                            currentVersion: newVersion)
        
        XCTAssertTrue(canAskForReviewNewVersion,
                      "The user has hit the limit \(sut.limit) they should be able to leave a review")
        
        increase()
        
        let canAskForReviewSameVersion = sut.canAskForReview(lastReviewedVersion: newVersion,
                                                             currentVersion: newVersion)
        
        XCTAssertFalse(canAskForReviewSameVersion,
                       "The user can't review the same version")
    }
    
    func testAppIsValidForRequestForNewVersion() {
        let oldVersion = "1.0"
        let newVersion = "1.1"
        
        func increase() {
            for _ in 0..<sut.limit {
                sut.increase()
            }
        }
        
        increase()
        
        let canAskForReview = sut.canAskForReview(lastReviewedVersion: nil,
                                                  currentVersion: oldVersion)
        
        XCTAssertTrue(canAskForReview,
                      "The user has hit the limit \(sut.limit) they should be able to leave a review")
        
        increase()
        
        let canAskForReviewNewVersion = sut.canAskForReview(lastReviewedVersion: oldVersion,
                                                            currentVersion: newVersion)
        
        XCTAssertTrue(canAskForReviewNewVersion,
                      "The user has hit the limit \(sut.limit) they should be able to leave a review")
    }
}
