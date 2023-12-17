//
//  NotificationPoster.swift
//  RemotePushExample
//
//  Created by 문철현 on 12/17/23.
//

import Foundation

class NotificationPoster: ObservableObject {
  public static let shared: NotificationPoster = .init()
  
  private init() { }
  
  public func increase() {
    NotificationCenter.default.post(
      name: Notification.Name("Increase"),
      object: nil
    )
  }
}
