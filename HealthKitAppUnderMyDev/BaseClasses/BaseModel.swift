//
//  BaseModel.swift
//

import Foundation
import UIKit
import AVFoundation


enum ErrorInfo {
    case error(reason: String?)
}
enum ResultType {
    case arrayType
    case modelType
}
class BaseModel {
    typealias completionBlock = (_ resultType : ResultType? , _ result : Any? , _ error : ErrorInfo?) -> Void
    
    func logData() {
    }
	
}

class ErrorModel {
    
    let message: String?
    
    init(response: [String: Any]) {
        message = response["message"] as? String
    }
    
}



//MARK: One VC to another
/*
     let nextPageVC = instantiateVC(storyboardName: Constants.Storyboard.Name.LOGINANDSIGNUP, storyboardId: Constants.Storyboard.Identifier.PAYLEARNMORE_VC) as! PayLearnMore_VController //PAYPREMIUMLIST_VCONTROLLER //PayPremiumList_VController
     self.controller.navigationController?.pushViewController(nextPageVC, animated: true)
 */


//MARK: Back action using navigation
/*
 @IBAction func backIconBtn_Pressed(_ sender: UIButton) {
     self.controller.navigationController?.popViewController(animated: true)
 }
 */


//MARK: Vw to Vc connection setups
/*
 //Vw
 var controller : SubscriptionVc!
 //MARK: Set Controller
 func setController(controller : SubscriptionVc) -> Void {
     self.controller = controller
 }
 
 //Vc
 showCaseProjList_View.setController(controller: self)
 */


//MARK: UITableView setups
/*
 postInsightView.boxTableVw.register(UINib(nibName: "PerformedListsCell", bundle: nil), forCellReuseIdentifier: "PerformedListsCell")
 
 postInsightView.boxTableVw.delegate = self
 postInsightView.boxTableVw.dataSource = self
 =======
 
 if let arr = self.projListModel?.arrProjectsList , let model = arr[indexPath.row] as? ProjectListContentModel, let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.XIBName.SHOWCASE_PROJECT_TABLEVIEWCELL) as? ShowCaseProj_TableVwCell {
     //let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.XIBName.SHOWCASE_PROJECT_TABLEVIEWCELL, for: indexPath) as! ShowCaseProj_TableVwCell
     cell.selectionStyle = UITableViewCell.SelectionStyle.none
 
    return cell
 }
 else{
    return UITableViewCell();
 }
 ======
 */



//MARK: SlideMenu setups
/*
 @IBAction func SlideMenuBtn_Pressed(_ sender: UIButton) {
     onSlideMenuButtonPressed(sender)
 }
 */


//MARK: NavigationBarHidden setups
/*
 override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
     navigationController?.setNavigationBarHidden(true, animated: animated)
 }
 override func viewWillDisappear(_ animated: Bool) {
     super.viewWillDisappear(animated)
     //navigationController?.setNavigationBarHidden(false, animated: animated)
 }
 */
