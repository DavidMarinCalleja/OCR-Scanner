//
//  SceneDelegate.swift
//  xcodeBrownfieldMedium
//
//  Created by David Marin Calleja on 12/9/25.
//

import UIKit
import SwiftUI
import ReactNativeApp

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    // Cuando la scene se conecta (app se abre)
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        print("🎬 SceneDelegate: Scene conectada")
        
        setUpReactNative(scene: scene)
    }
    
    // Cuando la scene se desconecta (app cerrada o en background)
    func sceneDidDisconnect(_ scene: UIScene) {
        print("👋 Scene desconectada")
    }
    
    // Cuando la scene pasa a estar activa
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("✅ Scene activa")
        // Reanudar tareas pausadas
    }
    
    // Cuando la scene va a resignar (pierde el foco)
    func sceneWillResignActive(_ scene: UIScene) {
        print("⏸️ Scene va a resignar")
        // Pausar tareas en curso
    }
    
    // Cuando la scene entra en primer plano
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("📲 Scene en primer plano")
        // Actualizar UI, refrescar datos
    }
    
    // Cuando la scene entra en background
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("📴 Scene en background")
        // Guardar datos, liberar recursos
    }
    
    // Manejar deep links cuando la app ya está abierta
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            print("🔗 URL recibida: \(url)")
            // Manejar el deep link
            handleDeepLink(url: url)
        }
    }
    
    private func handleDeepLink(url: URL) {
        // Lógica para manejar deep links
        print("Procesando deep link: \(url.absoluteString)")
    }
}

private extension SceneDelegate {
    func setUpReactNative(scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        // Add `window` property required by React Native
         window = UIWindow(windowScene: windowScene)

         // Create VC that calls your module by name registered by `AppRegistry.registerComponent` of your React Native app
         let reactNativeVC = ReactNativeViewController(moduleName: "OCRReactNative")

         // Display the view as full window or anyhow you need
         window?.rootViewController = reactNativeVC
         window?.makeKeyAndVisible()
    }
}
