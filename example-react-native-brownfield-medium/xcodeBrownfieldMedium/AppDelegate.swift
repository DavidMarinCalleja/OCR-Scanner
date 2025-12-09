//
//  AppDelegate.swift
//  xcodeBrownfieldMedium
//
//  Created by David Marin Calleja on 12/9/25.
//

import UIKit
import ReactNativeApp

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        ReactNativeBrownfield.shared.bundle = ReactNativeBundle
        ReactNativeBrownfield.shared.startReactNative(onBundleLoaded: {
            print("React Native bundle loaded")
        }, launchOptions: launchOptions)

        return true
    }

    // IMPORTANTE: Configurar el SceneDelegate
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
            
        print("🔧 Configurando scene session")
            
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
            
        return sceneConfig
    }
}
