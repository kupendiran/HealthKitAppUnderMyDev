
import Foundation
import UIKit
//Pod Installs below 2
import MBProgressHUD
//import IQKeyboardManagerSwift
/*
 pod 'MBProgressHUD', '~> 1.1.0'
 pod 'IQKeyboardManagerSwift', '~> 6.2.0'
 */

final class NetworkManager {
    typealias CompletionHandler = (_ result : [Any]? , _ error : Error?) -> Void
    public static let shared = NetworkManager()
    public init() {
        print("Singleton initialized")
    }
    
    func getAPI ( url : String , onCompletion : @escaping CompletionHandler ) {
        print("GET API URL :\(url)")
        guard checkNetwork() else { return }        //check network
        showProgress()
        guard let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {return}
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.hideProgress()
            if let data = data {
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                        print("URL :\(url) Response :\(String(describing: json))")
                        onCompletion( json , nil )
                    }
                    //                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    //                    print("URL :\(url) Response :\(String(describing: json))")
                    //                    if let response = json , let status = response["status"] as? String {
                    //                        onCompletion( status == "1" ? json : nil , nil )
                    //                    }
                } catch {
                    onCompletion(nil, error)
                }
            }
            }.resume()
        
    }
    
    
    public func postAPI( url : String , withHeader : Bool , post params : [String : Any] , onCompletion:@escaping CompletionHandler) {
        guard checkNetwork() else { return }        //check network
        self.showProgress()
        //print("POST API Url :\(url) - Params:\(params)")
        guard let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {return}
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if withHeader {
            guard let accesstoken = UserDefaults.standard.value(forKey: Constants.Keys.Access_token) else {
                return
            }
            print(accesstoken)
            let headers = [ "Authorization": "Bearer \(accesstoken)"]
            request.allHTTPHeaderFields = headers
        }
        print(request.allHTTPHeaderFields)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            self.hideProgress()
            if let data = data {
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                        print("json===>>", json)
                        onCompletion( json , nil )
                    } else {
                        print("error===>>", "error")
                    }
                    //                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    //                    print("response :\(json)")
                    //                    onCompletion( json , nil )
                } catch {
                    onCompletion(nil, error)
                }
            }
            }.resume()
    }
    
    public func putDeleteAPI( url : String , post params : [String : Any]? , onCompletion:@escaping CompletionHandler) {
        guard checkNetwork() else { return }        //check network
        showProgress()
        print("API Url :\(url) - Params:\(String(describing: params))")
        guard let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {return}
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        if let _ = params {
            request.httpMethod = "PUT"
        } else {
            request.httpMethod = "DELETE"
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        // request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        if let reqParam = params {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: reqParam, options: []) else { return }
            request.httpBody = httpBody
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            self.hideProgress()
            if let data = data {
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                        print(json)
                        onCompletion( json , nil )
                    }
                    //                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    //                    print("response :\(json)")
                    //                    onCompletion( json , nil )
                } catch {
                    onCompletion(nil, error)
                }
            }
            }.resume()
    }
    
    public func uploadImage(requestUrl: String,requestBody:AnyObject?, image: UIImage, imageName:String, onCompletion: @escaping ((_ obj: Any)->())) {
        if checkNetwork(){
            //
            let imageData = image.jpegData(compressionQuality: 1.0)
            var request = URLRequest(url: URL(string: requestUrl)!)
            request.httpMethod = "POST"
            //            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
            
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.setValue("kisscam", forHTTPHeaderField: "tenant")
            let body = NSMutableData();
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            body.append("Content-Disposition: form-data; name=\"\("id")\"\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            body.append("\(24)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            
            if requestBody != nil {
                for (key, value) in requestBody as? Dictionary<String,Any> ?? [:] {
                    if value is NSDictionary{
                        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                        body.append("\(value)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                        
                    }
                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                    body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                    body.append("\(value)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                }
            }
            
            let filename = imageName//"note.jpg"
            let mimetype = "image/png"
            let filePathKey = "profile_picture"
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            body.append(imageData!)
            body.append("\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            request.httpBody = body as Data
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil
                {
                    print("error=\(error ?? "" as! Error)")
                    onCompletion(error as AnyObject)
                    return
                }
                // You can print out response object
                print("******* response = \(String(describing: response))")
                
                // Print out reponse body
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("****** response data = \(responseString!)")
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    onCompletion(json)
                } catch let error {
                    print(error)
                    onCompletion("No Internet connection" as Any)
                }
                
            }
            task.resume()
        }
        else{
            onCompletion("No Internet connection" as AnyObject)
        }
    }
}






//MARK: Reachability & MBProgress HUD
extension NetworkManager {
    
    func checkNetwork () -> Bool{
        do {
            let reachability: Reachability =  Reachability()!
            let networkStatus =  String (describing: reachability.currentReachabilityStatus)
            if (networkStatus == "No Connection"){
                self.showAlert(withTitle: "No Connection!", messageString: "Please try again later")
                return false
            }
            return true
        }
    }
    
    public func showProgress () -> Void {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else {
                return
            }
            let mbProgress = MBProgressHUD.showAdded(to: window , animated: true)
            mbProgress.mode = MBProgressHUDMode.indeterminate
            mbProgress.label.text = "Please wait..."
            mbProgress.bezelView.color = UIColor.white
        }
    }
    public func hideProgress () -> Void {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else {
                return
            }
            MBProgressHUD.hide(for: window , animated: true)
        }
    }
    
    //MARK: - Alert view
    public func showAlert(withTitle titleString:String, messageString:String) -> Void {
        let alert = UIAlertController (title: titleString, message: messageString, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction (title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else {
                return
            }
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
}





extension NetworkManager {
    
    public func onlyDeleteAPI( url : String , post params : [String : Any]? , onCompletion:@escaping CompletionHandler) {
        guard checkNetwork() else { return }        //check network
        showProgress()
        print("API Url :\(url) - Params:\(String(describing: params))")
        guard let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {return}
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        /*if let _ = params {
         request.httpMethod = "PUT"
         } else {*/
        request.httpMethod = "DELETE"
        //}
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        // request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        if let reqParam = params {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: reqParam, options: []) else { return }
            request.httpBody = httpBody
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            self.hideProgress()
            if let data = data {
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                        print("json==>>", json)
                        onCompletion( json , nil )
                    }
                    //                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    //                    print("response :\(json)")
                    //                    onCompletion( json , nil )
                } catch {
                    onCompletion(nil, error)
                }
            }
            }.resume()
    }
    
    
    public func postWithCustomContentTypeAPI( url : String , withHeader : Bool , post params : [String : Any] , onCompletion:@escaping CompletionHandler) {
        guard checkNetwork() else { return }        //check network
        self.showProgress()
        print("POST API Url :\(url) - Params:\(params)")
        guard let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {return}
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if withHeader {
            /*guard let accesstoken = UserDefaults.standard.value(forKey: Constants.Keys.Access_token) else {
             return
             }
             print(accesstoken)*/
            let headers = ["Content-Type": "application/x-www-form-urlencoded"]
            request.allHTTPHeaderFields = headers
        }
        print(request.allHTTPHeaderFields)
        //,"Content-Type": "application/x-www-form-urlencoded"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            self.hideProgress()
            if let data = data {
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                        print(json)
                        onCompletion( json , nil )
                    }
                    //                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    //                    print("response :\(json)")
                    //                    onCompletion( json , nil )
                } catch {
                    onCompletion(nil, error)
                }
            }
            }.resume()
    }
}



//MARK: ViewController
/*
 self.jobView.setController(controller: self)
 self.jobVM.setController(controller: self)
 
 
 self.projListModel = ProjectsListModel()
 //MARK: - Instance variables
 self.projListModel?.GETProjectsList(onCompletion: {(resultType, result, error) in
     if error == nil {
         updateMainQueue {
             print("resultttt====>>", result as Any)
             self.showCaseProjList_View.projectsListTableVw.reloadData()
         }
     }else{
         guard let error = error else { return }
         switch error {
         case .error(let reason):
             updateMainQueue {
                 self.showAlert(title: reason!, message: "")
             }
             break
         }
     }
 })
 
 */


//MARK: Model
/*
 
 import Foundation

 class ProjectsListModel : BaseModel {
     
     var arrProjectsList: [ProjectListContentModel]?
     override init() {
         arrProjectsList = []
     }
     func GETProjectsList(onCompletion: @escaping completionBlock) {
         arrProjectsList?.removeAll()
         
         if let userId = Constants.userdefaults.value(forKey: Constants.Keys.Id) {
             NetworkManager.shared.getAPI(url: Constants.API.GET_ProjectListAPI + "user_id=\(userId)") { (response, error, statusCode) in
                 if error == nil { // success
                     if let response = response as? [[String: Any]] {
                         
                         for (index,item) in response.enumerated() {
                             print("Index:\(index) --- item:\(item)")
                             
                             if let stat = item["status"] as? String {
                                 if stat ==  "error" {
                                     if let msg = item["message"] as? String {
                                         onCompletion(nil,nil,.error(reason: msg))
                                         return
                                     }
                                 }
                             }
                             else {
                                 let model = ProjectListContentModel()
                                 model.id = item["id"] as? String
                                 model.name = item["project_name"] as? String
                                 model.workedAs = item["worked_as"] as? String
                                 model.FromDate = item["proj_from"] as? String
                                 model.ToDate = item["proj_to"] as? String
                                 model.description = item["proj_description"] as? String
                                 model.videoLink = item["proj_video_link"] as? String
                                 model.isDelete = item["is_delete"] as? Bool
                                 
                                 self.arrProjectsList?.append(model)
                             }
                         }
                         if self.arrProjectsList!.count > 0 {
                             onCompletion(.arrayType , self.arrProjectsList , nil)
                         }
                         
                     }
                     
                 } else { //failure
                     var errorMessage: String = ""
                     if let response = response as? [[String: Any]] {
                         
                         for (index,item) in response.enumerated() {
                             print("Index:\(index) --- item:\(item)")
                             errorMessage = item["message"] as! String
                         }
                         
                     }
                     onCompletion(nil , nil , .error(reason: errorMessage))
                 }
             }
         }
     }
     
    
     func getAllData() -> [ProjectListContentModel]? {
         return self.arrProjectsList!.isEmpty ? nil : self.arrProjectsList
     }
     
     func getData(at Index:Int) -> ProjectListContentModel? {
         if Index < self.getDataCount() {
             guard let data = self.arrProjectsList?[Index] else {
                 return nil
             }
             return data
         } else {
             return nil
         }
     }
     
     func getDataCount() -> Int {
         return self.arrProjectsList!.isEmpty ? 0 : self.arrProjectsList!.count
     }
     
     
 }



 class ProjListModel : BaseModel {
     var name : String?
     var FromDate : String?
     var ToDate : String?
 }

 class ProjectListContentModel : BaseModel {
     var id : String?
     var name : String?
     var workedAs : String?
     var FromDate : String?
     var ToDate : String?
     var description : String?
     var videoLink : String?
     var isDelete : Bool?
     
     override func logData() {
         super.logData()
         
         print("id:\(String(describing: self.name)) --\n email:\(String(describing: self.FromDate))")
     }
 }

 */
