//
//  RemotePushExampleTests.swift
//  RemotePushExampleTests
//
//  Created by 문철현 on 1/13/24.
//

import XCTest
@testable import RemotePushExample

final class RemotePushExampleTests: XCTestCase {
  
  func testReceiveNotification() async throws {
    // given
    let mockViewModel: ContentViewModel = .init()
    XCTAssertEqual(mockViewModel.value, 0, "초기값이 0이 아님")
    
    // when
    NotificationPoster.shared.increase()
    
    // then
    try await Task.sleep(nanoseconds: 5_000_000_000)
    XCTAssertEqual(mockViewModel.value, 1, "값 증가 실패")
  }
}
