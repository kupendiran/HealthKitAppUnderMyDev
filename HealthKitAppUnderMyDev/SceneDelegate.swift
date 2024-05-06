//
//  SceneDelegate.swift
//  HealthKitAppUnderMyDev
//
//  Created by VC on 06/05/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    static var originalSceneDelegate: SceneDelegate!
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        
        //
        SceneDelegate.originalSceneDelegate = self
        //
        
        
        self.checkLoginStatus()//original
        //self.loginPageVc_Fns()
        
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func checkLoginStatus() {
        //Refresh LoggedIn User Id Start,,,,,
        AppDelegate.originalAppDelegate.GlobalUserId_GLOBAL_Use_Fns()
        
        if let _ = Constants.userdefaults.value(forKey: Constants.Keys.USER_ID) {
            
            hideProgress(currentView: (self.window?.rootViewController?.view)!)
            
            updateMainQueue {
                //
                let nextPageVc = instantiateVC(storyboardName: Constants.Storyboard.Name.MAIN, storyboardId: Constants.Storyboard.Identifier.VC_LOGIN) as! LoginVc
                let navigationVc = UINavigationController.init(rootViewController: nextPageVc)
                navigationVc.setNavigationBarHidden(true, animated: false)
                self.window?.rootViewController = navigationVc
                //
            }//update_Main_Queue End,,,,,
            
        } else {
            self.loginPageVc_Fns()
        }
    }
    
    func loginPageVc_Fns() {
        updateMainQueue {
            let nextPageVc = instantiateVC(storyboardName: Constants.Storyboard.Name.MAIN, storyboardId: Constants.Storyboard.Identifier.VC_LOGIN) as! LoginVc
            let navigationVc = UINavigationController.init(rootViewController: nextPageVc)
            navigationVc.setNavigationBarHidden(true, animated: false)
            self.window?.rootViewController = navigationVc
        }//update_Main_Queue End,,,,,
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

