//
//  AppDelegate-iOS.swift
//  RemotePushExample
//
//  Created by 문철현 on 12/18/23.
//

#if os(iOS)
import SwiftUI
import FirebaseCore
import FirebaseMessaging

class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    UNUserNotificationCenter.current().delegate = self

    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: { _, _ in }
    )

    application.registerForRemoteNotifications()

    return true
  }

  func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("Unable to register for remote notifications: \(error.localizedDescription)")
  }

  /// Device Token Register 성공 시 동작.
  /// FCM을 사용하려면, `Messaging.messaging().apnsToken` 변수에 생성된 `deviceToken`을 할당해주어야 한다.
  /// ```
  /// Messaging.messaging().apnsToken = deviceToken
  /// ```
  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    print("APNs token retrieved: \(deviceToken)")
    let deviceTokenString = deviceToken.map{ String(format: "%02x", $0) }.joined()
    print(deviceTokenString)
  }
  
  /// FCM Token 발급이 완료되면 실행된다.
  /// ```
  /// 위의 `didRegisterForRemoteNotificationsWithDeviceToken` 에서
  /// `Messaging.messaging().apnsToken = deviceToken` 코드가 실행되면 FCM 토큰 발급 절차가 진행되고,
  /// 토큰 발급이 완료되면 이 메서드가 실행됨.
  /// ```
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")

    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
    )
  }
}

// MARK: - Push Notification 수신
extension AppDelegate: UNUserNotificationCenterDelegate {
  
  /// Silent Push 수신 시 호출. (iOS / macOS 각 플랫폼간 차이가 있음)
  /// ```
  /// # iOS
  ///   - "Silent Push" 인 경우만 동작한다.
  ///   - 수신된 메시지의 Payload에 `"content-available": 1` 값이 포함되어있어야 동작한다.
  /// # macOS
  ///   - "content-available" 값의 존재 여부와 상관없이, Remote Push가 수신되면 무조건 실행된다.
  /// ```
  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable : Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    NotificationPoster.shared.increase()
    print("🟠", #function)
    completionHandler(.newData)
  }
  
  /// 앱이 Foreground 상태일 때 호출.
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification
  ) async -> UNNotificationPresentationOptions {
    print("🟢", #function)
    NotificationPoster.shared.increase()
    return [.sound, .banner, .list]
  }
  
  /// Push message를 클릭했을 때 호출
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse
  ) async {
    NotificationPoster.shared.increase()
    print("🟣", #function)
  }
}
#endif
