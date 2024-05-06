
import Foundation
import UIKit
import AVFoundation
//Pod Installs below 2
import MBProgressHUD
//import IQKeyboardManagerSwift
import Kingfisher

func instantiateVC(storyboardName: String , storyboardId: String) -> UIViewController {
    let storyboard = UIStoryboard(name: String(describing: storyboardName), bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: String(describing: storyboardId))
}

func loadNibwithName(name:String) -> UIView {
    return UINib(nibName: name, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
}

func updateMainQueue (_ updates : @escaping() -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

func updateSyncMainQueue (_ updates : @escaping() -> Void) {
    DispatchQueue.main.sync {
        updates()
    }
}

//MARK: /// pop back n viewcontroller
func navigationControllerPopBack(_ nb: Int , controller:UIViewController) {
    print("controller==>>\(controller) === nb==>>\(nb)")
    if let viewControllers: [UIViewController] = controller.navigationController?.viewControllers {
        guard viewControllers.count < nb else {
            controller.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
            return
        }
    }
}

//MARK: TabBarHidden or NotHidden Code Here,,,,,
func isTabBarHiddenOrNotOption(controller: UIViewController, isHidden:Bool) -> Void {
    //print("controller==>>",controller)
    DispatchQueue.main.async {
        isHidden==true ? (controller.tabBarController?.tabBar.isHidden = true) : (controller.tabBarController?.tabBar.isHidden = false)
    }
}


//
//MARK: - MBProgress
//
func showProgress(currentView:UIView) -> Void{//Show progress
    updateMainQueue {
        let mbProgress = MBProgressHUD.showAdded(to: currentView, animated: true)
        mbProgress.mode = MBProgressHUDMode.indeterminate
        mbProgress.label.text = Constants.GeneralConstants.ProgressName
        mbProgress.bezelView.color = UIColor.white
    }
}
func hideProgress(currentView:UIView) -> Void{         //Hide progress
    updateMainQueue {
        MBProgressHUD.hide(for: currentView, animated: true)
    }
}

func showProgress(currentView:UIView, frame:CGRect, tableView:UITableView) -> Void{//Show progress
    updateMainQueue {
        let mbProgress = MBProgressHUD.showAdded(to: currentView, animated: true)
        mbProgress.offset.y = -30
        mbProgress.offset.x = currentView.frame.size.width/2
        mbProgress.mode = MBProgressHUDMode.indeterminate
        //mbProgress.label.text = Constants.GeneralConstants.ProgressName
        mbProgress.bezelView.color = UIColor.clear
    }
}

//mbProgress.customView =  UIImageView(image: UIImage(named: "App_logo_100x100"))
//mbProgress.mode = MBProgressHUDMode.customView//MBProgressHUDMode.indeterminate

func showToastWithButton(message: String, font: UIFont, currentView: UIView) -> Void {
    //add label
    let toastLabel = UILabel(frame: CGRect(x: 0, y: currentView.frame.size.height-10, width: currentView.frame.width, height: 35))
    toastLabel.text = message
    toastLabel.font = font
    toastLabel.textColor = UIColor.black
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    
    //add button
    let button = UIButton.init(type: .custom)
    button.frame = CGRect.init(x: toastLabel.frame.width - 50, y: toastLabel.frame.origin.y + 20, width: 40, height: 40)
    currentView.addSubview(toastLabel)
    currentView.addSubview(button)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
        toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
}

func hasSafeArea() -> Bool {
    guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 24 else {
        return false
    }
    return true
}
func hasSafeArea_iOS16() -> Bool {
    guard #available(iOS 16.0, *), let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 24 else {
        return false
    }
    return true
}

// MARK: - Phone Number
//Format Phone number
func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
    guard !phoneNumber.isEmpty else { return "" }
    guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
    let r = NSString(string: phoneNumber).range(of: phoneNumber)
    var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
    
    if number.count > 10 {
        let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
        number = String(number[number.startIndex..<tenthDigitIndex])
    }
    
    if shouldRemoveLastDigit {
        let end = number.index(number.startIndex, offsetBy: number.count-1)
        number = String(number[number.startIndex..<end])
    }
    
    if number.count < 7 {
        let end = number.index(number.startIndex, offsetBy: number.count)
        let range = number.startIndex..<end
        number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
        
    } else {
        let end = number.index(number.startIndex, offsetBy: number.count)
        let range = number.startIndex..<end
        number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
    }
    
    return number
}

//Remove format phone number
func removeFormatPhoneNumber(numberString:String) -> String{
    return numberString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
}

//MARK: - Alert view
func customCommonAlertView (titleString:String, messageString:String) -> Void {
    let alert = UIAlertController (title: titleString, message: messageString, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction (title: "OK", style: .default, handler: nil))
	updateMainQueue {
		Constants.appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
	}
}


extension Array {
    func contains<T>(obj: T) -> Bool where T: Equatable {
        return !self.filter({$0 as? T == obj}).isEmpty
    }
}


///
//
//MARK: - Image picker authorization alert
//
func authorizationImagePickerAlert(title:String, message:String) -> Void {
    
    let alert = UIAlertController (title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)          //Open settings
    }))
    
    alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
    
Constants.appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
}

//MARK: - General Methods
func removePrefixZeroFromString(string: String) -> String? {        //remove prefix zero
    
    if string.hasPrefix("0") {
        let removedString = (string as NSString).substring(from: 1)
        return removedString
    }
    return string
}


func getRelativeDateStringForCustomer(dateString: String, dateValue:Date) -> String {      //Get relative date string
    var convertedString = ""
    if Constants.ArrayConstants.relativeDateStringArray.contains(dateString) {
        convertedString = dateString + ", " + dateValue.toLocalTime().formatMonthYearOnly()
    }
    else {
        convertedString = dateValue.toLocalTime().formatDateMonthYear()
    }
    return convertedString
}


func getRelativeDateStringForTechinician(dateString: String, dateValue:Date) -> String {      //Get relative date string
    var convertedString = ""
    if Constants.ArrayConstants.relativeDateStringArray.contains(dateString) {
        convertedString = dateString + ", " + dateValue.toLocalTime().formatMonthYearOnlyWithOutTH()
    }
    else {
        convertedString = dateValue.toLocalTime().formatDateMonthYearWithOutDay()
    }
    return convertedString
}


func convertImageToBase64String(image : UIImage ) -> String {
    let strBase64 =  image.pngData()?.base64EncodedString()
    return strBase64!
}


extension UIImage {
    func imageToBase64String() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}

extension String {
    func stringToImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

// Check Network Connection

func checkNetwork () -> Bool {
    do {
        let reachability: Reachability =  Reachability()!
        let networkStatus =  String (describing: reachability.currentReachabilityStatus)
        if (networkStatus == Constants.GeneralConstants.NetworkStatus){
            return false
        }
        return true
    }
}


extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

//MARK: Get App Display Name
extension Bundle {
    public static var getAppDisplayName: String? {
        if let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String { //?? object(forInfoDictionaryKey: "CFBundleName") as? String
            return bundleDisplayName
        } else if let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return bundleName
        } else {
            return ""
        }
    }
    public static var getAppBundleID: String? {
        if let bundleID = Bundle.main.bundleIdentifier {
            return bundleID
        } else {
            return ""
        }
    }
}


//13-01-21 kupe code start,,,,,
func profileEmptyOrNot_Fns(string: String) -> String {
    if string != "" {
        return string
    } else {
        return ""
    }
}

func videosAreEmptyOrNot_Fns(string: String) -> String {
    if string != "" {
        return string
    } else {
        return ""
    }
}

func getFirstCharOfGivenValues(string: String) -> String {
    //return string.characters.first?.description ?? ""
    if string != "" {
        let firstCharIndex = string.index(string.startIndex, offsetBy: 1)
        let firstChar = string.substring(to: firstCharIndex)
        return firstChar
    } else {
        return ""
    }
}

func getFirstLetter(value: String) -> String {
    let FirstLetter = String(value.prefix(1))
    return FirstLetter
}

func getLastLetter(value: String) -> String {
    let LastLetter = String(value.suffix(1))
    return LastLetter
}

func removeFirstLetter(value: String) -> String {
    let result = String(value.dropFirst())
    return result
}

func removeLastLetter(value: String) -> String {
    let result = String(value.dropLast())
    return result
}
//13-01-21 kupe code end,,,,,

//MARK: Get Value in-between 2 strings
extension String {
    public func slice(from: String, to: String) -> String? {
        guard let rangeFrom = range(of: from)?.upperBound else { return ""}
        guard let rangeTo = self[rangeFrom...].range(of: to)?.lowerBound else { return ""}
        
        return String(self[rangeFrom..<rangeTo])
    }
}


//MARK: Replace particular INDEX char from given STRING Start,,,,,
func replaceCharFromStringForGivenIndex_Fns(myString: String, index: Int, newChar: Character) -> String {
//func replaceCharFromStringForGivenIndex_Fns(myString: String, _ index: Int, _ newChar: Character) -> String {
    var chars = Array(myString)// gets an array of characters
    chars[index] = newChar
    let modifiedString = String(chars)
    return modifiedString
}
func replaceCharFromStringForGivenStartIndexToEndIndex_Fns(myString: String, startIndex: Int, endIndex: Int, newChar: Character) -> String {
//func replaceCharFromStringForGivenStartIndexToEndIndex_Fns(myString: String, _ startIndex: Int, _ endIndex: Int, _ newChar: Character) -> String {
    var chars = Array(myString)// gets an array of characters
    for (i,_) in chars.enumerated() {
        if i >= startIndex && i <= endIndex {
            chars[i] = newChar
        }
    }
    //chars[startIndex] = newChar
    let modifiedString = String(chars)
    return modifiedString
}
//MARK: Replace particular INDEX char from given STRING End,,,,,


//MARK: Replace particular INDEX char from given STRING Start,,,,,
func isFindGivenValueIsHyperLinkOrNot_Fns(GivenValue: String) -> Bool {
    var isPresent = false
    Constants.GlobalValues.Ary_HyperLinkValues.enumerated().forEach { (index, element) in
        if GivenValue.contains(element) {
            isPresent = true
        }
    }
    if isPresent == true {
        return true
    } else {
        return false
    }
}


public extension UIApplication {
    func clearLaunchScreenCache() {
        do {
            try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Library/SplashBoard")
        } catch {
            print("Failed to delete launch screen cache: \(error)")
        }
    }

}

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension UIApplication {
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
    var keyWindowPresentedController: UIViewController? {
        var viewController = self.keyWindow?.rootViewController
        
        // If root `UIViewController` is a `UITabBarController`
        if let presentedController = viewController as? UITabBarController {
            // Move to selected `UIViewController`
            viewController = presentedController.selectedViewController
        }
        
        // Go deeper to find the last presented `UIViewController`
        while let presentedController = viewController?.presentedViewController {
            // If root `UIViewController` is a `UITabBarController`
            if let presentedController = presentedController as? UITabBarController {
                // Move to selected `UIViewController`
                viewController = presentedController.selectedViewController
            } else {
                // Otherwise, go deeper
                viewController = presentedController
            }
        }
        
        return viewController
    }
    
}

extension UIViewController {
    func presentInKeyWindow(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?
                .present(self, animated: animated, completion: completion)
        }
    }
    
    func presentInKeyWindowPresentedController(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindowPresentedController?
                .present(self, animated: animated, completion: completion)
        }
    }
}



//============***************************************************============
//MARK: TEXTVIEW===>>Set color for particular text Start,,,,,
func setColorForGivenParticularTexts_TextView_Fns(textView: UITextView, string: String, TextColor: UIColor, TagColor: UIColor, LinkColor: UIColor, Ary_ContainValues: [String]) {
    let text = dataValidation(data: textView.text as AnyObject)
    let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font:UIFont(name: "Inter-Regular", size: 13.5)!, NSAttributedString.Key.foregroundColor: TextColor])
    
    let Ary_Comments = string.split(separator: " ")
    Ary_Comments.enumerated().forEach{ (index, element) in
        let s_ClickedValue = dataValidation(data: element as AnyObject)
        Ary_ContainValues.enumerated().forEach{ (index2, element2) in
            if s_ClickedValue.contains(element2) {
                if element2 == "@" {
                    let range:NSRange = (attributedString.string as NSString).range(of: s_ClickedValue)
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: TagColor, range: range)
                    attributedString.addAttribute(NSAttributedString.Key.link, value: s_ClickedValue, range: range)
                } else {
                    let style: [NSAttributedString.Key: Any] = [
                                .link: s_ClickedValue,
                                NSAttributedString.Key.foregroundColor: LinkColor
                            ]
                    let range:NSRange = (attributedString.string as NSString).range(of: s_ClickedValue)
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: LinkColor, range: range)
                    attributedString.addAttribute(NSAttributedString.Key.link, value: s_ClickedValue, range: range)
                    //attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
                    //attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.lightGray, range: range)
                    //attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: range)
                    //attributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.lightGray, range: range)
                    textView.linkTextAttributes = style
                }
            }//contains if End,,,,,
            
        }//for-Each End,,,,,
    }//for-Each End,,,,,
    
    textView.attributedText = attributedString
}
//MARK: TEXTVIEW===>>Set color for particular text End,,,,,


//MARK: It's used to get tapped place is Empty or Not Start,,,,,
public func IsTextViewTappedWordOrEmptyPlace_Fns(sender: UITapGestureRecognizer, myTextView: UITextView) -> Bool {
    var location = sender.location(in: myTextView)
    if let position = myTextView.closestPosition(to: location) {
        if position == myTextView.endOfDocument {
            return false
        } else {
            return true
        }
    } else {
        return false
    }
}
//MARK: It's used to get tapped place is Empty or Not End,,,,,

//MARK: TEXTVIEW===>>Get TextView Tapped Word Start,,,,,
public func getTextViewTappedWordAtPosition_Fns(sender: UITapGestureRecognizer, myTextView: UITextView) -> String? {
    let layoutManager = myTextView.layoutManager
    
    //location of tap in myTextView coordinates and taking the inset into account
    var location = sender.location(in: myTextView)
    location.x -= myTextView.textContainerInset.left;
    location.y -= myTextView.textContainerInset.top;
    
    //character index at tap location
    let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
    
    //if index is valid then do something.
    if characterIndex < myTextView.textStorage.length {
        //print the character index
        //print("character index: \(characterIndex)")
        
        //print the character at the index
        let myRange = NSRange(location: characterIndex, length: 1)
        let substring = (myTextView.attributedText.string as NSString).substring(with: myRange)
        //print("character at index: \(substring)")
        
        //check if the tap location has a certain attribute
        let attributeName = NSAttributedString.Key.link
        let attributeValue = myTextView.attributedText?.attribute(attributeName, at: characterIndex, effectiveRange: nil)
        if let value = attributeValue {
            //print("You tapped on \(attributeName.rawValue) and the value is: \(value)")
            return value as? String
        } else {
            return ""
        }
    } else {
        return ""
    }
    
}
public func getTextViewTappedIndividualWordWithOutSpecialcharAtPosition_Fns(location: CGPoint, textView: UITextView) -> String? {
    let position: CGPoint = CGPoint(x: location.x, y: location.y)
    let tapPosition: UITextPosition = textView.closestPosition(to: position)!
    let textRange: UITextRange = textView.tokenizer.rangeEnclosingPosition(tapPosition, with: UITextGranularity.word, inDirection: UITextDirection(rawValue: 1))!
    
    let tappedWord: String = textView.text(in: textRange) ?? ""
    //print("tapped word ->", tappedWord)
    
    return tappedWord
}
//MARK: TEXTVIEW===>>Get TextView Tapped Word End,,,,,


//MARK: LABLE===>>Set color for particular text Start,,,,,
public func setColorForGivenParticularTexts_Lable_Fns(lable:UILabel, string: String, TextColor: UIColor, Ary_ContainValues: [String]) {
    //Set color for particular text Start,,,,,
    let text = dataValidation(data: lable.text as AnyObject)
    
    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text)
    
    let Ary_Comments = string.split(separator: " ")
    Ary_Comments.enumerated().forEach{ (index, element) in
        let s_ClickedValue = dataValidation(data: element as AnyObject)
        Ary_ContainValues.enumerated().forEach{ (index2, element2) in
            if s_ClickedValue.contains(element2) {
                if element2 == "@" {
                    attributedString.setColor_NSAttributedString(color: Constants.ColorSet.ColorAppThemeMain!, forText: s_ClickedValue)
                } else {
                    attributedString.setColor_NSAttributedString(color: TextColor, forText: s_ClickedValue)
                }
            }//contains if End,,,,,
        }//for-Each End,,,,,
    }//for-Each End,,,,,
    
    lable.attributedText = attributedString
    //Set color for particular text End,,,,,
}

public func setColorForParticularTexts_Lable_Fns(lable:UILabel, string: String) {
    //Set color for particular text Start,,,,,
    let text = dataValidation(data: lable.text as AnyObject)
    
    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text)
    
    let Ary_Comments = string.split(separator: " ")
    Ary_Comments.enumerated().forEach{ (index, element) in
        let s_ClickedValue = dataValidation(data: element as AnyObject)
        if s_ClickedValue.contains("@") {
            attributedString.setColor_NSAttributedString(color: Constants.ColorSet.ColorAppThemeMain!, forText: s_ClickedValue)
        }//contains if End,,,,,
    }//for-Each End,,,,,
    
    lable.attributedText = attributedString
    //Set color for particular text End,,,,,
}
//MARK: LABLE===>>Set color for particular text End,,,,,
//============***************************************************============



public func getCurrentViewController(_ vc: UIViewController) -> UIViewController? {
    if let pvc = vc.presentedViewController {
        return getCurrentViewController(pvc)
    }
    else if let svc = vc as? UISplitViewController, svc.viewControllers.count > 0 {
        return getCurrentViewController(svc.viewControllers.last!)
    }
    else if let nc = vc as? UINavigationController, nc.viewControllers.count > 0 {
        return getCurrentViewController(nc.topViewController!)
    }
    else if let tbc = vc as? UITabBarController {
        if let svc = tbc.selectedViewController {
            return getCurrentViewController(svc)
        }
    }
    return vc
}
// Returns the most recently presented UIViewController (visible)
public func getCurrentViewController() -> UIViewController? {
    // If the root view is a navigation controller, we can just return the visible ViewController
    if let navigationController = getNavigationController() {

        return navigationController.visibleViewController
    }

    // Otherwise, we must get the root UIViewController and iterate through presented views
    if let rootController = UIApplication.shared.keyWindow?.rootViewController {

        var currentController: UIViewController! = rootController

        // Each ViewController keeps track of the view it has presented, so we
        // can move from the head to the tail, which will always be the current view
        while( currentController.presentedViewController != nil ) {

            currentController = currentController.presentedViewController
        }
        return currentController
    }
    return nil
}

// Returns the navigation controller if it exists
public func getNavigationController() -> UINavigationController? {
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController  {
        return navigationController as? UINavigationController
    }
    return nil
}

func imageCenterCropViaMinSide_Fns(sourceImage: UIImage)  -> UIImage? {
    /*let sourceImage = UIImage(
        named: "imageNameInBundle"
    )!*/
    
    //The shortest side
    let sideLength = min(
        sourceImage.size.width,
        sourceImage.size.height
    )
    
    // Determines the x,y coordinate of a centered
    // sideLength by sideLength square
    let sourceSize = sourceImage.size
    let xOffset = (sourceSize.width - sideLength) / 2.0
    let yOffset = (sourceSize.height - sideLength) / 2.0

    // The cropRect is the rect of the image to keep,
    // in this case centered
    let cropRect = CGRect(
        x: xOffset,
        y: yOffset,
        width: sideLength,
        height: sideLength
    ).integral

    // Center crop the image
    let sourceCGImage = sourceImage.cgImage!
    let croppedCGImage = sourceCGImage.cropping(
        to: cropRect
    )!
    
    //var uiImageOrientation = UIImage.Orientation.up
    let image = UIImage(cgImage: croppedCGImage, scale: 1, orientation: UIImage.Orientation.up)
    return image
}

func imageCenterCrop_Fns(sourceImage: UIImage)  -> UIImage? {
    /*let sourceImage = UIImage(
        named: "imageNameInBundle"
    )!*/
    
    // The longest side
    let sideLength = min(
        sourceImage.size.width,
        sourceImage.size.height
    )
    
    // Determines the x,y coordinate of a centered
    // sideLength by sideLength square
    let sourceSize = sourceImage.size
    let xOffset = (sourceSize.width - sideLength) / 2.0
    let yOffset = (sourceSize.height - sideLength) / 2.0
    
    // The cropRect is the rect of the image to keep,
    // in this case centered
    let cropRect = CGRect(
        x: xOffset,
        y: yOffset,
        width: sideLength,
        height: sideLength
    ).integral
    
    // Center crop the image
    let sourceCGImage = sourceImage.cgImage!
    let croppedCGImage = sourceCGImage.cropping(
        to: cropRect
    )!
    
    //var uiImageOrientation = UIImage.Orientation.up
    let image = UIImage(cgImage: croppedCGImage, scale: 1, orientation: UIImage.Orientation.up)
    return image
}


/*if let thumbnailImage = getThumbnailImage(forUrl: url) {
    cell.imgVw_FeedMainImage.image = thumbnailImage
}*/

func getThumbnailImage_UsingKingfisher(forUrl url: URL) -> UIImage? {
    //guard let url = URL(string: url) else { return }
    //self.imageView.kf.setImage(with: AVAssetImageDataProvider(assetURL: url, seconds: 1))
    
    let thumbnailImage = AVAssetImageDataProvider(assetURL: url, seconds: 1)
    return UIImage(cgImage: thumbnailImage as! CGImage)
}
func getThumbnailImage(forUrl url: URL) -> UIImage? {
    let asset: AVAsset = AVAsset(url: url)
    let imageGenerator = AVAssetImageGenerator(asset: asset)

    do {
        let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil) //100
        return UIImage(cgImage: thumbnailImage)
    } catch let error {
        print("error==>>", error)
    }

    return nil
}
func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
    DispatchQueue.global().async { //1
        let asset = AVAsset(url: url) //2
        let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
        avAssetImageGenerator.appliesPreferredTrackTransform = true //4
        let thumnailTime = CMTimeMake(value: 2, timescale: 1) //100 //5
        do {
            let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
            let thumbNailImage = UIImage(cgImage: cgThumbImage) //7
            DispatchQueue.main.async { //8
                completion(thumbNailImage) //9
            }
        } catch {
            print(error.localizedDescription) //10
            DispatchQueue.main.async {
                completion(nil) //11
            }
        }
    }
}
func createVideoThumbnail( url: String?,  completion: @escaping ((_ image: UIImage?)->Void)) {
    
    guard let url = URL(string: url ?? "") else { return }
    DispatchQueue.global().async {
        
        let url = url as URL
        let request = URLRequest(url: url)
        let cache = URLCache.shared
        
        if
            let cachedResponse = cache.cachedResponse(for: request),
            let image = UIImage(data: cachedResponse.data)
        {
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        time.value = min(time.value, 2) //100
        
        var image: UIImage?
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            image = UIImage(cgImage: cgImage)
        } catch { DispatchQueue.main.async {
            completion(nil)
        } }
        
        if
            let image = image,
            let data = image.pngData(),
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        {
            let cachedResponse = CachedURLResponse(response: response, data: data)
            
            cache.storeCachedResponse(cachedResponse, for: request)
        }
        
        DispatchQueue.main.async {
            completion(image)
        }
        
    }
    
}

//MARK: Protocals
/*
 *****Vc
 1. Add protocal delegates
 , customDatePickerDelegates
 
 2.//MARK: - Instance variables
 var datePickerXIBView:DatePickerCustomVw?
 
 3.Call and intiate that
 //MARK: - Instance Methods
 func createDatePickerView_Fns() -> Void {
     datePickerXIBView?.removeFromSuperview()
     datePickerXIBView = Bundle.main.loadNibNamed("DatePickerCustomVw", owner: self, options: nil)?.first as? DatePickerCustomVw
     datePickerXIBView?.frame = CGRect.init(x: 0, y: homePageView.frame.size.height-220, width: homePageView.frame.size.width, height: 220)
     datePickerXIBView?.buttonPressedDelegate = self
     homePageView.addSubview(datePickerXIBView!)
 }
 func pickerDonePressed() {
     let d_selectedDate = datePickerXIBView?.datePicker.date as NSDate?
     print("d_selectedDate==>>",d_selectedDate ?? NSDate())
 }
 func pickerCancelPressed() {
     datePickerXIBView?.isHidden = true
 }
 
 *****Protocall page :
 protocol customDatePickerDelegates {
    func pickerDonePressed()
    func pickerCancelPressed()
 }
 
 var buttonPressedDelegate:customDatePickerDelegates!
 
 @IBAction func pickerCancelBtn_Pressed(_ sender: Any) {
     //print("pickerCancelBtn_Pressed")
     buttonPressedDelegate.pickerCancelPressed()
 }
 @IBAction func pickerDoneBtn_Pressed(_ sender: Any) {
     //print("pickerDoneBtn_Pressed")
     //print(datePicker.date)
     buttonPressedDelegate.pickerDonePressed()
 }
 

 */
