//
//  ConnectionHandler.swift
//  TheHub
//
//  Created by Yamini on 27/10/20.
//  Copyright © 2020 Yamini. All rights reserved.
//

import Foundation
import UIKit

final class ConnectionHandler {
    static let shared = ConnectionHandler()
    private init() {
	 print("ConnectionHandler singleton initialized")
    }
    
    func getAPI(url1: String, accessToken: String, completionHandler: @escaping(_ result: [String : Any]?, _ error: Error?, _ statusCode: Int?) -> Void) {
        print("API Url :\(url1), Access token: \(accessToken)")
        guard let url = URL(string: url1) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
        //print("url:->\(url)")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let httpUrlsResponse = response as? HTTPURLResponse
                print("StatusCode===>>", httpUrlsResponse?.statusCode ?? 0)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                     print("URL :\(url) -- Response:\(json)")
                     if (url1.range(of: "/users/me") != nil) {
                        if (url1.range(of: "users/me/forgot")) != nil {
                            
                        } else {
                            Constants.userdefaults.set(json, forKey: Constants.Keys.UserDetails)
							if let userID = json!["_id"] {
								Constants.userdefaults.set("\(userID)", forKey: Constants.Keys.Id)
							}
							Constants.userdefaults.synchronize()
                        }
                     }
                    
                    completionHandler(json, nil, httpUrlsResponse?.statusCode ?? 0)
                } catch {
                    //print("Error111===>>", error)
                    completionHandler(nil, error, httpUrlsResponse?.statusCode ?? 0)
                }
            }
        }.resume()
    }
    
    
    func postAPI(url: String, post params: [String : Any], completionHandler:@escaping (_ result: [String : Any]?, _ error: Error?, _ statusCode: Int?) -> Void) {
        //print("API Url :\(url) - Params:\(params)")
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var accessToken = String()
        
        //if (url.range(of: "/auth/login") != nil || url.range(of: "/users/signup") != nil) {
        if (url.range(of: Constants.API.URL_USERS_LOGIN) != nil || url.range(of: Constants.API.URL_USERS_SIGNUP) != nil) { //"/auth/login" //"/users/signup"
            accessToken = ""
        } else {
            accessToken = dataValidation(data: Constants.userdefaults.value(forKey: Constants.Keys.Access_token) as AnyObject)
        }
        
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        //request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
    
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let httpUrlsResponse = response as? HTTPURLResponse
                print("StatusCode===>>", httpUrlsResponse?.statusCode ?? 0)
                do {
                    //if let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:Any] {
                    //print(json)
                    //completionHandler(json, nil, httpUrlsResponse?.statusCode ?? 0)
                    //}
					
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    print("URL :\(url) -- Params:\(params) -- Response :\(json)")
                    completionHandler(json, nil, httpUrlsResponse?.statusCode ?? 0)
                } catch {
                    completionHandler(nil, error, httpUrlsResponse?.statusCode ?? 0)
                }
            }
        }.resume()
    }
	
	func postCommentAPI(url: String, post params: [String : Any], completionHandler:@escaping (_ result: [String : Any]? , _ error: Error?, _ statusCode: Int?) -> Void) {
        print("API Url :\(url) - Params:\(params)")
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var accessToken = String()
        
        if (url.range(of: Constants.API.URL_USERS_LOGIN) != nil || url.range(of: Constants.API.URL_USERS_SIGNUP) != nil) {
            accessToken = ""
        } else {
            accessToken = dataValidation(data: Constants.userdefaults.value(forKey: Constants.Keys.Access_token) as AnyObject)
        }
        
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        //request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
    
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let httpUrlsResponse = response as? HTTPURLResponse
                print("StatusCode===>>", httpUrlsResponse?.statusCode ?? 0)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String]
					completionHandler( ["success": "1"] , nil, httpUrlsResponse?.statusCode ?? 0)
                } catch {
                    completionHandler(nil, error, httpUrlsResponse?.statusCode ?? 0)
                }
            }
        }.resume()
    }
	
    func postLikeAPI(url: String, post params: [String : Any], completionHandler:@escaping (_ result: [String : Any]?, _ error: Error?, _ statusCode: Int?) -> Void) {
        print("API Url :\(url) - Params:\(params)")
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var accessToken = String()
        
        if (url.range(of: Constants.API.URL_USERS_LOGIN) != nil || url.range(of: Constants.API.URL_USERS_SIGNUP) != nil) {
            accessToken = ""
        } else {
            accessToken = dataValidation(data: Constants.userdefaults.value(forKey: Constants.Keys.Access_token) as AnyObject)
        }
        
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        //request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
    
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let httpUrlsResponse = response as? HTTPURLResponse
                print("StatusCode===>>", httpUrlsResponse?.statusCode ?? 0)
                do {
                    //if let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:Any] {
                    //print(json)
                    //completionHandler( json , nil, httpUrlsResponse?.statusCode ?? 0)
                    //}
					
					// handle HTTP errors here
					if let httpResponse = response as? HTTPURLResponse {
						let statusCode = httpResponse.statusCode
						if statusCode == 200 {
							completionHandler( ["success" : "1"] , nil, httpUrlsResponse?.statusCode ?? 0)
                        } else {
                            completionHandler( ["success" : "0"] , nil, httpUrlsResponse?.statusCode ?? 0)
                        }
					}
                } catch {
                    completionHandler(nil, error, httpUrlsResponse?.statusCode ?? 0)
                }
            }
        }.resume()
    }
    
    func putAPI(url: String, accessToken: String, post params: [String : Any], completionHandler:@escaping (_ result: [String : Any]? , _ error: Error?, _ statusCode: Int?) -> Void) {
        print("API Url :\(url) - Params:\(params)")
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "PUT"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
        //request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed) else { return }
        let jsonString = String(data: httpBody, encoding: .utf8)
        request.httpBody = jsonString?.data(using: .utf8, allowLossyConversion: true)
        
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            let res = response as? HTTPURLResponse
            print(res?.statusCode ?? 0)
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                    print("response :\(json)")
                    completionHandler(json, nil, res?.statusCode ?? 0)
                } catch {
                    completionHandler(nil, error, res?.statusCode ?? 0)
                }
            }
        }.resume()
    }
	
	func deleteAPI(url1: String, accessToken: String, completionHandler: @escaping(_ result: [String : Any]?, _ error: Error?, _ statusCode: Int?) -> Void) {
        print("API Url :\(url1), Access token: \(accessToken)")
        guard let url = URL(string: url1) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
        print("url:->\(url)")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let httpUrlsResponse = response as? HTTPURLResponse
                print("StatusCode===>>", httpUrlsResponse?.statusCode ?? 0)
                do {
					
					if let httpResponse = response as? HTTPURLResponse {
						print("Status code: (\(httpResponse.statusCode))")

						// do stuff.
						if httpResponse.statusCode == 204 {
							completionHandler(["status": "success"], nil, httpUrlsResponse?.statusCode ?? 0)
						} else {
							completionHandler(nil, error, httpUrlsResponse?.statusCode ?? 0)
						}
					} else {
						completionHandler(nil, error, httpUrlsResponse?.statusCode ?? 0)
					}
                } catch {
                    completionHandler(nil, error, httpUrlsResponse?.statusCode ?? 0)
                }
            }
        }.resume()
    }
    
    
    func putUploadFilesAPI(url: String, accessToken: String, filesContentTypes: String, filesDatas:Data, post params: [String : Any], completionHandler:@escaping (_ result: [String : Any]?, _ error: Error?, _ statusCode: Int?) -> Void) {
        print("API Url :\(url) - Params:\(params)")
        guard let serviceUrl = URL(string: url) else { return }
        
        let semaphore = DispatchSemaphore (value: 0)
        let parameters = String(decoding: filesDatas, as: UTF8.self) //"<file contents here>"
        let postData = filesDatas//parameters.data(using: .utf8)
        
        var request = URLRequest(url: serviceUrl,timeoutInterval: Double.infinity)
        request.addValue(filesContentTypes, forHTTPHeaderField: "Content-Type")
        //Manually Added Here Start,,,,,
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        //request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
        //Manually Added Here End,,,,,
        
        request.httpMethod = "PUT"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let res = response as? HTTPURLResponse
            print("statusCode===>>", res?.statusCode ?? 0)
            //print("response===>>", response ?? "--")
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
    
    
    func patchAPI( url : String , post params : [String : Any] , completionHandler:@escaping (_ result : [String : Any]? , _ error : Error?, _ statusCode: Int?) -> Void) {
        print("API Url :\(url) - Params:\(params)")
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var accessToken = String()
        
        //if (url.range(of: "/auth/login") != nil || url.range(of: "/users/signup") != nil) {
        if (url.range(of: Constants.API.URL_USERS_LOGIN) != nil || url.range(of: Constants.API.URL_USERS_SIGNUP) != nil) { //"/auth/login" //"/users/signup"
            accessToken = ""
        } else {
            accessToken = dataValidation(data: Constants.userdefaults.value(forKey: Constants.Keys.Access_token) as AnyObject)
        }
        
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        //request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
    
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let httpUrlsResponse = response as? HTTPURLResponse
                print("StatusCode===>>", httpUrlsResponse?.statusCode ?? 0)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    print("response :\(json)")
                    completionHandler( json , nil, httpUrlsResponse?.statusCode ?? 0)
                } catch {
                    completionHandler(nil, error, httpUrlsResponse?.statusCode ?? 0)
                }
            }
        }.resume()
    }
    
    //MARK: UPLOAD IMAGES API"S WORK HERE START,,,,,
    //class func request(withImages path:APIMethods, method:URLMethod, token : String?, headers:[String:String]?, parameters: [String:Any]?,imageNames : [String], images:[Data], completion: @escaping(Any?, Error?, Bool)->Void) {
    func uploadMultipleImagesRequest_UsingPOST(url:String, params:[String:Any], urlType: String, imageNames:[String], images:[Data], completionHandler:@escaping (_ result : [String : Any]? , _ error : Error?, _ statusCode: Int?) -> Void) {
        print("API Url :\(url) - Params:\(params)")
        guard let serviceUrl = URL(string: url) else { return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if urlType == "CHAT_API" {
            let MyChatToken = dataValidation(data: Constants.userdefaults.value(forKey: Constants.Keys.ChatMyToken) as AnyObject)
            let MyChatId = dataValidation(data: Constants.userdefaults.value(forKey: Constants.Keys.ChatMyUserId) as AnyObject)
            request.addValue("\(MyChatToken)", forHTTPHeaderField: "X-Auth-Token")
            request.addValue("\(MyChatId)", forHTTPHeaderField: "X-User-Id")
        }
        var accessToken = String()
        
        //if (url.range(of: "/auth/login") != nil || url.range(of: "/users/signup") != nil) {
        if (url.range(of: Constants.API.URL_USERS_LOGIN) != nil || url.range(of: Constants.API.URL_USERS_SIGNUP) != nil) { //"/auth/login" //"/users/signup"
            accessToken = ""
        } else {
            accessToken = dataValidation(data: Constants.userdefaults.value(forKey: Constants.Keys.Access_token) as AnyObject)
        }
        
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        if params != nil{
            for(key, value) in params{
                // Add the reqtype field and its value to the raw http request data
                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                data.append("\(value)".data(using: .utf8)!)
            }
        }
        for (index,imageData) in images.enumerated() {
            // Add the image data to the raw http request data
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(imageNames[index])\"; filename=\"\(imageNames[index])\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(imageData)
        }
        
        //End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        //Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: request, from: data, completionHandler: { data, response, error in
            let httpUrlsResponse = response as? HTTPURLResponse
            print("StatusCode===>>", httpUrlsResponse?.statusCode ?? 0)
            if let checkResponse = response as? HTTPURLResponse{
                if checkResponse.statusCode == 200{
                    guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.allowFragments]) as? [String : Any] else {
                        completionHandler(nil, error, httpUrlsResponse?.statusCode ?? 0)
                        return
                    }
                    //let jsonString = String(data: data, encoding: .utf8)!
                    //print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                    print("response :\(json)")
                    completionHandler(json, nil, httpUrlsResponse?.statusCode ?? 0)
                } else {
                    guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                        completionHandler(nil, error, httpUrlsResponse?.statusCode ?? 0)
                        return
                    }
                    //let jsonString = String(data: data, encoding: .utf8)!
                    //print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                    print("response :\(json)")
                    completionHandler(json, nil, httpUrlsResponse?.statusCode ?? 0)
                }
            } else {
                guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                    completionHandler(nil, error, httpUrlsResponse?.statusCode ?? 0)
                    return
                }
                completionHandler(json, nil, httpUrlsResponse?.statusCode ?? 0)
            }

        }).resume()

    }
    
    func uploadMultipleImagesRequest_UsingPATCH(url:String, post params:[String:Any], imageNames:[String], images:[UIImage], completionHandler:@escaping (_ result : [String : Any]? , _ error : Error?, _ statusCode: Int?) -> Void) {
        
        print("API Url :\(url) - Params:\(params)")
        guard let serviceUrl = URL(string: url) else { return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var accessToken = String()
        
        //if (url.range(of: "/auth/login") != nil || url.range(of: "/users/signup") != nil) {
        if (url.range(of: Constants.API.URL_USERS_LOGIN) != nil || url.range(of: Constants.API.URL_USERS_SIGNUP) != nil) { //"/auth/login" //"/users/signup"
            accessToken = ""
        } else {
            accessToken = dataValidation(data: Constants.userdefaults.value(forKey: Constants.Keys.Access_token) as AnyObject)
        }
        
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        if params != nil{
            for(key, value) in params{
                // Add the reqtype field and its value to the raw http request data
                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                data.append("\(value)".data(using: .utf8)!)
            }
        }
        for (index,image) in images.enumerated() {
            let imageData = image.jpegData(compressionQuality: 1.0)
            
            // Add the image data to the raw http request data
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(imageNames[index])\"; filename=\"\(imageNames[index])\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(imageData!)
        }
        
        //End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        //Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: request, from: data, completionHandler: { data, response, error in
            let httpUrlsResponse = response as? HTTPURLResponse
            print("StatusCode===>>", httpUrlsResponse?.statusCode ?? 0)
            if let checkResponse = response as? HTTPURLResponse{
                if checkResponse.statusCode == 200{
                    guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.allowFragments]) as? [String : Any] else {
                        completionHandler(nil, error, checkResponse.statusCode )
                        return
                    }
                    //let jsonString = String(data: data, encoding: .utf8)!
                    //print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                    print("response :\(json)")
                    completionHandler(json, nil, checkResponse.statusCode )
                } else {
                    guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                        completionHandler(nil, error, checkResponse.statusCode )
                        return
                    }
                    //let jsonString = String(data: data, encoding: .utf8)!
                    //print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                    print("response :\(json)")
                    completionHandler(json, nil, checkResponse.statusCode )
                }
            } else {
                guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                    completionHandler(nil, error, httpUrlsResponse?.statusCode ?? 0)
                    return
                }
                completionHandler(json, nil, httpUrlsResponse?.statusCode ?? 0)
            }

        }).resume()

    }
    
    func uploadImage(url:String, paramName:String, fileName:String, image:UIImage, completionHandler:@escaping (_ result : [String : Any]? , _ error : Error?) -> Void) {
        //print("API Url :\(url) - Params:\(params)")
        guard let serviceUrl = URL(string: url) else { return }

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        let session = URLSession.shared

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: serviceUrl)
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print(json)
                }
            }
        }).resume()
    }
    //MARK: UPLOAD IMAGES API"S WORK HERE END,,,,,
    
}

extension Data {

    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.

    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}





//=======================================***********************************=======================================
//=======================================***********************************=======================================
//=======================================***********************************=======================================
//MARK: CHAT KIND OF API'S END POIND PASSING FUNCTIONALITIES START,,,,,
extension ConnectionHandler {
    
    func getAPI_CHAT(url1: String, accessToken: String, completionHandler: @escaping(_ result: [String : Any]?, _ error: Error?, _ statusCode: Int?) -> Void) {
        //print("API Url :\(url1), Access token: \(accessToken)")
        
        let MyChatToken = dataValidation(data: Constants.userdefaults.value(forKey: Constants.Keys.ChatMyToken) as AnyObject)
        let MyChatId = dataValidation(data: Constants.userdefaults.value(forKey: Constants.Keys.ChatMyUserId) as AnyObject)
        
        guard let url = URL(string: url1) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
        request.addValue("\(MyChatToken)", forHTTPHeaderField: "X-Auth-Token")
        request.addValue("\(MyChatId)", forHTTPHeaderField: "X-User-Id")
        //print("url:->\(url)")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let httpUrlsResponse = response as? HTTPURLResponse
                print("StatusCode===>>", httpUrlsResponse?.statusCode ?? 0)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String : Any]
                    print("URL :\(url), Access token: \(accessToken) -- Response:\(json)")
                    
                    completionHandler(json, nil, httpUrlsResponse?.statusCode ?? 0)
                } catch {
                    //print("Error111===>>", error)
                    completionHandler(nil, error, httpUrlsResponse?.statusCode ?? 0)
                }
            }
        }.resume()
    }
    
    func postAPI_CHAT(url: String, post params: [String : Any], completionHandler:@escaping (_ result: [String : Any]?, _ error: Error?, _ statusCode: Int?) -> Void) {
        print("API Url :\(url) - Params:\(params)")
        
        let MyChatToken = dataValidation(data: Constants.userdefaults.value(forKey: Constants.Keys.ChatMyToken) as AnyObject)
        let MyChatId = dataValidation(data: Constants.userdefaults.value(forKey: Constants.Keys.ChatMyUserId) as AnyObject)
        
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(MyChatToken)", forHTTPHeaderField: "X-Auth-Token")
        request.addValue("\(MyChatId)", forHTTPHeaderField: "X-User-Id")
        var accessToken = String()
        if (url.range(of: Constants.API.URL_USERS_LOGIN) != nil || url.range(of: Constants.API.URL_USERS_SIGNUP) != nil) {
            accessToken = ""
        } else {
            accessToken = dataValidation(data: Constants.userdefaults.value(forKey: Constants.Keys.Access_token) as AnyObject)
        }
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        //request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let httpUrlsResponse = response as? HTTPURLResponse
                print("StatusCode===>>", httpUrlsResponse?.statusCode ?? 0)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    print("URL :\(url) -- Params:\(params) -- Response :\(json)")
                    completionHandler(json, nil, httpUrlsResponse?.statusCode ?? 0)
                } catch {
                    completionHandler(nil, error, httpUrlsResponse?.statusCode ?? 0)
                }
            }
        }.resume()
    }
    
    
}
//MARK: CHAT KIND OF API'S END POIND PASSING FUNCTIONALITIES END,,,,,
//=======================================***********************************=======================================
//=======================================***********************************=======================================
//=======================================***********************************=======================================








//MARK: ViewController
/*
 self.jobView.setController(controller: self)
 self.jobVM.setController(controller: self)
 self.jobVM.getJobProcess()
 */


//MARK: Model
/*
 
 import Foundation

 class JobModel {
     
     var jobPostings: [JobData]?
     var jobPostingCount: Int?
     
     init(response: [String: Any]?) {
         
         self.jobPostings = [JobData]()
         if let jobPostings = response?["jobPostings"] as? [[String: Any]] {
             for job in jobPostings {
                 let jobData = JobData(response: job)
                 self.jobPostings?.append(jobData)
             }
         }
         jobPostingCount = response?["jobPostingCount"] as? Int
     }
     
 }

 class JobData {
     
     var _id: String?
     var title: String?
     var startDate: String?
     var endDate: String?
     var locationName: String?
     var address: String?
     var city: String?
     var state: String?
     var email: String?
     var zip: String?
     var _department: String?
     var departmentName: String?
 //    var zip: Sting?
 //    var _department
     
     
    /* {
     "_id": "5fd23557db528d000408bb72",
     "title": "Test Job",
     "startDate": "2020-12-12T03:30:00.000Z",
     "endDate": "2020-12-12T05:01:00.000Z",
     "email": "test@mailinator.com",
     "locationName": "Test City, Test State.",
     "address": "123, test ",
     "city": "City 1",
     "state": "State 1",
     "zip": "123456",
     "_department": "59a5b1be88075b0004301e14"
     } */
     
     init(response: [String: Any]) {
         
         self._id = response["_id"] as? String
         self.title = response["title"] as? String
         self.startDate = response["startDate"] as? String
         self.endDate = response["endDate"] as? String
         self.locationName = response["locationName"] as? String
         self.address = response["address"] as? String
         self.city = response["city"] as? String
         self.state = response["state"] as? String
         self.email = response["email"] as? String
         self.zip = response["zip"] as? String
         if let department = response["_department"] as? [String : Any] {
             self._department = department["_id"] as? String
             self.departmentName = department["displayName"] as? String
         }
         
     }
     
 }

 */



//MARK: ViewModel
/*
 import UIKit

 class JobVM: NSObject {
     
     var controller: JobVC!
     var skipCount = 0
     var jobListModel: JobModel?
     
     func setController(controller: JobVC) {
         self.controller = controller
     }
     
     // Get Event process
     func getJobProcess() {
         if checkNetwork() {
             showProgress(currentView: controller.view)
             self.jobApi_Process { (isSuccess, message) in
                 if isSuccess {
                     DispatchQueue.main.async {
                         hideProgress(currentView: self.controller.view)
                         self.controller.jobView.labelNoresult.isHidden = true
                         if self.skipCount <= Constants.API.LIMIT {
                             if self.jobListModel?.jobPostingCount == 0 {
                                 self.controller.jobView.labelNoresult.isHidden = false
                             }
                         }
                         self.controller.jobView.refreshControl.endRefreshing()
                         self.controller.jobView.eventTableView.reloadData()
                     }
                 } else {
                     DispatchQueue.main.async {
                         hideProgress(currentView: self.controller.view)
                         self.controller.showAlert(title: "", message: message)
                     }
                 }
             }
         } else {
             controller.showAlert(title: "", message: Constants.GeneralConstants.NetworkStatus)
         }
     }
     
     // Get event Details
     func jobApi_Process(completionHandler : @escaping(_ success : Bool,_ message: String) ->Void) {
         
         if let accessToken = Constants.userdefaults.value(forKey: Constants.Keys.Access_token) {
             
             let eventsURL = Constants.API.job_URL + "&limit=\(Constants.API.LIMIT)&skip=\(skipCount)"
             
             //                let eventsURL = Constants.API.events_URL + "&limit=3&skip=\(skipCount)"
             
             ConnectionHandler.shared.getAPI(url1: eventsURL, accessToken: accessToken as! String) { (response, error, statusCode) in
                 guard let response = response else {
                     print("event response : \(String(describing: error?.localizedDescription)) ---- Error:\(String(describing: error))")
                     return
                 }
 
                if statusCode==403 {
                    SceneDelegate.originalSceneDelegate.loginPageVc_Fns()
                    return
                }
 
                 if response.count > 0 {
                     print("Response \(String(describing: response))")
                     if let error = response["error"] as? String {
                         completionHandler(false, error)
                     } else if let item =  response["jobPostings"] as? [[String : Any]]{
                         
                         if self.skipCount == 0 {
                             self.jobListModel = nil
                         }
                         if let previousListModel = self.jobListModel {
                             let currentListModel = JobModel(response: response)
                             self.jobListModel?.jobPostings = previousListModel.jobPostings! + currentListModel.jobPostings!
                             self.jobListModel?.jobPostingCount = currentListModel.jobPostingCount
                         } else {
                             self.jobListModel = JobModel(response: response)
                         }
                         //                            let featureModel = CalendarModel(response: response)
                         //                            print("Feature Response \(String(describing: featureModel.events?[0].title))")
                         //                            print(getDatefromString(string: featureModel.events?[0].startTime ?? ""))
                         //                            print(dateToString(dateValue: getDatefromString(string: featureModel.events?[0].startTime ?? ""), withDateFormat: Constants.DateFormatterConstants.AMPM))
                         //                            self.skipCount = self.skipCount + Constants.API.LIMIT
                         if item.count != 0 {
                             let remaining = item.count % Constants.API.LIMIT
                             self.skipCount = self.skipCount + (remaining == 0 ? Constants.API.LIMIT : remaining)
                         }
                         completionHandler(true, "Success")
                     }
                 }
                 
             }
         }
         
     }
 }

 */
