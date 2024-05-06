//
//  LoginVw.swift
//  HealthKitAppUnderMyDev
//
//  Created by VC on 06/05/24.
//

import UIKit
import AuthenticationServices

class LoginVw: BaseView {
    
    var controller : LoginVc!
    func setController(controller : LoginVc) -> Void {
        self.controller = controller
        
        
    }
    
    
    
    func designSetups() {
        
        /*for locale in NSLocale.locales() {
            print("countries===>>>\(locale.countryCode) - \(locale.countryName) - \(locale.countryMobileCode)")
            
            if countryCode == locale.countryCode {
                print("success==>>got country mobile")
                break
            }
        }*/
        
    }
    
    
    
    //MARK: ******************************Variables and Outlets declaration here Start******************************
    
    @IBOutlet weak var btn_LogInWithApple: UIButton! {
        didSet {
            self.btn_LogInWithApple.addIconToLeftSideButton(image: UIImage(named: "icon-Apple_White_48")!, imageSize: 25.0)
        }
    }
    
    //MARK: ******************************Variables and Outlets declaration here End******************************
    
    
    
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    
    
    
    func goToNextPage_AfterLogin_Fns() {
        updateMainQueue {
            let nextPageVc = instantiateVC(storyboardName: Constants.Storyboard.Name.MAIN, storyboardId: "ViewController") as! ViewController
            self.controller?.navigationController?.pushViewController(nextPageVc, animated: true)
        }//update_Main_Queue End,,,,,
    }
    
    
}


extension LoginVw {
    
    @IBAction func HealthKitOptionTapped(_ sender: UIButton) {
        self.goToNextPage_AfterLogin_Fns()
    }
    
}






//MARK: Login with Apple Integrations works Start,,,,,
//==============================================================================
//==============================================================================
extension LoginVw: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @IBAction func btn_LogInWithAppleTapped(_ sender: UIButton) {
        self.AppleSignInSetup_Fns(self_controller: self.controller)
        //Logout
    }
    
    func AppleSignInSetup_Fns(self_controller: UIViewController) {
        self.handleAppleIdRequest()
        //self.performExistingAccountSetupFlows()
        /*let appleIDProvider = ASAuthorizationAppleIDProvider()
         appleIDProvider.getCredentialState(forUserID: appleIDCredential.user) {  (credentialState, error) in
              switch credentialState {
                 case .authorized:
                     //The Apple ID credential is valid.
                     print("Result==>authorized")
                     break
                 case .revoked:
                     //The Apple ID credential is revoked.
                     print("Result==>revoked")
                     //self.performExistingAccountSetupFlows()
                     break
                 case .notFound:
                     //No credential was found, so show the sign-in UI.
                     print("Result==>notFound")
                     break
                 default:
                     break
              }
         }*/
    }
    
    func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            //Create an account in your system.
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let userIdentifier = appleIDCredential.user
            var userEmail = appleIDCredential.email
            var fullName = appleIDCredential.fullName
            var userFirstName = appleIDCredential.fullName?.givenName
            var userLastName = appleIDCredential.fullName?.familyName
            
            print("IdTokenString==>\(idTokenString) \n UserId==>\(userIdentifier) \n userFirstName==>\(String(describing: userFirstName)) \n userLastName==>\(String(describing: userLastName)) \n FullName==>\(String(describing: fullName)) \n EmailId==>\(String(describing: userEmail))")
            
            
            //============***************************************************============
            //var User_Id = ""
            var User_Email = ""
            var User_FirstName = ""
            var User_LastName = ""
            var User_FullName = ""
            
            if userEmail == nil {
                //self.appleIdLogout_fns()
                if Constants.userdefaults.value(forKey: "KEY_APP_APPLELOGIN_DATAS") != nil {
                    //Retrieve from UserDefaults
                    if let data = Constants.userdefaults.object(forKey: "KEY_APP_APPLELOGIN_DATAS") as? Data,
                       let category = try? JSONDecoder().decode([String : String].self, from: data) {
                        //print("Lists==>>", category[0].name)
                        
                        //User_Id = dataValidation(data: category["user_id"] as AnyObject)
                        User_Email = dataValidation(data: category["email"] as AnyObject)
                        User_FullName = dataValidation(data: category["full_name"] as AnyObject)
                    }
                    
                }
            } else {
                User_Email = dataValidation(data: userEmail as AnyObject)
                User_FirstName = dataValidation(data: userFirstName as AnyObject)
                User_LastName = dataValidation(data: userLastName as AnyObject)
                User_FullName = dataValidation(data: "\(User_FirstName) \(User_LastName)" as AnyObject)
                
                let Dict_AppleLoginData = ["token": idTokenString, "user_id": userIdentifier, "email": User_Email, "full_name": User_FullName, "first_name": User_FirstName, "last_name": User_LastName] as [String : String]
                
                //To store in UserDefaults Start,,,,,
                if let encoded = try? JSONEncoder().encode(Dict_AppleLoginData) {
                    Constants.userdefaults.set(encoded, forKey: "KEY_APP_APPLELOGIN_DATAS")
                }
                Constants.userdefaults.synchronize()
                //To store in UserDefaults End,,,,,
                
            }
            //============***************************************************============
            
            //Navigate to other view controller
            //For the purpose of this demo app, store the `userIdentifier` in the keychain.
            //self.saveUserInKeychain(userIdentifier)
            
            //For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
            //self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
            //self.controller.loginViewModel.SocialMediaLoginProcess(FullName: User_FullName, email: User_Email, token: idTokenString, LoginType: "Apple")
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            //Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username==>\(username) \n password==>\(String(describing: password))")
            //Navigate to other view controller
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.controller.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Error==>\(error.localizedDescription)")
        guard let error = error as? ASAuthorizationError else {
            return
        }
        
        switch error.code {
        case .canceled:
            print("Canceled")
        case .unknown:
            print("Unknown")
        case .invalidResponse:
            print("Invalid Respone")
        case .notHandled:
            print("Not handled")
        case .failed:
            print("Failed")
        case .notInteractive:
            print("NotInteractive")
        @unknown default:
            print("Default")
        }
    }
    
    
    func appleIdLogout_fns() {
        let alertController = UIAlertController (title: "Are sure want to logout your account?", message: "Go to device Settings -> Apple ID -> Password & Security -> Sign in with Apple / Apps Using your Apple ID -> {find your app} -> click on 'Stop Using Apple ID'", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") //Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        
        self.controller.present(alertController, animated: true, completion: nil)
    }
}
//==============================================================================
//==============================================================================
//MARK: Login with Apple Integrations works End,,,,,



