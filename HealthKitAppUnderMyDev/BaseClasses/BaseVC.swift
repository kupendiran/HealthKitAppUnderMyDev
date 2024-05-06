//
//  BaseVC.swift
//

import UIKit

class BaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        /*let appName = Bundle.getAppDisplayName
        print("appName==>>", appName ?? "")
        let bundleID = Bundle.getAppBundleID
        print("bundleID==>>", bundleID ?? "")*/
        
        //if let topVC = getCurrentViewController(self) {
        /*if let topVC = UIApplication.getTopViewController() {
            //print("topVC_11==>>",topVC)//, "debugDescription",topVC.children.)
            
            let getCurrentVcName = topVC.debugDescription.slice(from: ".", to: ":")
            print("getCurrentVcName==>>", getCurrentVcName ?? "")
            
        }*/
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BaseVC {
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    func Get_AppModeSetups_Fns() {
        if self.traitCollection.userInterfaceStyle == .dark {
            //User Interface is Dark
            print("AppMode_Dark===>>", self.traitCollection.userInterfaceStyle)
        } else if self.traitCollection.userInterfaceStyle == .light {
            //User Interface is Light
            print("AppMode_Light===>>", self.traitCollection.userInterfaceStyle)
        } else {//.unspecified
            //User Interface is System
            print("AppMode_System===>>", self.traitCollection.userInterfaceStyle)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let userInterfaceStyle = traitCollection.userInterfaceStyle //Either .unspecified, .light, or .dark
        //Update your user interface based on the appearance
        print("UserInterfaceStyle===>", userInterfaceStyle)
    }
    
    @IBAction func changeMode(_: Any) {
        let window = UIApplication.shared.windows[0]
        var mode = window.overrideUserInterfaceStyle
        mode = mode == .dark ? .light : .dark
    }
    
}
