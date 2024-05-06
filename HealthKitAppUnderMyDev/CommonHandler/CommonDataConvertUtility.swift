//
//  CommonDataConvertUtility.swift
//  Piechips
//
//  Created by Kupendiran Alagarsamy on 05/11/22.
//

import Foundation
import UIKit
//import CoreData
//Pod Installs below 2
import MBProgressHUD
import ANActivityIndicator
import Kingfisher

class CommonDataConvertUtility {
    var vSpinner : UIView?
}

func getRandomNumber() -> Int {
    return Int.random(in: 1...10000000)
}
func getRandomNumber(isWant: String) -> String {
    let RandomValue = Int.random(in: 1...10000000)
    return dataValidation(data: RandomValue as AnyObject)
}


func joint_Given1Text_Fns(mainText: String, text1: String) -> String {
    let msg:String = String(format: "\(mainText)", text1)
    //print("msg===>>", msg)
    return msg
}
func joint_Given2Texts_Fns(mainText: String, text1: String, text2: String, text3: String) -> String {
    let msg:String = String(format: "\(mainText)", text1, text2, text3)
    //print("msg===>>", msg)
    return msg
}


func kf_downloadImageFromUrl_Fns(`with` urlString:String, imageCompletionHandler: @escaping (UIImage?) -> Void){
    guard let url = URL.init(string: urlString) else {
        return  imageCompletionHandler(nil)
    }
    
    let resource = ImageResource(downloadURL: url)
    KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
        switch result {
        case .success(let value):
            imageCompletionHandler(value.image)
        case .failure:
            imageCompletionHandler(nil)
        }
    }
    
    /*let resource = ImageResource(downloadURL: s_avatarUrl!)
    KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
        switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
                cell.imgVw_MainImage.image = value.image
            case .failure(let error):
                print("Error: \(error)")
        }
    }*/
    
}
func kf_downloadImageFromUrl_WithForceRefresh_Fns(`with` urlString:String, imageCompletionHandler: @escaping (UIImage?) -> Void){
    guard let url = URL.init(string: urlString) else {
        return  imageCompletionHandler(nil)
    }
    
    let resource = ImageResource(downloadURL: url)
    KingfisherManager.shared.retrieveImage(with: resource, options: [.forceRefresh], progressBlock: nil) { result in
        switch result {
        case .success(let value):
            imageCompletionHandler(value.image)
        case .failure:
            imageCompletionHandler(nil)
        }
    }
}

extension UIImageView {
    func normal_downloadImageFromUrl_Fns(from url: URL, contentMode mode: ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func normal_downloadImageFromUrl_Fns(from link: String, contentMode mode: ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        normal_downloadImageFromUrl_Fns(from: url, contentMode: mode)
    }
}
extension UIImageView {

public func getImageFromURLString(imageURLString: String) {
    guard let imageURL = URL(string: imageURLString) else { return}
    Task {
        await requestImageFromURL(imageURL)
    }
}

private func requestImageFromURL(_ imageURL: URL) async{
    let urlRequest = URLRequest(url: imageURL)
    do {
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse{
            if httpResponse.statusCode == 200{
                print("Fetched image successfully")
            }
        }
        // Loading the image here
        self.image = UIImage(data: data)
    } catch let error {
        print(error)
    }
}
}

/*
fetchImage(from: s_msgImgUrl) { (imageData) in
         if let data = imageData {
             // referenced imageView from main thread
             // as iOS SDK warns not to use images from
             // a background thread
             DispatchQueue.main.async {
 }
 }
 }
 */
func fetchImage(from urlString: String, completionHandler: @escaping (_ data: Data?) -> ()) {
    let session = URLSession.shared
    let url = URL(string: urlString)
        
    let dataTask = session.dataTask(with: url!) { (data, response, error) in
        if error != nil {
            print("Error fetching the image! 😢")
            completionHandler(nil)
        } else {
            completionHandler(data)
        }
    }
        
    dataTask.resume()
}


func TabBarControllerCommonWorks_Fns(tabBarController: UITabBarController) {
    
    //=====================================================
    /*if let tabItems = tabBarController.tabBar.items {
        let tabItem = tabItems[4]
        //tabItem.badgeValue = "1"
        let UnReadNotificationCount = Constants.userdefaults.value(forKey: Constants.Keys.KEY_UNREAD_NOTIFICATIONS_COUNT)
        if UnReadNotificationCount != nil {
            if dataValidation(data: UnReadNotificationCount as AnyObject) != "0" {
                tabItem.badgeValue = dataValidation(data: UnReadNotificationCount as AnyObject)
            } else if dataValidation(data: UnReadNotificationCount as AnyObject) == "0" {
                tabItem.badgeValue = nil
            }
        }
    }*/
    //=====================================================
    
}


func ShareAppToRedirectPage_Fns() {
    if let appURL = URL(string: Constants.CommonWebsiteLinks.LINK_APPSTORE) {
        UIApplication.shared.open(appURL) { success in
            if success {
                print("The URL was delivered successfully.")
            } else {
                print("The URL failed to open.")
            }
        }
    } else {
        print("Invalid URL specified.")
    }
}



extension CommonDataConvertUtility {
    func showSpinner(currentView: UIView, tableView: UITableView) {
        let spinnerView = UIView.init(frame: CGRect(x: currentView.frame.width/2, y: 10, width: 50, height: 50))
        //spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ActIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium) //UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)) //
        //ActIndicator.style = UIActivityIndicatorView.Style.medium
        ActIndicator.color = UIColor.red
        ActIndicator.startAnimating()
        ActIndicator.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ActIndicator)
            currentView.addSubview(spinnerView)
        }
        
        self.vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}


class ANActivityIndicator {
    var AN_Indicator : ANActivityIndicatorView?
    
    func ShowProgress_ANActiIndi_Fns(currentView: UIView, CGrect: CGRect, color: UIColor, padding: CGFloat) -> Void {
        let indicator = ANActivityIndicatorView.init(
                frame: CGrect,
                animationType: ANActivityIndicatorAnimationType.lineSpinFadeLoader,
                color: color,
                padding: padding)
        
        currentView.addSubview(indicator)
        
        AN_Indicator = indicator
        
        DispatchQueue.main.async {
            indicator.startAnimating()
        }
    }
    
    func HideProgress_ANActiIndi_Fns() -> Void {
        DispatchQueue.main.async {
            self.AN_Indicator?.stopAnimating()
        }
    }
    
}


class LoadMoreActivityIndicator {

    private let spacingFromLastCell: CGFloat
    private let spacingFromLastCellWhenLoadMoreActionStart: CGFloat
    private weak var activityIndicatorView: UIActivityIndicatorView?
    private weak var scrollView: UIScrollView?

    private var defaultY: CGFloat {
        guard let height = scrollView?.contentSize.height else { return 0.0 }
        return height + spacingFromLastCell
    }
    
    deinit { activityIndicatorView?.removeFromSuperview() }

    init (scrollView: UIScrollView, spacingFromLastCell: CGFloat, spacingFromLastCellWhenLoadMoreActionStart: CGFloat) {
        self.scrollView = scrollView
        self.spacingFromLastCell = spacingFromLastCell
        self.spacingFromLastCellWhenLoadMoreActionStart = spacingFromLastCellWhenLoadMoreActionStart
        let size:CGFloat = 40
        let frame = CGRect(x: (scrollView.frame.width-size)/2, y: scrollView.contentSize.height + spacingFromLastCell, width: size, height: size)
        let activityIndicatorView = UIActivityIndicatorView(frame: frame)
        if #available(iOS 13.0, *)
        {
            activityIndicatorView.color = .label
        }
        else
        {
            activityIndicatorView.color = .black
        }
        activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        activityIndicatorView.hidesWhenStopped = true
        scrollView.addSubview(activityIndicatorView)
        self.activityIndicatorView = activityIndicatorView
    }

    private var isHidden: Bool {
        guard let scrollView = scrollView else { return true }
        return scrollView.contentSize.height < scrollView.frame.size.height
    }

    func start(closure: (() -> Void)?) {
        guard let scrollView = scrollView, let activityIndicatorView = activityIndicatorView else { return }
        let offsetY = scrollView.contentOffset.y
        activityIndicatorView.isHidden = isHidden
        if !isHidden && offsetY >= 0 {
            let contentDelta = scrollView.contentSize.height - scrollView.frame.size.height
            let offsetDelta = offsetY - contentDelta
            
            let newY = defaultY-offsetDelta
            if newY < scrollView.frame.height {
                activityIndicatorView.frame.origin.y = newY
            } else {
                if activityIndicatorView.frame.origin.y != defaultY {
                    activityIndicatorView.frame.origin.y = defaultY
                }
            }

            if !activityIndicatorView.isAnimating {
                if offsetY > contentDelta && offsetDelta >= spacingFromLastCellWhenLoadMoreActionStart && !activityIndicatorView.isAnimating {
                    activityIndicatorView.startAnimating()
                    closure?()
                }
            }

            if scrollView.isDecelerating {
                if activityIndicatorView.isAnimating && scrollView.contentInset.bottom == 0 {
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        if let bottom = self?.spacingFromLastCellWhenLoadMoreActionStart {
                            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
                        }
                    }
                }
            }
        }
    }

    func stop(completion: (() -> Void)? = nil) {
        guard let scrollView = scrollView , let activityIndicatorView = activityIndicatorView else { return }
        let contentDelta = scrollView.contentSize.height - scrollView.frame.size.height
        let offsetDelta = scrollView.contentOffset.y - contentDelta
        if offsetDelta >= 0 {
            UIView.animate(withDuration: 0.3, animations: {
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }) { _ in completion?() }
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            completion?()
        }
        activityIndicatorView.stopAnimating()
    }
}


func ReloadSectionsForWhicUserSelected_Fns(indexSet: IndexSet, tableVw: UITableView) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.500) {
        tableVw.setNeedsLayout()
        tableVw.layoutIfNeeded()
        //tableVw.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            UIView.performWithoutAnimation {
                //let firstIndexPath = IndexPath(row: 0, section: index)
                //tableVw.reloadRows(at: [firstIndexPath], with: .none)
                tableVw.reloadSections(indexSet, with: .none)
                //tableVw.setContentOffset(CGPoint.zero, animated: true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                UIView.performWithoutAnimation {
                    tableVw.beginUpdates()
                    tableVw.endUpdates()
                }
            }
        }
    }
}








//MARK: This is upload image PUT method Orginal source using new concept "DispatchSemaphore" Start,,,,,
/*
 import Foundation
 #if canImport(FoundationNetworking)
 import FoundationNetworking
 #endif

 var semaphore = DispatchSemaphore (value: 0)

 let parameters = "<file contents here>"
 let postData = parameters.data(using: .utf8)

 var request = URLRequest(url: URL(string: "https://piechips.s3.ap-south-1.amazonaws.com/assets/morning_post.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5QFQREWEE6XOATWY%2F20221129%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Date=20221129T102754Z&X-Amz-Expires=3600&X-Amz-Signature=c67d74643a82647aa01c726df3067c9d6aa80f2776b3b951ad59f1cfeeb50be1&X-Amz-SignedHeaders=host")!,timeoutInterval: Double.infinity)
 request.addValue("image/png", forHTTPHeaderField: "Content-Type")

 request.httpMethod = "PUT"
 request.httpBody = postData

 let task = URLSession.shared.dataTask(with: request) { data, response, error in
   guard let data = data else {
     print(String(describing: error))
     semaphore.signal()
     return
   }
   print(String(data: data, encoding: .utf8)!)
   semaphore.signal()
 }

 task.resume()
 semaphore.wait()
 */
//MARK: This is upload image PUT method Orginal source using new concept "DispatchSemaphore" End,,,,,

//MARK: This is upload images via PUT method MULTI DATA using new concept "DispatchSemaphore" Start,,,,,
/*
 func putUploadFilesAPI(url: String, accessToken: String, filesContentTypes: [String], filesDatas:[Data], post params: [String : Any], completionHandler:@escaping (_ result: [String : Any]?, _ error: Error?, _ statusCode: Int?) -> Void) {
     print("API Url :\(url) - Params:\(params)")
     guard let serviceUrl = URL(string: url) else { return }
     
     let semaphore = DispatchSemaphore (value: 0)
     let parameters = String(decoding: filesDatas[0], as: UTF8.self) //"<file contents here>"
     let postData = filesDatas[0]//parameters.data(using: .utf8)
     
     var request = URLRequest(url: serviceUrl,timeoutInterval: Double.infinity)
     request.addValue(filesContentTypes[0], forHTTPHeaderField: "Content-Type")
     //Manually Added Here Start,,,,,
     //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
     //request.addValue("application/json", forHTTPHeaderField: "Accept")
     //request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
     //Manually Added Here End,,,,,
     
     request.httpMethod = "PUT"
     request.httpBody = postData
     
     let task = URLSession.shared.dataTask(with: request) { data, response, error in
         let res = response as? HTTPURLResponse
         //print("response===>>", response ?? "--")
         print("statusCode===>>", res?.statusCode ?? 0)
         /*guard let data = data else {
             print(String(describing: error))
             semaphore.signal()
             return
         }
         print("UploadImageData===>>", String(data: data, encoding: .utf8)!)
         semaphore.signal()*/
         if let data = data {
             print("UploadImageData===>>", String(data: data, encoding: .utf8)!)
             do {
                 let httpResponse = response as? HTTPURLResponse
                 print("httpResponse===>>", httpResponse?.statusCode ?? 0)
                 //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                 //let json = response as? HTTPURLResponse
                 //print("response :\(json)")
                 //do stuff.
                 if res?.statusCode == 200 {
                     semaphore.signal()
                     completionHandler( ["status": "success"], nil, res?.statusCode ?? 0 )
                 } else {
                     semaphore.signal()
                     completionHandler(nil, error, res?.statusCode ?? 0 )
                 }
             } catch {
                 semaphore.signal()
                 completionHandler(nil, error, res?.statusCode ?? 0 )
             }
             
         } else {
             semaphore.signal()
             completionHandler(nil, error, res?.statusCode ?? 0 )
         }
     }
     
     task.resume()
     semaphore.wait()
 }
 */
//MARK: This is upload images via PUT method MULTI DATA using new concept "DispatchSemaphore" End,,,,,
