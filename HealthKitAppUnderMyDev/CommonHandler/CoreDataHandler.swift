//
//  CoreDataHandler.swift
//  Piechips
//
//  Created by VC on 24/07/23.
//

import Foundation
import UIKit
import CoreData


/*
//===========================//MARK: CoreData data context Start,,,,,===========================//
//===========================//MARK: CoreData data context Start,,,,,===========================//
//MARK: Add Logged-In profile details Start,,,,,
func core_DataContext_AddLogedInUserDetails(userId: String, name: String, dateOfBirth:String, email: String, mobileCode: String, mobile: String, password: String, emailVerification: String, mobileVerification: String, isAdmin: String) -> Bool {
    let newUser = UserDetailsEntity(context: Constants.coreDataContext)
    newUser.userId = userId
    newUser.name = name
    newUser.dob = dateOfBirth
    newUser.email = email
    newUser.mobile = mobile
    newUser.mobileCode = mobileCode
    newUser.password = password
    newUser.emailVerification = emailVerification
    newUser.mobileVerification = mobileVerification
    newUser.isAdmin = isAdmin
    newUser.uuid = NSUUID().uuidString
    do {
        try Constants.coreDataContext.save()
        //self.goBackActionAfterDataUpdate(title: "Success!", message: "Your data has been added.")
        return true
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return false
    }
}

func core_DataContext_CheckIfEmailAndPasswordItemsExists(email: String, password:String) -> Bool {
    //let managedContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserDetailsEntity")
    fetchRequest.fetchLimit =  1
    fetchRequest.predicate = NSPredicate(format: "email == %@" ,email)
    fetchRequest.predicate = NSPredicate(format: "password == %@" ,password)
    
    do {
        let count = try Constants.coreDataContext.count(for: fetchRequest)
        if count > 0 {
            return true
        }else {
            return false
        }
    }catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
        return false
    }
}

func core_DataContext_CheckIfEmailItemExists(email: String) -> Bool {
    //let managedContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserDetailsEntity")
    fetchRequest.fetchLimit =  1
    fetchRequest.predicate = NSPredicate(format: "email == %@" ,email)
    //fetchRequest.predicate = NSPredicate(format: "password == %@" ,password)
    
    do {
        let count = try Constants.coreDataContext.count(for: fetchRequest)
        if count > 0 {
            return true
        }else {
            return false
        }
    }catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
        return false
    }
}


//MARK: Add Home - Posts-ALL details Start,,,,,
func core_DataContext_AddPosts_HomeAllDetails(post_id: String?, post_hashtags:String?, post_description: String?, circle_id: String?, circle_name: String?, circle_main_image_data: String?, topic_id: String?, topic_name: String?, topic_sub_id: String?, topic_sub_name: String?) -> Bool {
    let newUser = PostsHomeAllEntity(context: Constants.coreDataContext)
    //print("post_id==>>", post_id)
    newUser.post_id = post_id
    newUser.post_hashtags = post_hashtags
    newUser.post_description = post_description
    newUser.circle_id = circle_id
    newUser.circle_name = circle_name
    newUser.circle_main_image_data = circle_main_image_data
    newUser.topic_id = topic_id
    newUser.topic_name = topic_name
    newUser.topic_sub_id = topic_sub_id
    newUser.topic_sub_name = topic_sub_name
    do {
        try Constants.coreDataContext.save()
        //self.goBackActionAfterDataUpdate(title: "Success!", message: "Your data has been added.")
        return true
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        return false
    }
}
//MARK: Add Home - Posts-ALL details End,,,,,

//MARK: Core - Fetch All kind of datas functionalities Start,,,,,
func core_DataContext_fetch_PostsHomeAllDatas() -> [PostsHomeAllEntity]? {
    //MARK: - Core Data Initialise
    var items:[PostsHomeAllEntity]?
    do {
        items = try Constants.coreDataContext.fetch(PostsHomeAllEntity.fetchRequest())
        return items
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
        return items
    }
    //print(self.items!)
}

func core_DataContext_fetch_ChatRoomsAllDatas(entityName: String) -> [ChatRoomsEntity]? {
    //MARK: - Core Data Initialise
    var items:[ChatRoomsEntity]?
    do {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        items = try Constants.coreDataContext.fetch(request) as? [ChatRoomsEntity] //Constants.coreDataContext.fetch(ChatRoomsEntity.fetchRequest())
        return items
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
        return items
    }
    //print(self.items!)
}

func core_DataContext_fetch_ChattingHistoryAllDatas(entityName: String) -> [ChatChattingEntity]? {
    //MARK: - Core Data Initialise
    var items:[ChatChattingEntity]?
    do {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        items = try Constants.coreDataContext.fetch(request) as? [ChatChattingEntity] //Constants.coreDataContext.fetch(ChatChattingEntity.fetchRequest())
        return items
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
        return items
    }
    //print(self.items!)
}

func core_DataContext_fetch_ChatStatusAllDatas(entityName: String) -> [ChatOnlineTypingStatusEntity]? {
    //MARK: - Core Data Initialise
    var items:[ChatOnlineTypingStatusEntity]?
    do {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        items = try Constants.coreDataContext.fetch(request) as? [ChatOnlineTypingStatusEntity]
        return items
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
        return items
    }
    //print(self.items!)
}

func core_DataContext_fetch_ZzzSamplesAllDatas(entityName: String) -> [Zzz_SampleEntity]? {
    //MARK: - Core Data Initialise
    var items:[Zzz_SampleEntity]?
    do {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        items = try Constants.coreDataContext.fetch(request) as? [Zzz_SampleEntity] //Constants.coreDataContext.fetch(ChatRoomsEntity.fetchRequest())
        return items
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
        return items
    }
    //print(self.items!)
}
//MARK: Core - Fetch All kind of datas functionalities End,,,,,

//MARK: CORE - Delete All Datas From Given Particular Entity Start,,,,,
func core_DataContext_delete_AllDatasFromGivenParticularEntity(entityName: String) {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    do {
        try Constants.coreDataContext.execute(deleteRequest)
    } catch let error as NSError {
        // TODO: handle the error
        print("Could not delete All===>> \(error), \(error.userInfo)")
    }
}
/*
 // delete code
 let entityRemove = self.items![sender.tag]
 Constants.coreDataContext.delete(entityRemove)
 do {
     try Constants.coreDataContext.save()
 } catch let error as NSError {
    // TODO: handle the error
    print("Could not delete All===>> \(error), \(error.userInfo)")
 }
 */
//MARK: CORE - Delete All Datas From Given Particular Entity End,,,,,

//===========================//MARK: CoreData data context End,,,,,===========================//
//===========================//MARK: CoreData data context End,,,,,===========================//






func getDataFromChatUsingStringReceived_Fns(strMessage: String?) {
    updateSyncMainQueue {
        //let strMsg = "{\"msg\":\"changed\",\"collection\":\"stream-notify-logged\",\"id\":\"id\",\"fields\":{\"eventName\":\"user-status\",\"args\":[[\"DRHELAQ7XhnvMitNy\",\"Thiyagaraj_R8N1\",1,\"\"]]}}"
        //let strMsg = "{\"msg\":\"changed\",\"collection\":\"stream-notify-logged\",\"id\":\"id\",\"fields\":{\"eventName\":\"user-status\",\"args\":[[\"DRHELAQ7XhnvMitNy\",\"Thiyagaraj_R8N1\",0,\"\"]]}}"
        
        //let strMsg = "{\"msg\":\"changed\",\"collection\":\"stream-notify-room\",\"id\":\"id\",\"fields\":{\"eventName\":\"DRHELAQ7XhnvMitNybxH5TKDpX4SDcBPoF/user-activity\",\"args\":[\"Thiyagaraj_R8N1\",[\"user-typing\"],{}]}}"
        //let strMsg = "{\"msg\":\"changed\",\"collection\":\"stream-notify-room\",\"id\":\"id\",\"fields\":{\"eventName\":\"DRHELAQ7XhnvMitNybxH5TKDpX4SDcBPoF/user-activity\",\"args\":[\"Thiyagaraj_R8N1\",[],{}]}}"
        
        //let strMsg = "{\"msg\":\"changed\",\"collection\":\"stream-notify-user\",\"id\":\"id\",\"fields\":{\"eventName\":\"wE8BbcqCEWhHH9RGt/rooms-changed\",\"args\":[\"updated\",{\"_id\":\"f5m8WgHXMmHpmcCpuwE8BbcqCEWhHH9RGt\",\"t\":\"d\",\"usernames\":[\"Hari_E6Y0\",\"Kupendiran_O6N3\"],\"usersCount\":2,\"ts\":{\"$date\":1688985645101},\"uids\":[\"f5m8WgHXMmHpmcCpu\",\"wE8BbcqCEWhHH9RGt\"],\"default\":false,\"ro\":false,\"sysMes\":true,\"_updatedAt\":{\"$date\":1689065335378},\"lastMessage\":{\"rid\":\"f5m8WgHXMmHpmcCpuwE8BbcqCEWhHH9RGt\",\"msg\":\"Ahh has\",\"ts\":{\"$date\":1689065335320},\"u\":{\"_id\":\"wE8BbcqCEWhHH9RGt\",\"username\":\"Kupendiran_O6N3\",\"name\":\"Kupendiran Alagarsamy\"},\"unread\":true,\"_id\":\"a5tm7HHZtpxMGDk4o\",\"_updatedAt\":{\"$date\":1689065335365},\"urls\":[],\"mentions\":[],\"channels\":[],\"md\":[{\"type\":\"PARAGRAPH\",\"value\":[{\"type\":\"PLAIN_TEXT\",\"value\":\"Ahh has\"}]}]},\"lm\":{\"$date\":1689065335320}}]}}"
        
        //let strMsg = "{\"msg\":\"changed\",\"collection\":\"stream-notify-user\",\"id\":\"id\",\"fields\":{\"eventName\":\"vFxGNtz2m8wrCmsio/notification\",\"args\":[{\"title\":\"Thiyagaraj_S8K3\",\"text\":\"Hi\",\"payload\":{\"_id\":\"uh7zTEnCFw6Yt5w9g\",\"rid\":\"ck86jiDFHwzf8cbP5vFxGNtz2m8wrCmsio\",\"sender\":{\"_id\":\"ck86jiDFHwzf8cbP5\",\"username\":\"Thiyagaraj_S8K3\",\"name\":\"Thiyagaraj A\"},\"type\":\"d\",\"message\":{\"msg\":\"Hi\"}}}]}}"
        
        //let strMsg = "{\"msg\":\"changed\",\"collection\":\"stream-notify-user\",\"id\":\"id\",\"fields\":{\"eventName\":\"C95puW7x2KpXd2PBT/subscriptions-changed\",\"args\":[\"updated\",{\"_id\":\"t3gGSCoszfY2AQeZp\",\"rid\":\"C95puW7x2KpXd2PBTpFgoXTrJ7D59utnkz\",\"u\":{\"_id\":\"C95puW7x2KpXd2PBT\",\"username\":\"Mohan_B6C8\"},\"_updatedAt\":{\"$date\":1693643163212},\"alert\":false,\"fname\":\"Kupendiran Alagarsamy\",\"groupMentions\":0,\"name\":\"Kupendiran_M7N8\",\"open\":true,\"t\":\"d\",\"unread\":0,\"userMentions\":0,\"ls\":{\"$date\":1693643163212}}]}}"
        
        if let strMessage = strMessage {
            let data = strMessage.data(using: .utf8)!
            //let data = strMsg.data(using: .utf8)!
            do {
                if let jsonChatDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
                    if let s_collection = jsonChatDict["collection"] as? String {
                        print("NEED_1_Response===>> \(jsonChatDict)")
                        
                        if s_collection == "stream-notify-user" { //New Msg & room changed & User Subscription changed
                            if let DictFields = jsonChatDict["fields"] as? [String: Any] {
                                let AryEventsName = dataValidation(data: DictFields["eventName"] as AnyObject).components(separatedBy: "/")
                                if AryEventsName.count != 0 {
                                    if AryEventsName[1] == "rooms-changed" {
                                        
                                        if let DictArgs = DictFields["args"] as? [Any] {
                                            DictArgs.enumerated().forEach {(index, element) in
                                                if let DictLastMsg = element as? [String: Any] { //"lastMessage"
                                                    //print("DictLastMsg===>>\(DictLastMsg)")
                                                    if let lastMsg = DictLastMsg["lastMessage"] as? [String: Any] {//As of now DUMMY, Reason to filter while msg emit both via 'notification' and 'rooms_changed'. Start,,,,,
                                                        Constants.AppDatas.ChatsLastMsgId = dataValidation(data: lastMsg["_id"] as AnyObject)
                                                    }//As of now DUMMY, Reason to filter while msg emit both via 'notification' and 'rooms_changed'. End,,,,,
                                                    SetLastMessagesDataToViewModelClasses_Fns(DictLastMsg: DictLastMsg)
                                                }
                                            }//Main for_each End,,,,,
                                        }//a_r_g_s changed if End,,,,,
                                        
                                    }//r_o_o_m changed if End,,,,,
                                    else if AryEventsName[1] == "notification" {
                                        
                                        if let DictArgs = DictFields["args"] as? [Any] {//payload
                                            DictArgs.enumerated().forEach {(index, element) in
                                                if let DictLastMsg = element as? [String: Any] { //"lastMessage"
                                                    //print("DictLastMsg===>>\(DictLastMsg)")
                                                    //SetLastMessagesDataToViewModelClasses_Fns(DictLastMsg: DictLastMsg)
                                                    if let lastMsg = DictLastMsg["payload"] as? [String: Any] {//As of now DUMMY, Reason to filter while msg emit both via 'notification' and 'rooms_changed'. Start,,,,,
                                                        if Constants.AppDatas.ChatsLastMsgId != dataValidation(data: lastMsg["_id"] as AnyObject) {
                                                            SetLastMessagesDataToViewModelClasses_Fns(DictLastMsg: DictLastMsg)
                                                        }
                                                    }//As of now DUMMY, Reason to filter while msg emit both via 'notification' and 'rooms_changed'. End,,,,,
                                                }
                                            }//Main for_each End,,,,,
                                        }//a_r_g_s changed if End,,,,,
                                        
                                    }//n_o_t_i_f_i_c_a_t_i_o_n changed if End,,,,,
                                    /*else if AryEventsName[1] == "subscriptions-changed" {
                                        
                                        if let DictArgs = DictFields["args"] as? [Any] {//payload
                                            DictArgs.enumerated().forEach {(index, element) in
                                                if let DictLastMsg = element as? [String: Any] { //"lastMessage"
                                                    //print("DictLastMsg===>>\(DictLastMsg)")
                                                    
                                                }
                                            }//Main for_each End,,,,,
                                        }//a_r_g_s changed if End,,,,,
                                        
                                    }//s_u_b_s_c_r_i_p_t_i_o_n_s changed if End,,,,,*/
                                    
                                }//Events count != Value if End,,,,,
                            }//f_i_e_l_d_s if End,,,,,
                        }
                        else if s_collection == "stream-notify-logged" { //User ONLINE Status
                            if let DictFields = jsonChatDict["fields"] as? [String: Any] {
                                if let AryArgs = DictFields["args"] as? [[Any]] {
                                    //print("AryArgs===>>\(AryArgs)")
                                    AryArgs.enumerated().forEach {(index, element) in
                                        //print("index===>>\(index) && element===>>\(element)")
                                        if element.count >= 2 {
                                            let isUserName = dataValidation(data: element[1] as AnyObject)
                                            let isUserOnlineStatus = dataValidation(data: element[2] as AnyObject)
                                            //print("isUserName===>>\(isUserName) && isUserOnlineStatus===>>\(isUserOnlineStatus)")
                                            SetOnlineStatusToViewModelClasses_Fns(GivenUserName: isUserName, OnlineStatus: isUserOnlineStatus)
                                        }
                                    }//Main for_each End,,,,,
                                }//a_r_g_s Ary End,,,,,
                            }//f_i_e_l_d_s if End,,,,,
                        }
                        else if s_collection == "stream-notify-room" { //Typing status
                            if let DictFields = jsonChatDict["fields"] as? [String: Any] {
                                let AryEventsName = dataValidation(data: DictFields["eventName"] as AnyObject).components(separatedBy: "/")
                                if AryEventsName.count != 0 {
                                    if AryEventsName[1] == "user-activity" {
                                        
                                        if let AryArgs = DictFields["args"] as? [Any] {
                                            //print("AryArgs===>>\(AryArgs)")
                                            var isUserName = ""
                                            var isTypingStatus = ""
                                            AryArgs.enumerated().forEach {(index, element) in
                                                //print("element===>>\(element)")
                                                if index == 0 {
                                                    isUserName = dataValidation(data: element as AnyObject)
                                                } else if index == 1 {
                                                    if let AryTypingValues = element as? [String] {
                                                        AryTypingValues.enumerated().forEach {(index2, element2) in
                                                            isTypingStatus = dataValidation(data: element2 as AnyObject)
                                                        }//Small for_each End,,,,,
                                                    }
                                                }
                                            }//Main for_each End,,,,,
                                            //print("isUserName===>>\(isUserName) && isTypingStatus===>>\(isTypingStatus)")
                                            SetTypingStatusToViewModelClasses_Fns(GivenUserName: isUserName, TypingStatus: isTypingStatus)
                                        }//a_r_g_s Ary End,,,,,
                                        
                                    }//user_activity if End,,,,,
                                }//Events count != Value if End,,,,,
                            }//f_i_e_l_d_s if End,,,,,
                        }
                        
                    } else if let s_message = jsonChatDict["msg"] as? String {
                        if s_message != "pong" && s_message != "ping" && s_message != "nosub" && s_message != "added" && s_message != "ready" && s_message != "updated" && s_message != "result" && s_message != "connected" {
                            print("NEED_2_Response===>> \(jsonChatDict)")
                            
                        }
                    } else {
                        print("Response===>> \(jsonChatDict)")
                    }
                    //completionHandler(json, nil, httpUrlsResponse?.statusCode ?? 0)
                } else {
                    print("=====>>bad json")
                }
            } catch let error as NSError {
                print("error===>>", error)
                //completionHandler(nil, error, httpUrlsResponse?.statusCode ?? 0)
            }
        }
    }//update_Sync_Main_Queue End,,,,,
}


func SetLastMessagesDataToViewModelClasses_Fns(DictLastMsg: [String: Any]?) {
    
    //MARK: THIS is UPDATTING ROOM MSG PURPOSE, So no need to store LastMsg Data to Local db Start,,,,,
    Constants.GlobalValues.isChatRoomsWantToRefresh = true
    
    let currentRoomModel = ChatMainModel(response_UpdateNewMsg_usingChatLastMsgData: DictLastMsg, isWantToStore_CData: false)
    let GivenRooms_RoomId = dataValidation(data: currentRoomModel.mainData_Individual?.msg_room_id as AnyObject)
    let GivenLastMsg_UserName = dataValidation(data: currentRoomModel.mainData_Individual?.chat_user_name as AnyObject)
    
    var isMentionedChatRoomAlreadyPresent = false
    
    //MARK: - Core Data Initialise
    let items_RoomsData = core_DataContext_fetch_ChatRoomsAllDatas(entityName: Constants.EntityNames.ENTITY_CHAT_ROOMS)
    //print("items_RoomsData===>>\(items_RoomsData?.count ?? 0) && items_room_id===>>\(items?[0].chat_room_id ?? "--")")
    items_RoomsData?.enumerated().forEach { (index, element) in
        guard let room_id = element.chat_room_id else { return }
        //print("GivenRooms_RoomId===>>\(GivenRooms_RoomId) && room_id===>>\(room_id)")
        if room_id == GivenRooms_RoomId {
            
            isMentionedChatRoomAlreadyPresent = true
            
            //MARK: Update data to local DB - Update Already having Room
            let entityUpdate = items_RoomsData?[index]
            entityUpdate?.msg_id = dataValidation(data: currentRoomModel.mainData_Individual?.msg_id as AnyObject)
            entityUpdate?.msg_UpdatedAt = dataValidation(data: currentRoomModel.mainData_Individual?.msg_UpdatedAt as AnyObject)
            entityUpdate?.msg_Message = dataValidation(data: currentRoomModel.mainData_Individual?.msg_Message as AnyObject)
            entityUpdate?.msg_ts = dataValidation(data: currentRoomModel.mainData_Individual?.msg_ts as AnyObject)
            entityUpdate?.msg_unread = dataValidation(data: currentRoomModel.mainData_Individual?.msg_unread as AnyObject)
            entityUpdate?.msg_unReadCount = dataValidation(data: currentRoomModel.mainData_Individual?.msg_unReadCount as AnyObject)
            entityUpdate?.msg_urls = currentRoomModel.mainData_Individual?.msg_urls
            
            entityUpdate?.chat_user_online = dataValidation(data: currentRoomModel.mainData_Individual?.chat_user_online as AnyObject)
            entityUpdate?.isMuteChatNotifications = dataValidation(data: currentRoomModel.mainData_Individual?.isMuteChatNotifications as AnyObject)
            do {
                try Constants.coreDataContext.save()
            } catch let error as NSError {
                print("Could not update. \(error), \(error.userInfo)")
            }
            
        }//Both Last_Msg Room_Id & LocalDB Room_Id EQUAl if End,,,,,
    }//for_each End,,,,,
    
    if isMentionedChatRoomAlreadyPresent == false {
        //MARK: Add data to local DB - Add New Room
        let saveRoomModel = ChatMainModel(response_UpdateNewMsg_usingChatLastMsgData: DictLastMsg, isWantToStore_CData: true)
        let saveRoom_RoomId = dataValidation(data: saveRoomModel.mainData_Individual?.msg_room_id as AnyObject)
        if saveRoom_RoomId != "" {
            print("New Room Saved!===>>\(saveRoom_RoomId)")
        }
    }
    
    //MARK: THIS is UPDATTING ROOM MSG PURPOSE, So no need to store LastMsg Data to Local db End,,,,,
    
    
    
    //important
    if let topVC = UIApplication.getTopViewController() {
        let getCurrentVcName = topVC.debugDescription.slice(from: ".", to: ":")
        print("getCurrentVcName==>>", getCurrentVcName ?? "")
        if getCurrentVcName == "ChatMainVc" {
            
        } else if getCurrentVcName == "ChattingVc" {
            let MyChatUserName = dataValidation(data: Constants.userdefaults.value(forKey: Constants.Keys.ChatMyUserName) as AnyObject)
            if MyChatUserName != GivenLastMsg_UserName {
                ChattingVc().viewModel.Set_NewMessages_toCData_Fns(DictLastMsg: DictLastMsg)
                //ChattingVc().viewModel.Add_ResponceToAlreadyHavingDatas_FromSentNewChat_Fns(response: ["data": DictLastMsg])
            }
        }
    }
    //important
    
}


func SetTypingStatusToViewModelClasses_Fns(GivenUserName: String, TypingStatus: String) {
    
    //MARK: - Core Data Initialise
    let items_ChatStatusData = core_DataContext_fetch_ChatStatusAllDatas(entityName: Constants.EntityNames.ENTITY_CHAT_ONLINE_TYPING_STATUS)
    //print("items_RoomsData===>>\(items_RoomsData?.count ?? 0) && items_room_id===>>\(items?[0].chat_room_id ?? "--")")
    if items_ChatStatusData?.count == 0 {
        Save_UserTypingStatus_Data_Fns()
    } else {
        items_ChatStatusData?.enumerated().forEach { (index, element) in
            guard let userName_viaCData = element.chat_user_name else { return }
            //print("GivenUserName===>>\(GivenUserName) && user_name===>>\(user_name)")
            if userName_viaCData == GivenUserName {
                
                //MARK: Update data to local DB
                let entityUpdate = items_ChatStatusData?[index]
                //entityUpdate?.chat_user_online = OnlineStatus
                entityUpdate?.chat_user_typingStatus = TypingStatus
                
                do {
                    try Constants.coreDataContext.save()
                } catch let error as NSError {
                    print("Could not update. \(error), \(error.userInfo)")
                }
                
            } else {
                Save_UserTypingStatus_Data_Fns()
            }
        }//for_each End,,,,,
    }
    
    func Save_UserTypingStatus_Data_Fns() {
        //MARK: Add data to local DB
        let chatStatus = ChatOnlineTypingStatusEntity(context: Constants.coreDataContext)
        chatStatus.chat_user_name = GivenUserName
        //chatStatus.chat_user_online = OnlineStatus
        chatStatus.chat_user_typingStatus = TypingStatus
        
        do {
            try Constants.coreDataContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    //important
    /*if let topVC = UIApplication.getTopViewController() {
        let getCurrentVcName = topVC.debugDescription.slice(from: ".", to: ":")
        //print("getCurrentVcName==>>", getCurrentVcName ?? "")
        if getCurrentVcName == "ChatMainVc" {
            
        } else if getCurrentVcName == "ChattingVc" {
            //ChattingVc().viewModel.Set_TypingStatus_toThisPageVariable_Fns(GivenUserName: GivenUserName, TypingStatus: TypingStatus)
        }
    }*/
    //important
    
}

func SetOnlineStatusToViewModelClasses_Fns(GivenUserName: String, OnlineStatus: String) {
    
    //MARK: - Core Data Initialise
    let items_ChatStatusData = core_DataContext_fetch_ChatStatusAllDatas(entityName: Constants.EntityNames.ENTITY_CHAT_ONLINE_TYPING_STATUS)
    //print("items_RoomsData===>>\(items_RoomsData?.count ?? 0) && items_room_id===>>\(items?[0].chat_room_id ?? "--")")
    if items_ChatStatusData?.count == 0 {
        Save_UserOnlineStatus_Data_Fns()
    } else {
        items_ChatStatusData?.enumerated().forEach { (index, element) in
            guard let userName_viaCData = element.chat_user_name else { return }
            //print("GivenUserName===>>\(GivenUserName) && user_name===>>\(user_name)")
            if userName_viaCData == GivenUserName {
                
                //MARK: Update data to local DB
                let entityUpdate = items_ChatStatusData?[index]
                entityUpdate?.chat_user_online = OnlineStatus
                //entityUpdate?.chat_user_typingStatus = GivenUserName
                
                do {
                    try Constants.coreDataContext.save()
                } catch let error as NSError {
                    print("Could not update. \(error), \(error.userInfo)")
                }
                
            } else {
                Save_UserOnlineStatus_Data_Fns()
            }
        }//for_each End,,,,,
    }
    
    func Save_UserOnlineStatus_Data_Fns() {
        //MARK: Add data to local DB
        let chatStatus = ChatOnlineTypingStatusEntity(context: Constants.coreDataContext)
        chatStatus.chat_user_name = GivenUserName
        chatStatus.chat_user_online = OnlineStatus
        //chatStatus.chat_user_typingStatus = GivenUserName
        
        do {
            try Constants.coreDataContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //important
    /*if let topVC = UIApplication.getTopViewController() {
        let getCurrentVcName = topVC.debugDescription.slice(from: ".", to: ":")
        //print("getCurrentVcName==>>", getCurrentVcName ?? "")
        if getCurrentVcName == "ChatMainVc" {
            
        } else if getCurrentVcName == "ChattingVc" {
            //ChattingVc().viewModel.Set_OnlineStatus_toThisPageVariable_Fns(GivenUserName: GivenUserName, OnlineStatus: OnlineStatus)
        }
    }*/
    //important
    
}


func SetRoomsListsDataUpdate_Fns(GivenRoomId: String, ActionType: String, status: String) {
    
    //MARK: THIS is UPDATTING ROOM PARTICULAR DATA PURPOSE to Local db Start,,,,,
    //MARK: - Core Data Initialise
    let items_RoomsData = core_DataContext_fetch_ChatRoomsAllDatas(entityName: Constants.EntityNames.ENTITY_CHAT_ROOMS)
    //print("items_RoomsData===>>\(items_RoomsData?.count ?? 0) && items_room_id===>>\(items?[0].chat_room_id ?? "--")")
    items_RoomsData?.enumerated().forEach { (index, element) in
        guard let room_id = element.chat_room_id else { return }
        //print("GivenRoomId===>>\(GivenRoomId) && room_id===>>\(room_id)")
        if room_id == GivenRoomId {
            
            //=================================************************************=================================
            //MARK: THIS is UPDATTING ROOM MSG PURPOSE, So no need to store LastMsg Data to Local db Start,,,,,
            Constants.GlobalValues.isChatRoomsWantToRefresh = true
            //=================================************************************=================================
            
            //MARK: Update data to local DB
            let entityUpdate = items_RoomsData?[index]
            
            if ActionType == "status_online_update" {
                entityUpdate?.chat_user_online = dataValidation(data: status as AnyObject)
            } else if ActionType == "status_muteORunmute_chat_notifications" {
                entityUpdate?.isMuteChatNotifications = dataValidation(data: status as AnyObject)
            } else if ActionType == "status_hidden_room" {
                entityUpdate?.chat_hiddenRoomStatus = dataValidation(data: status as AnyObject)
            }
            
            do {
                try Constants.coreDataContext.save()
            } catch let error as NSError {
                print("Could not update. \(error), \(error.userInfo)")
            }
            
            //return//If condition done JUST skip this for loop.....
        }//if End,,,,,
    }//for_each End,,,,,
    //MARK: THIS is UPDATTING ROOM PARTICULAR DATA PURPOSE to Local db End,,,,,
    
}

*/



/*
 //ME Sent
String received {"msg":"changed","collection":"stream-notify-user","id":"id","fields":{"eventName":"bxH5TKDpX4SDcBPoF/subscriptions-changed","args":["updated",{"_id":"jpSzYbYH4APGRSrj2","rid":"CkMxpQ6hqQeXWYdjkbxH5TKDpX4SDcBPoF","u":{"_id":"bxH5TKDpX4SDcBPoF","username":"Kupendiran_O6N3"},"_updatedAt":{"$date":1688556018983},"alert":false,"fname":"Hari","groupMentions":0,"name":"Hari_Q5J1","open":true,"t":"d","unread":0,"userMentions":0,"ls":{"$date":1688556018983}}]}}

 //Others Sent
 String received {"msg":"changed","collection":"stream-notify-user","id":"id","fields":{"eventName":"bxH5TKDpX4SDcBPoF/rooms-changed","args":["updated",{"_id":"CkMxpQ6hqQeXWYdjkbxH5TKDpX4SDcBPoF","t":"d","usernames":["Hari_Q5J1","Kupendiran_O6N3"],"usersCount":2,"ts":{"$date":1688497508490},"uids":["CkMxpQ6hqQeXWYdjk","bxH5TKDpX4SDcBPoF"],"default":false,"ro":false,"sysMes":true,"_updatedAt":{"$date":1688556157720},"lastMessage":{"rid":"CkMxpQ6hqQeXWYdjkbxH5TKDpX4SDcBPoF","msg":"Gshs","ts":{"$date":1688556157680},"u":{"_id":"CkMxpQ6hqQeXWYdjk","username":"Hari_Q5J1","name":"Hari"},"unread":true,"_id":"JieFD3PhWGKjrJnx7","_updatedAt":{"$date":1688556157708},"urls":[],"mentions":[],"channels":[],"md":[{"type":"PARAGRAPH","value":[{"type":"PLAIN_TEXT","value":"Gshs"}]}]},"lm":{"$date":1688556157680}}]}}
 String received {"msg":"changed","collection":"stream-notify-user","id":"id","fields":{"eventName":"bxH5TKDpX4SDcBPoF/notification","args":[{"title":"Hari_Q5J1","text":"Gshs","payload":{"_id":"JieFD3PhWGKjrJnx7","rid":"CkMxpQ6hqQeXWYdjkbxH5TKDpX4SDcBPoF","sender":{"_id":"CkMxpQ6hqQeXWYdjk","username":"Hari_Q5J1","name":"Hari"},"type":"d","message":{"msg":"Gshs"}}}]}}
 String received {"msg":"changed","collection":"stream-notify-user","id":"id","fields":{"eventName":"bxH5TKDpX4SDcBPoF/subscriptions-changed","args":["updated",{"_id":"jpSzYbYH4APGRSrj2","rid":"CkMxpQ6hqQeXWYdjkbxH5TKDpX4SDcBPoF","u":{"_id":"bxH5TKDpX4SDcBPoF","username":"Kupendiran_O6N3"},"_updatedAt":{"$date":1688556157752},"alert":true,"fname":"Hari","groupMentions":0,"name":"Hari_Q5J1","open":true,"t":"d","unread":1,"userMentions":0,"ls":{"$date":1688556018983}}]}}
 
 //why this?
 String received {"msg":"changed","collection":"stream-notify-user","id":"id","fields":{"eventName":"wE8BbcqCEWhHH9RGt/subscriptions-changed","args":["removed",{"_id":"7NvZaKkC5EwgYTfDL","rid":"oGzSmkneitFi6z8og","u":{"_id":"wE8BbcqCEWhHH9RGt","username":"Kupendiran_O6N3"}}]}}
 
 Online offline status
 String received {"msg":"changed","collection":"stream-notify-logged","id":"id","fields":{"eventName":"user-status","args":[["DRHELAQ7XhnvMitNy","Thiyagaraj_R8N1",1,""]]}}
 String received {"msg":"changed","collection":"stream-notify-logged","id":"id","fields":{"eventName":"user-status","args":[["DRHELAQ7XhnvMitNy","Thiyagaraj_R8N1",0,""]]}}
 
 //Typing status
 String received {"msg":"changed","collection":"stream-notify-room","id":"id","fields":{"eventName":"DRHELAQ7XhnvMitNybxH5TKDpX4SDcBPoF/user-activity","args":["Thiyagaraj_R8N1",["user-typing"],{}]}}
 String received {"msg":"changed","collection":"stream-notify-room","id":"id","fields":{"eventName":"DRHELAQ7XhnvMitNybxH5TKDpX4SDcBPoF/user-activity","args":["Thiyagaraj_R8N1",[],{}]}}
*/
