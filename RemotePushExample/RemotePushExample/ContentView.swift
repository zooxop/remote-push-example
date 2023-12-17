//
//  ContentView.swift
//  RemotePushExample
//
//  Created by 문철현 on 12/16/23.
//

import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = ContentViewModel()
  
  var body: some View {
    VStack {
      Text("\(self.viewModel.value)")
        .font(.largeTitle)
    }
    .padding()
  }
}

class ContentViewModel: ObservableObject {
  
  @Published var value: Int = 0
  
  init() {
    // 옵저버 등록
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(didRecieveTestNotification(_:)),
      name: NSNotification.Name("Increase"),
      object: nil)
  }
  
  @objc func didRecieveTestNotification(_ notification: Notification) {
    DispatchQueue.main.async {
      self.value += 1
    }
  }
}

#Preview {
  ContentView()
}
