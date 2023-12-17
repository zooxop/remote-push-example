//
//  RemotePushExampleApp.swift
//  RemotePushExample
//
//  Created by 문철현 on 12/16/23.
//

import SwiftUI

@main
struct RemotePushExampleApp: App {
#if os(iOS)
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
#else
  @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
#endif
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
