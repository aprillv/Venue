//
//  AdressListViewController.swift
//  Contract
//
//  Created by April on 11/19/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class EventsListViewController: UITableViewController, UISearchBarDelegate{
    @IBOutlet var viewHeight: NSLayoutConstraint!{
        didSet{
            viewHeight.constant = 1.0 / UIScreen.mainScreen().scale
        }
    }
    
    var tableTag: NSInteger?
    
    
    @IBOutlet var txtField: UITextField!{
        didSet{
            txtField.layer.cornerRadius = 5.0
            txtField.placeholder = "Search"
            txtField.clearButtonMode = .WhileEditing
            txtField.leftViewMode = .Always
            txtField.leftView = UIImageView(image: UIImage(named: "search"))
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EventsListViewController.textFieldDidChange(_:)), name: UITextFieldTextDidChangeNotification, object: txtField)
        }
        
    }
    
    func textFieldDidChange(notifications : NSNotification){
        if let txt = txtField.text?.lowercaseString{
            if txt.isEmpty{
                self.showAllInCurrentFilter()
            }else{
                EventList = EventListOrigin?.filter(){
                    return $0.venuename!.lowercaseString.containsString(txt)
                        || $0.eventname!.lowercaseString.containsString(txt)
                        || $0.approveby!.lowercaseString.containsString(txt)
                        || $0.reason!.lowercaseString.containsString(txt)
                    || $0.start!.lowercaseString.containsString(txt)
                    || $0.end!.lowercaseString.containsString(txt)
                        || $0.approvedate!.lowercaseString.containsString(txt)
                    
                }
            }
        }else{
            self.showAllInCurrentFilter()
//            AddressList = AddressListOrigin
        }
    }
//    var lastSelectedIndexPath : NSIndexPath?
   
    @IBOutlet var backItem: UIBarButtonItem!
    @IBOutlet var switchItem: UIBarButtonItem!
//    @IBOutlet var searchBar: UISearchBar!
    @IBAction func Logout(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    var head : EventListViewHeadView?
    var EventListOrigin : [EventItem]?{
        didSet{
            
            if tableTag != 2 {
                
                self.EventList = self.EventListOrigin
                //                self.showAll()
            }else{
//                self.showAllInCurrentFilter()
            }
        }
    }
    
    private func showAllInCurrentFilter(){
//        if tableView.tag == 2 {
//            let userinfo = NSUserDefaults.standardUserDefaults()
//            let a = userinfo.integerForKey(CConstants.ShowFilter)
//            if a == 1 {
//                showHomeOwnerSign()
//                //                self.AddressList = self.AddressListOrigin?.filter(){
//                //                    return $0.status!.containsString("iPad Sign") || $0.status!.containsString("Email Sign")}
//            }else if a == 2 {
//                showSalesSign()
//                //                self.AddressList = self.AddressListOrigin?.filter(){
//                //                    return !($0.status!.containsString("iPad Sign") || $0.status!.containsString("Email Sign"))}
//            }else if a == 3 {
//                showReCreate()
//            }else{
//                showAll()
//                
//            }
//        }else{
//            EventList = AddressListOrigin
//        }
        
    }
    
    var AddressListOrigin2 : [EventItem]?
    
    
    private var filesNms : [String]?
    private var EventList : [EventItem]? {
        didSet{
            self.tableView?.reloadData()
        }
    }
    
    
    @IBOutlet weak var LoginUserName: UIBarButtonItem!{
        didSet{
            let userInfo = NSUserDefaults.standardUserDefaults()
            LoginUserName.title = userInfo.objectForKey(CConstants.LoggedUserNameKey) as? String
        }
    }
    // MARK: - Constanse
    private struct constants{
        static let Title : String = "Venue Events"
        static let CellIdentifier : String = "Events Cell Identifier"
        static let DraftCellIdentifier : String = "Events2 Cell Identifier"
       
    }
    
    
    
    // MARK: - life cycle
    var firstCall = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getEventListFromServer()
        
        self.tableView.tag = tableTag ?? 2
        self.navigationItem.hidesBackButton = true
        self.title = constants.Title
        if tableTag != 2 {
//            salesBtn.hidden = true
        }
        
        
        self.tableView.reloadData()
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    

    
    // MARK: - Search Bar Deleagte
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
       
        
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventList?.count ?? 0
    }

   override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return EventListViewHeadView()
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  35
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell;
//        if tableView.tag == 2{
             cell = tableView.dequeueReusableCellWithIdentifier(constants.CellIdentifier, forIndexPath: indexPath)
//            cell.separatorInset = UIEdgeInsetsZero
//            cell.layoutMargins = UIEdgeInsetsZero
            cell.preservesSuperviewLayoutMargins = false
            if let cellitem = cell as? EventListViewCell {
                
                cellitem.eventInfo = EventList![indexPath.row]
                
            }
            
            
            
            
//        }else{
//            cell = tableView.dequeueReusableCellWithIdentifier(constants.DraftCellIdentifier, forIndexPath: indexPath)
////            cell.separatorInset = UIEdgeInsetsZero
////            cell.layoutMargins = UIEdgeInsetsZero
//            cell.preservesSuperviewLayoutMargins = false
//            if let cellitem = cell as? AddressDraftListViewCell {
//                let ddd = CiaNmArray?[CiaNm?[indexPath.section] ?? ""]
//                cellitem.contractInfo = ddd![indexPath.row]
//            }
//        }
//        if let indexa = tableView.indexPathForSelectedRow{
//            if indexa == indexPath{
//                cell.contentView.backgroundColor = CConstants.SearchBarBackColor
//            }else{
//                cell.contentView.backgroundColor = UIColor.whiteColor()
//            }
//        }
        
        return cell
        
    }
    
    private func getLongString(originStr : String) -> String{
        if originStr.characters.count < 16 {
            let tmp = "                "
            return originStr.stringByAppendingString(tmp.substringFromIndex(originStr.endIndex))
        }else{
            return originStr
        }
    }
    
    func GoToPrint(modelNm: [String]) {
         self.filesNms = modelNm
//        self.filesNms = ["Addendum C"]
//        if modelNm.count == 1 {
//            callService(modelNm)
//        }else{
//            if modelNm.contains(CConstants.ActionTitleAddendumC){
//                callService(modelNm)
//            }else{
//                self.performSegueWithIdentifier(CConstants.SegueToPrintPdf, sender: modelNm)
//            }
//        }
        
        

    }
    
    // go to print Addendum C signature
//    private func doAddendumCAction(_ : UIAlertAction) -> Void {
//        callService(CConstants.AddendumCServiceURL)
//    }
//    // go to print ClosingMemo
//    private func doClosingMemoAction(_ : UIAlertAction) -> Void {
//        callService(CConstants.ClosingMemoServiceURL)
//    }
//    // go to print DesignCenter
//    private func doDesignCenterAction(_ : UIAlertAction) -> Void {
//        callService(CConstants.DesignCenterServiceURL)
//    }
//    // go to print Contract signature
//    private func doContractAction(_ : UIAlertAction) -> Void {
//        callService(CConstants.ContractServiceURL)
//    }
//    private func doThirdPartyFinancingAddendumAction(_: UIAlertAction) -> Void{
//        callService(CConstants.AddendumAServiceURL)
//    }
    
    @IBOutlet var filterItem: UIBarButtonItem!
    
//    private func callService(printModelNms: [String]){
//        var serviceUrl: String?
//        var printModelNm : String
//        if printModelNms.count == 1 {
//            printModelNm = printModelNms[0]
//        }else{
//            printModelNm = CConstants.ActionTitleAddendumC
//        }
//        switch printModelNm{
//        case CConstants.ActionTitleAddendumC:
//            serviceUrl = CConstants.AddendumCServiceURL
//        default:
//            serviceUrl = CConstants.AddendumAServiceURL
//        }
//        
//        
//        if let indexPath = tableView.indexPathForSelectedRow {
//            let ddd = self.CiaNmArray?[self.CiaNm?[indexPath.section] ?? ""]
//            let item: ContractsItem = ddd![indexPath.row]
//            
////            print(ContractRequestItem(contractInfo: item).DictionaryFromObject())
//            let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
//            //                hud.mode = .AnnularDeterminate
//            hud.labelText = CConstants.RequestMsg
//            Alamofire.request(.POST,
//                CConstants.ServerURL + serviceUrl!,
//                parameters: ContractRequestItem(contractInfo: item).DictionaryFromObject()).responseJSON{ (response) -> Void in
//                    hud.hide(true)
////                    print(ContractRequestItem(contractInfo: item).DictionaryFromObject())
//                        if response.result.isSuccess {
//                            
//                            if let rtnValue = response.result.value as? [String: AnyObject]{
//                                if let msg = rtnValue["message"] as? String{
//                                    if msg.isEmpty{
//                                        switch printModelNm {
//                                        case CConstants.ActionTitleAddendumC:
////                                            if printModelNms.count == 1 {
////                                                let rtn = ContractAddendumC(dicInfo: rtnValue)
////                                                self.performSegueWithIdentifier(CConstants.SegueToAddendumC, sender: rtn)
////                                            }else{
////                                            print(response.result.value)
//                                                let rtn = ContractAddendumC(dicInfo: rtnValue)
//                                                self.performSegueWithIdentifier(CConstants.SegueToPrintPdf, sender: rtn)
////                                            }
//                                        default:
//                                            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
//                                        }
//                                        
//                                        
//                                    }else{
//                                        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
//                                        self.PopMsgWithJustOK(msg: msg)
//                                    }
//                                }else{
//                                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
//                                    self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
//                                }
//                            }else{
//                                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
//                                self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
//                            }
//                        }else{
//                            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
////                            self.spinner?.stopAnimating()
//                            self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
//                        }
//                    }
//            
//            
//        }
//    }
    
    
//    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
//        removebackFromCell()
//        if let cell  = tableView.cellForRowAtIndexPath(indexPath) {
//        cell.contentView.backgroundColor = CConstants.SearchBarBackColor
//        }
//        
//    }
//    
//    override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
//        if let cell  = tableView.cellForRowAtIndexPath(indexPath) {
//            lastSelectedIndexPath = indexPath
//            cell.contentView.backgroundColor = .clearColor()
//        }
//        
//    }

//    private func removebackFromCell(){
//        if let _ = lastSelectedIndexPath {
//            if let cell = tableView.cellForRowAtIndexPath(lastSelectedIndexPath!){
//                cell.contentView.backgroundColor = .clearColor()
//            }
//        }
//    }
    
//    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        removebackFromCell()
//    }
   
    var selectRowIndex : NSIndexPath?
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        removebackFromCell()
//        if let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath){
//            lastSelectedIndexPath = indexPath
//            selectedCell.contentView.backgroundColor = CConstants.SearchBarBackColor
//        }
//       self.txtField.resignFirstResponder()
//        var contract : ContractsItem?
//        if tableView.tag == 2{
//            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? AddressListViewCell {
//                contract = cell.contractInfo
//            }
//        }else{
//            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? AddressDraftListViewCell {
//                contract = cell.contractInfo
//            }
//        }
//        selectRowIndex = indexPath
//        let userInfo = NSUserDefaults.standardUserDefaults()
//        
//        userInfo.setBool(self.tableView.tag == 2, forKey: CConstants.UserInfoIsContract)
//        if self.tableView.tag == 2 {
//            if (contract?.status ?? "") == CConstants.ApprovedStatus && !(contract?.signfinishdate ?? "").containsString("1980"){
//                if (userInfo.stringForKey(CConstants.UserInfoEmail) ?? "").lowercaseString == CConstants.Administrator {
//                    GetPrintedFileList(contract)
//                }else{
//                    self.performSegueWithIdentifier("showSendEmailAfterAprroved1", sender: contract)
//                }
//                
//            }else{
//                GetPrintedFileList(contract)
//            }
//            
//        }else{
//            contract?.printList = nil
//            self.performSegueWithIdentifier(CConstants.SegueToPrintModel, sender: contract)
//        }
    }
    
    func GetPrintedFileList(contract : ContractsItem?){
        if let c = contract {
            let param = ["idcontract1" : c.idnumber ?? ""]
//            print(param,  CConstants.ServerURL + "bacontract_GetPrintedFileList.json")
            Alamofire.request(.POST, CConstants.ServerURL + "bacontract_GetPrintedFileList.json", parameters: param).responseJSON{ (response) -> Void in
//                print(response.result.value)
                if response.result.isSuccess {
                    contract?.printList = response.result.value as? [Int]
                    self.performSegueWithIdentifier(CConstants.SegueToPrintModel, sender: contract)
//                    print(response.result.value)
                }else{
                    contract?.printList = nil
                    self.performSegueWithIdentifier(CConstants.SegueToPrintModel, sender: contract)
                }
            }
        }
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let identifier = segue.identifier {
//            switch identifier {
//            case "showSendEmailAfterAprroved1":
//                if let con = segue.destinationViewController as? EmailAfterApprovedViewController {
//                    con.contractInfo = sender as? ContractsItem
//                }
//            case CConstants.SegueToPrintModel:
//                
//                if let controller = segue.destinationViewController as? PrintModelTableViewController {
//                   controller.delegate = self
//                    controller.projectInfo = sender as? ContractsItem
//                }
//                break
//            case "showFilter":
////                self.detailsPopover = [[self storyboard] instantiateViewControllerWithIdentifier:@"identifierName"];
////                
////                //... config code for the popover
////                
////                UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:detailsPopover];
////                
////                //... store popover view controller in an ivar
////                
////                [self.annotationPopoverController presentPopoverFromRect:selectedAnnotationView.bounds inView:selectedAnnotationView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//                
//                
////                let p = UIStoryboard(name: "Main").instantiateViewControllerWithIdentifier(identifier: "FilterViewController")
////                
////                let pc = UIPopoverController(contentViewController: p)
////                self.navigationController?.presentViewController(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
//                
//                if let controller = segue.destinationViewController as? FilterViewController {
//                    controller.delegate1 = self
////                    self.popoverPresentationController?.sourceView = salesBtn;
////                    self.popoverPresentationController?.sourceRect = salesBtn.bounds;
//                    
//                }
//                break
//            case CConstants.SegueToPrintPdf:
//                if let controller = segue.destinationViewController as? PDFPrintViewController {
//                    if let indexPath = (tableView.indexPathForSelectedRow ?? selectRowIndex){
//                        let ddd = self.CiaNmArray?[self.CiaNm?[indexPath.section] ?? ""]
//                        let item: ContractsItem = ddd![indexPath.row]
//                        item.approvedate = "01/01/1980"
//                        item.approveMonthdate = "01 Jun 80"
//                        if let info = sender as? ContractAddendumC {
//                            controller.pdfInfo0 = info
//                            controller.addendumCpdfInfo = info
////                            controller.AddressList = self.AddressListOrigin
////                            print(self.filesNms!)
//                            controller.filesArray = self.filesNms!
////                            print(controller.filesArray)
//                            controller.contractInfo = item
//                            var itemList = [[String]]()
//                            var i = 0
//                            if let list = info.itemlist {
//                                for items in list {
//                                    
//                                    var itemList1 = [String]()
//                                    let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 657.941, height: 13.2353))
//                                    textView.scrollEnabled = false
//                                    textView.font = UIFont(name: "Verdana", size: 11.0)
//                                    textView.text = items.xdescription!
//                                    textView.sizeToFit()
//                                    textView.layoutManager.enumerateLineFragmentsForGlyphRange(NSMakeRange(0, items.xdescription!.characters.count), usingBlock: { (rect, usedRect, textContainer, glyphRange, _) -> Void in
//                                        if  let a : NSString = items.xdescription! as NSString {
//                                            
//                                            i += 1
//                                            itemList1.append(a.substringWithRange(glyphRange))
//                                        }
//                                    })
//                                    //                            itemList1.append("april test")
//                                    itemList.append(itemList1)
//                                }
//                            }
//                            controller.addendumCpdfInfo!.itemlistStr = itemList
//                            
//                            //                        let pass = i > 19 ? CConstants.PdfFileNameAddendumC2 : CConstants.PdfFileNameAddendumC
//                            
//                            controller.page2 = i > 19
//                            //                        controller.initWithResource(pass)
//                            
//                        }else{
//                            
//                            
//                            let info = ContractPDFBaseModel(dicInfo: nil)
//                            info.code = item.code
//                            info.idcia = item.idcia
//                            info.idproject = item.idproject
//                            info.idnumber = item.idnumber
//                            info.idcity = item.idcity
//                            info.nproject = item.nproject
//                            controller.contractInfo = item
//                            controller.pdfInfo0 = info
////                            controller.AddressList = self.AddressListOrigin
//                            controller.filesArray = self.filesNms
//                            controller.page2 = false
//                        }
//                        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
//                    }
//                    
//                }
//            
//            default:
//                break;
//            }
//        }
    }

    @IBAction func refreshAddressList(sender: UIRefreshControl) {
        
        self.getEventListFromServer()
    }
    
    
    
    private func PopMsgWithJustOK(msg msg1: String){
        
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: msg1, preferredStyle: .Alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: CConstants.MsgOKTitle, style: .Cancel) { Void in
            
        }
        alert.addAction(oKAction)
        
        
        //Present the AlertController
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.txtField.resignFirstResponder()
    }
    
    
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.hidesBarsOnSwipe = true
        let userinfo = NSUserDefaults.standardUserDefaults()
        userinfo.setValue(nil, forKey: CConstants.UserInfoPrintModel)
        kCFDateFormatterDoesRelativeDateFormattingKey
        
        
        if firstCall {
            firstCall = false
        }else{
            self.refreshControl?.beginRefreshing()
            self.getEventListFromServer()
        }
        
//        self.extendedLayoutIncludesOpaqueBars = true
//        self.edgesForExtendedLayout = .None
//        self.automaticallyAdjustsScrollViewInsets = true
        
    }
    
//    func showAll() {
//        let userInfo = NSUserDefaults.standardUserDefaults()
//        if tableView.tag == 2{
//            if (userInfo.stringForKey(CConstants.UserInfoEmail) ?? "").lowercaseString == CConstants.Administrator {
//                AddressList = AddressListOrigin?.filter(){
//                    return !((!($0.status!.containsString("iPad Sign") || $0.status!.containsString("Email Sign"))) && (!($0.signfinishdate ?? "1980").containsString("1980")))
//                }
//                salesBtn.setTitle("Filter", forState: .Normal)
//            }else{
//                //            AddressList = AddressListOrigin
//                AddressList = AddressListOrigin?.filter(){
//                    return !((!($0.status!.containsString("iPad Sign") || $0.status!.containsString("Email Sign"))) && (!($0.signfinishdate ?? "1980").containsString("1980")))
//                }
//                salesBtn.setTitle("Filter", forState: .Normal)
//            }
//        }else{
//            AddressList = AddressListOrigin
//        }
//        
//        
//    }
//    func showHomeOwnerSign() {
//        AddressList = AddressListOrigin?.filter(){
//             return $0.status!.containsString("iPad Sign") || $0.status!.containsString("Email Sign")
//        }
//        salesBtn.setTitle("Homeowner Sign", forState: .Normal)
//    }
//    
//    @IBOutlet var salesBtn: UIButton!
//    func showSalesSign() {
//        
//            AddressList = AddressListOrigin?.filter(){
//                return (!($0.status!.containsString("iPad Sign") || $0.status!.containsString("Email Sign"))) && (($0.signfinishdate ?? "1980").containsString("1980"))
//            }
//            salesBtn.setTitle("Sales Sign", forState: .Normal)
//        
//    }
//    
//    func showReCreate() {
//        AddressList = AddressListOrigin?.filter(){
//            return (!($0.status!.containsString("iPad Sign") || $0.status!.containsString("Email Sign"))) && (!($0.signfinishdate ?? "1980").containsString("1980"))
//        }
//        let userInfo = NSUserDefaults.standardUserDefaults()
//        if (userInfo.stringForKey(CConstants.UserInfoEmail) ?? "").lowercaseString == CConstants.Administrator {
//            
//            salesBtn.setTitle("Re-Create", forState: .Normal)
//        }else{
//            salesBtn.setTitle("Finished", forState: .Normal)
//        }
//        
//    }
    
    func getEventListFromServer(){
        var hud1 : MBProgressHUD?
        if !(self.refreshControl?.refreshing ?? false){
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            //                hud.mode = .AnnularDeterminate
            hud.labelText = CConstants.RequestMsg
            hud1 = hud
        }
        
        let userInfo = NSUserDefaults.standardUserDefaults()
        let email = userInfo.valueForKey(CConstants.UserInfoEmail) as? String
        let password = userInfo.valueForKey(CConstants.UserInfoPwd) as? String
        
        
        let loginUserInfo = LoginUser(email: email!, password: password!, iscontract: "1")
        
        let a = loginUserInfo.DictionaryFromObject()
        //                print(a)
        Alamofire.request(.POST, CConstants.ServerURL + CConstants.EventListServiceURL, parameters: a).responseJSON{ (response) -> Void in
            hud1?.hide(true)
            self.refreshControl?.endRefreshing()
            if response.result.isSuccess {
                if let rtnValue = response.result.value as? [String: AnyObject]{
                    var eventlist = [EventItem]()
                    if let events = rtnValue["events"] as? [[String: String]]{
                        if events.count > 0 {
                            
                            for evnt in events {
                                let aevent = EventItem(dicInfo: evnt)
                                eventlist.append(aevent)
                            }
                            
                        }
                    }
                    self.txtField.text = ""
                    self.EventListOrigin = eventlist
                }
            }
        }
    }
    
   
    
    
}
