//
//  SceneDelegate.swift
//  YandexDiskRelease
//
//  Created by MacPro on 19.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let navController = UINavigationController()
        
        // setup container
        
        let container = DIContainer.shared
        container.register(type: MainViewModel.self, component: MainViewModel(navController: navController))
        
        // setup root view controller
        
        let rootVC = MainCollectionViewController()
        navController.viewControllers.append(rootVC)
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        if (UserDefaults.standard.value(forKey: "Token") == nil) {
            print("we dont have token")
            rootVC.viewModel.presentAuthViewController()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }
}

