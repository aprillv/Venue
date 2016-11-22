//
//  SendOperationViewController.swift
//  Contract
//
//  Created by April on 12/22/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit

protocol DoOperationDelegate
{
    func saveToServer()
   
    func startover()
    func submit()
    
    func emailContractToLicensee()
    
    func changeLicenseeToIpad()
    
   
}


class SendOperationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var contractInfo : ContractDetail?
//        {
//        didSet{
//        print(contractInfo?.verify_code, contractInfo?.verify_code2, contractInfo?.buyer1SignFinishedyn, contractInfo?.buyer2SignFinishedyn)
//        }
//    }
    
    @IBOutlet weak var tableView: UITableView!
    var delegate1 : DoOperationDelegate?
    var showSave : Bool?
    var showSubmit : Bool?
    var showStartOver: Bool?
    var showEmailToLicensee : Bool?
    var enableSave : Bool?
    var enableSubmit : Bool?
    var enableStartOver: Bool?
    var showChangeToIPad : Bool?
    
    
    var FromWebSide : Bool?
    
    var isapproved : Bool?
    var justShowEmail : Bool?
    var hasCheckedPhoto : String?
    
    var showBuyer1GoToSign: Bool = false
    var showBuyer2GoToSign : Bool = false
    var showSellerGoToSign : Bool = false
    
    var itemList : [String]?{
        didSet{
            if let _ = itemList{
                tableView.reloadData()
            }
        }
    }
    
    
    private struct constants{
        static let cellReuseIdentifier = "operationCellIdentifier"
        static let rowHeight : CGFloat = 44
        static let operationSavetoServer = "Save Contract"
        static let operationSubmit = "Submit Contract"
        static let operationStartOver = "Start Over"
        static let operationEmailtoLicensee = "Email Contract to Licensee"
        static let operationSaveFinish = "Save & Finish"
        static let operationSaveEmail = "Save & Email"
        static let operationEmail = "Email"
//        static let operationSaveEmail = "Save & Email"
        static let operationClearDraftInfo = "Clear Buyer's Fields"
        static let operationFillDraftInfo = "Fill Buyer's Fields"
        static let operationAttatchPhoto = "Attach Photo Check"
        static let operationViewAttatchPhoto = "View Photo Check"
        
        static let operationEmailToBuyer = "Email Contract to Buyers"
        
        static let operationSubmitBuyer1 = "Submit Buyer1's sign"
        static let operationSubmitBuyer1Finished = "Buyer1's sign Submitted"
        static let operationSubmitBuyer2 = "Submit Buyer2's sign"
        static let operationSubmitBuyer2Finished = "Buyer2's sign Submitted"
        
        static let operationChangeLicenseeToIpad = "Change Licensee to iPad Sign"
        
//        static let operationBuyerGoToSign = "Buyer Go To Sign"
//        static let operationBuyer1GoToSign = "Buyer1 Go To Sign"
//        static let operationBuyer2GoToSign = "Buyer2 Go To Sign"
//        static let operationSellerGoToSign = "Seller Go To Sign"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tmp = [String]()
        if showSave ?? false {
            tmp.append(constants.operationSavetoServer)
        }
        if showSubmit  ?? false {
            tmp.append(constants.operationSubmit)
        }
        if showStartOver  ?? false {
            tmp.append(constants.operationStartOver)
        }
        if showEmailToLicensee   ?? false {
            tmp.append(constants.operationEmailtoLicensee)
        }
        if showChangeToIPad ?? false {
            tmp.append(constants.operationChangeLicenseeToIpad)
        }
        
        self.itemList = tmp
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return constants.rowHeight
    }
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 0
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.cellReuseIdentifier, forIndexPath: indexPath)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.textLabel?.text = itemList![indexPath.row]
        if (cell.textLabel?.text == constants.operationStartOver) {
            if (!(self.enableStartOver ?? false)){
                cell.textLabel?.textColor = UIColor.darkGrayColor()
            }else{
                cell.textLabel?.textColor = UIColor.blackColor()
            }
        }
        
        if (cell.textLabel?.text == constants.operationSavetoServer) {
            if (!(self.enableSave ?? false)){
                cell.textLabel?.textColor = UIColor.darkGrayColor()
            }else{
                cell.textLabel?.textColor = UIColor.blackColor()
            }
        }
        
        if (cell.textLabel?.text == constants.operationSubmit) {
            if (!(self.enableSubmit ?? false)){
                cell.textLabel?.textColor = UIColor.darkGrayColor()
            }else{
                cell.textLabel?.textColor = UIColor.blackColor()
            }
        }
        
//        
//        if (cell.textLabel?.text == constants.operationSubmit || cell.textLabel?.text == constants.operationSaveFinish || cell.textLabel?.text == constants.operationSaveEmail) {
//            if (!showSubmit!) {
//                cell.textLabel?.textColor = UIColor.darkGrayColor()
//            }else{
//                cell.textLabel?.textColor = UIColor.blackColor()
//            }
//        }
//        cell.accessoryType = .None
//        if cell.textLabel?.text == constants.operationAttatchPhoto{
//            if let c = self.hasCheckedPhoto {
//                if c == "1" {
//                    cell.accessoryView = UIImageView(image: UIImage(named: "check3"))
//                }
//            }
//        }else if cell.textLabel?.text == constants.operationSubmitBuyer1Finished || cell.textLabel?.text == constants.operationSubmitBuyer2Finished{
////            cell.accessoryView = UIImageView(image: UIImage(named: "check3"))
//            cell.textLabel?.textColor = UIColor.darkGrayColor()
//        }
        
        cell.textLabel?.textAlignment = .Center
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true){
            if let delegate0 = self.delegate1{
                switch self.itemList![indexPath.row]{
                    case constants.operationSavetoServer:
                        if self.showSave! && (self.enableSave ?? false) {
                            delegate0.saveToServer()
                        }
                case constants.operationStartOver:
                    if self.showStartOver! && (self.enableStartOver ?? false){
                        delegate0.startover()
                    }
                case constants.operationSubmit:
                    if self.showSubmit! && (self.enableSubmit ?? false) {
                        delegate0.submit()
                    }
                case constants.operationEmailtoLicensee:
                    delegate0.emailContractToLicensee()
                case constants.operationChangeLicenseeToIpad:
                    delegate0.changeLicenseeToIpad()
                    default:
                        break
                }
                
                
            }
        }
        
        
    }
    
    override var preferredContentSize: CGSize {
        get {
//            print(tableView.frame.width)
            return CGSize(width: tableView.frame.width
                , height: constants.rowHeight * CGFloat(itemList?.count ?? 1))
        }
        set { super.preferredContentSize = newValue }
    }
    
}
