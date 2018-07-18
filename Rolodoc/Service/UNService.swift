//
//  UNService.swift
//  Rolodoc
//
//  Created by Katherine Choi on 7/17/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//

import UIKit
import UserNotifications

class UNService: NSObject {
    private override init() {}
    static let shared = UNService()
    let unCenter = UNUserNotificationCenter.current()
    
    func authorize() {
        let options: UNAuthorizationOptions = [.badge, .sound, .alert]
        unCenter.requestAuthorization(options: options) { (granted, error) in
            print(error ?? "no un authorization error")
            guard granted else { return }
            DispatchQueue.main.async {
                self.configure()
            }
        }
    }
    
    func configure() {
        unCenter.delegate = self
        
        let application = UIApplication.shared
        application.registerForRemoteNotifications()
    }
}

extension UNService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("un did receive")
        
        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //when user is in app/app is in foreground and gets notification
        print("WOO will present")
        completionHandler([])
    }
}

