//
//  PDFPrintViewController.swift
//  Contract
//
//  Created by April on 2/23/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI
import MBProgressHUD

class PDFPrintViewController: PDFBaseViewController, UIScrollViewDelegate, PDFViewDelegate, SubmitForApproveViewControllerDelegate, SaveAndEmailViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, GoToFileDelegate, EmailContractToBuyerViewControllerDelegate{
    private struct constants{
        static let operationMsg = "Are you sure you want to take photo of the check again?"
        static let segueToSendEmailAfterApproved = "showSendEmail"
        static let segueToEmailContractToBuyer = "EmailContractToBuyer"
        
        static let operationBuyerGoToSign = "Buyer Go To Sign"
        static let operationBuyer1GoToSign = "Buyer1 Go To Sign"
        static let operationBuyer2GoToSign = "Buyer2 Go To Sign"
        static let operationSellerGoToSign = "Seller Go To Sign"
        
    }
//    var currentlyEditingView : SPUserResizableView?
//    var lastEditedView : SPUserResizableView?
//    
//    func userResizableViewDidBeginEditing(userResizableView: SPUserResizableView!) {
//        currentlyEditingView?.hideEditingHandles()
//        currentlyEditingView = userResizableView;
//    }
//    func userResizableViewDidEndEditing(userResizableView: SPUserResizableView!) {
//         lastEditedView = userResizableView;
//    }
//    @IBAction func draw(sender: AnyObject) {
////        let b = MyView()
    @IBAction func skiptoNext(sender: UIBarButtonItem) {
        if let xt = sender.title {
            if xt == "" {
                return;
            }
            if let info = contractPdfInfo {
                if info.status == CConstants.ApprovedStatus && xt == "Next"{
                    self.gotoSellerSign()
                }else{
                    
                    if xt == "Next B-1" {
                        self.gotoBuyer1Sign()
                    }else if xt == "Next B-2" {
                        self.gotoBuyer2Sign()
                    }
                }
            }
        }
    }
////        b.frame = CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height - 113)
////        b.backgroundColor = UIColor.clearColor()
////        self.view.addSubview(b)
//        
//        let gripFrame = CGRectMake(50, 50, 200, 150)
//        let userResizableView = SPUserResizableView(frame: gripFrame)
//        let contentView = UIView(frame: gripFrame)
//        contentView.backgroundColor = UIColor.blackColor()
//        userResizableView.contentView = contentView
//        userResizableView.delegate = self
//        currentlyEditingView = userResizableView
//        lastEditedView = userResizableView
//        userResizableView.showEditingHandles()
//        self.pdfView?.pdfView.scrollView.addSubview(userResizableView)
//        
//        
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideEditingHandles))
//        gestureRecognizer.delegate = self
//        self.pdfView?.pdfView.scrollView.addGestureRecognizer(gestureRecognizer)
//        
//        
//    }
//    
//    func hideEditingHandles()  {
//        lastEditedView?.hideEditingHandles()
//    }
//    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
//        
//        if let c = currentlyEditingView {
//        return c.hitTest(touch.locationInView(currentlyEditingView), withEvent: nil) == nil
//        }
//        return true
//        
//    }
    
    var isDownload : Bool?
    @IBOutlet var view2: UIView!
    var addendumApdfInfo : AddendumA?{
        didSet{
//            self.setBuyer2()
//            if let c = contractInfo?.status {
//                if c == CConstants.ApprovedStatus {
//                    addendumApdfInfo?.approvedDate = contractInfo?.approvedate
//                }
//            }
            if let info = addendumApdfInfo {
                if let fDD = fileDotsDic {
                    let tool = SetDotValue()
                    
                    for (str, dots) in fDD {
//                        print(dots)
                        switch str{
                        case CConstants.ActionTitleThirdPartyFinancingAddendum:
                            tool.setThirdPartyFinacingAddendumDots(info, additionViews: dots)
                        case CConstants.ActionTitleAddendumA:
                            tool.setAddendumADots(info, additionViews: dots)
                        case CConstants.ActionTitleEXHIBIT_A:
                            tool.setExhibitADots(info, additionViews: dots)
                        case CConstants.ActionTitleEXHIBIT_B:
                            tool.setExhibitBDots(info, additionViews: dots)
                        case CConstants.ActionTitleEXHIBIT_C:
//                            print(dots)
                            tool.setExhibitCDots(info, additionViews: dots)
                        case CConstants.ActionTitleBuyersExpect:
                            tool.setBuyersExpectDots(info, additionViews: dots, pdfview: self.pdfView!)
                        case CConstants.ActionTitleWarrantyAcknowledgement:
                            tool.setWarrantyAcknowledegeDots(info, additionViews: dots)
                        case CConstants.ActionTitleHoaChecklist:
                            tool.setHoaChecklistDots(info, additionViews: dots)
                        case CConstants.ActionTitleFloodPlainAck:
                            tool.setFloodPlainAcknowledgementDots(info, additionViews: dots)
                        case CConstants.ActionTitleAddendumHOA:
                            tool.setAddendumHoaDots(info, additionViews: dots)
                        default:
                            break
                        }
                        
                    }
                }
            }
            
        }
        
    }
    
    
    var addendumCpdfInfo : ContractAddendumC?
    private func setAddendumC(){
        if let info = addendumCpdfInfo {
            if let fDD = fileDotsDic {
                let tool = SetDotValue()
                var i = 0
                for (str, dots) in fDD {
                    switch str{
                    case CConstants.ActionTitleAddendumC:
                        for doc in documents! {
                            if doc.pdfName == CConstants.ActionTitleAddendumC {
                                

                                
                                doc.addedviewss = tool.setAddendumCDots(info, additionViews: dots, pdfview: self.pdfView!, has2Pages0: self.page2!)
                                for sign in doc.addedviewss {
                                    if sign.isKindOfClass(SignatureView) {
                                        if let si = sign as? SignatureView {
                                            if contractInfo?.status != CConstants.ApprovedStatus {
                                                if si.xname.containsString("seller") || si.xname.containsString("bottom3"){
                                                    continue
                                                }
                                            }else{
                                                if si.xname.containsString("buyer")
                                                    || si.xname.containsString("bottom1")
                                                    || si.xname.containsString("bottom2"){
                                                    continue
                                                }
                                            }
                                            
                                            if  !info.buyer!.containsString(" / ")
                                                 && ( si.xname == "p1ACbuyer2Sign"
                                                || si.xname == "p1ACbuyer2DateSign")
                                            {
                                                if si.menubtn != nil {
                                                    si.menubtn.removeFromSuperview()
                                                    si.menubtn = nil
                                                }
                                                continue
                                            }
//                                            print(si.xname)
                                            si.pdfViewsssss = pdfView!
                                            pdfView!.addedCCCCAnnotationViews = doc.addedviewss
//                                            if contractInfo?.status ?? "" == CConstants.DraftStatus || (contractInfo?.status ?? "" == CConstants.ApprovedStatus && contractInfo?.signfinishdate ?? "" == "01/01/1980") {
//                                                si.addSignautre(pdfView!.pdfView!.scrollView)
//                                            }
                                            
                                            
                                        }
                                    }
                                }
                            }
                        }
                        return
                    default:
                        i += 1
                    }
                    
                }
            }
        }
    }
    var contractPdfInfo : ContractSignature?{
        didSet{
            
//           print("second")
            if let info = contractPdfInfo {
                setSendItema()
                contractInfo?.status = info.status
                contractInfo?.signfinishdate = info.signfinishdate
                contractInfo?.approvedate = info.approvedate
                contractInfo?.approveMonthdate = info.approveMonthdate
                setBuyer2()
                if let c = info.status {
                    if c ==  CConstants.ApprovedStatus {
//                        info.approvedate = "01/01/1980"
                        if (info.approvedate ?? "").hasSuffix("1980") {
                            self.PopMsgWithJustOK(msg: "Approved Date of Contract Cannot to be 1980 or emprty.")
                            
                            info.approvedate = ""
                        }
                        
                        if filesArray!.contains(CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES){
                            setBrokerDate()
                        }
                        if filesArray!.contains(CConstants.ActionTitleAddendumD){
                            setAddendumDDate()
                        }
                        if filesArray!.contains(CConstants.ActionTitleAddendumE){
                            setAddendumEDate()
                        }
                        if filesArray!.contains(CConstants.ActionTitleFloodPlainAck){
                            setFloodPlainAckDate()
                        }
                        if filesArray!.contains(CConstants.ActionTitleWarrantyAcknowledgement){
                            setWarrantyAcknowledgement()
                        }
                        if filesArray!.contains(CConstants.ActionTitleHoaChecklist){
                            setHoaChecklist()
                        }
                    }
                }
                
                
//                print(info.ipadsignyn)
                let b = Bool(info.ipadsignyn ?? 0)
                if b && (info.status == CConstants.DisApprovedStatus) {
                    self.PopMsgWithJustOK(msg: CConstants.GoToBAMsg, txtField: nil)
                }
                setSendItema()
                if let fDD = fileDotsDic {
                    let tool = SetDotValue()
                    
                    for (str, dots) in fDD {
                        switch str{
                        case CConstants.ActionTitleContract,
                         CConstants.ActionTitleDraftContract:
                            tool.setSignContractDots(info, additionViews: dots, pdfview: self.pdfView!, item: contractInfo)
                            return
                        default:
                            break
                        }
                    }
                }
            }
            
        }

    }
    var closingMemoPdfInfo: ContractClosingMemo?{
        didSet{
            
            if let info = closingMemoPdfInfo {
                if let fDD = fileDotsDic {
                    let tool = SetDotValue()
                    var i = 0
                    for (str, dots) in fDD {
                        switch str{
                        case CConstants.ActionTitleClosingMemo:
                            for doc in documents! {
                                if doc.pdfName == CConstants.ActionTitleClosingMemo {
                                    doc.addedviewss = tool.setCloingMemoDots(info, additionViews: dots, pdfview: self.pdfView!)
                                }
                            }
                            return
                        default:
                            i += 1
                        }
                    }
                }
            }
        }
    }
    var designCenterPdfInfo : ContractDesignCenter?{
        didSet{
            
            if let info = designCenterPdfInfo {
                if let fDD = fileDotsDic {
                    let tool = SetDotValue()
                    
                    for (str, dots) in fDD {
                        switch str{
                        case CConstants.ActionTitleDesignCenter:
                            info.txtDate = info.approvedate ?? ""
                            
                            tool.setDesignCenterDots(info, additionViews: dots)
                            return
                        default:
                            break
                        }
                    }
                }
            }
            
        }
        
    }
    
    var page2 : Bool?
    
    var filesArray : [String]?
    var filesPageCountArray : [Int]?
    var fileDotsDic : [String : [PDFWidgetAnnotationView]]?
    
    
    
    
    
    
    
    private func getFileName() -> String{
        return "contract1pdf_" + self.pdfInfo0!.idcity! + "_" + self.pdfInfo0!.idcia!
    }
    
    override func loadPDFView(){
        
        var filesNames = [String]()
        filesPageCountArray = [Int]()
        let param = ContractRequestItem(contractInfo: nil).DictionaryFromBasePdf(self.pdfInfo0!)
//print(param)
        
        let margins = getMargins()
        
//        var pageHeight : CGFloat = CConstants.PdfPageHeight
//        if let a  = NSUserDefaults.standardUserDefaults().valueForKey(CConstants.PdfPageMarginUserDefault) as? String{
//            if let n = NSNumberFormatter().numberFromString(a) {
//                pageHeight = CGFloat(n)
//                
//            }
//        }
        
        documents = [PDFDocument]()
        fileDotsDic = [String : [PDFWidgetAnnotationView]]()
        var allAdditionViews = [PDFWidgetAnnotationView]()
        
        var lastheight : Int
        var filePageCnt : Int = 0
        var called = true
//        print(filesArray)
        var calledContract = false
        for title in filesArray! {
            if title !=  CConstants.ActionTitleDesignCenter
            && title != CConstants.ActionTitleClosingMemo
            && title != CConstants.ActionTitleAddendumC
            && title != CConstants.ActionTitleContract
            && title != CConstants.ActionTitleDraftContract {
                if called{
//                    print("a1", title)
                    self.callService(title, param: param)
                    called = false;
                }
                
            }else{
                if !calledContract{
                    calledContract = (title == CConstants.ActionTitleContract
                        || title == CConstants.ActionTitleDraftContract)
                }
                
//                print("b1", title)
                self.callService(title, param: param)
            }
            
            var str : String
            
            lastheight = filePageCnt
            
            
            switch title {
            case CConstants.ActionTitleContract,
            CConstants.ActionTitleDraftContract:
//                print(contractPdfInfo?.idcity)
                if (contractInfo?.idcity ?? "1") == "3" {
                str = CConstants.PdfFielNameContract_Austin
                }else{
                str = CConstants.PdfFileNameContract
                }
                
                filePageCnt += CConstants.PdfFileNameContractPageCount
            case CConstants.ActionTitleThirdPartyFinancingAddendum:
                str = CConstants.PdfFileNameThirdPartyFinancingAddendum
                filePageCnt += CConstants.PdfFileNameThirdPartyFinancingAddendumPageCount
            case CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES:
                if contractInfo?.broker == "" {
                    str = CConstants.PdfFileNameINFORMATION_ABOUT_BROKERAGE_SERVICES
                }else{
                    str = CConstants.PdfFileNameINFORMATION_ABOUT_BROKERAGE_SERVICES2
                }
                
                filePageCnt += CConstants.PdfFileNameINFORMATION_ABOUT_BROKERAGE_SERVICESPageCount
            case CConstants.ActionTitleAddendumA:
                if contractInfo?.idcity ?? "1" == "3" {
                    str = CConstants.PdfFileNameAddendumA_austin
                }else{
                    str = CConstants.PdfFileNameAddendumA
                }
                
                filePageCnt += CConstants.PdfFileNameAddendumAPageCount
            case CConstants.ActionTitleAddendumHOA:
                str = CConstants.PdfFileNameAddendumHOA
                filePageCnt += CConstants.PdfFileNameAddendumHoaPageCount
            case CConstants.ActionTitleAddendumC:
                if self.page2! {
                    str = CConstants.PdfFileNameAddendumC2
                    filePageCnt += CConstants.PdfFileNameAddendumC2PageCount
                }else{
                    str = CConstants.PdfFileNameAddendumC
                    filePageCnt += CConstants.PdfFileNameAddendumCPageCount
                }
            case CConstants.ActionTitleBuyersExpect:
                str = CConstants.PdfFileNameBuyersExpect
                filePageCnt += CConstants.PdfFileNameBuyersExpectPageCount
            case CConstants.ActionTitleFloodPlainAck:
                str = CConstants.PdfFileNameFloodPlainAck
                filePageCnt += CConstants.PdfFileNameFloodPlainAckPageCount
                
            case CConstants.ActionTitleHoaChecklist:
                if let c = contractInfo?.hoa {
                    if c == 1{
                        str = CConstants.PdfFileNameHoaChecklist
                    }else{
                        str = CConstants.PdfFileNameHoaChecklist2
                    }
                }else{
                 str = CConstants.PdfFileNameHoaChecklist
                }
                
                filePageCnt += CConstants.PdfFileNameHoaChecklistPageCount
            case CConstants.ActionTitleWarrantyAcknowledgement:
                str = CConstants.PdfFileNameWarrantyAcknowledgement
                filePageCnt += CConstants.PdfFileNameWarrantyAcknowledgementPageCount
                
            case CConstants.ActionTitleAddendumD:
                str = CConstants.PdfFileNameAddendumD
                filePageCnt += CConstants.PdfFileNameAddendumDPageCount
            case CConstants.ActionTitleAddendumE:
                str = CConstants.PdfFileNameAddendumE
                filePageCnt += CConstants.PdfFileNameAddendumEPageCount
            case CConstants.ActionTitleEXHIBIT_A:
                str = CConstants.PdfFileNameEXHIBIT_A
                filePageCnt += CConstants.PdfFileNameEXHIBIT_APageCount
            case CConstants.ActionTitleEXHIBIT_B:
                if contractInfo?.idcity ?? "1" == "3" {
                    str = CConstants.PdfFileNameEXHIBIT_B_austin
                }else{
                    str = CConstants.PdfFileNameEXHIBIT_B
                }
                filePageCnt += CConstants.PdfFileNameEXHIBIT_BPageCount
            case CConstants.ActionTitleEXHIBIT_C:
                if contractInfo?.idcity ?? "1" == "3" {
                    str = CConstants.PdfFileNameEXHIBIT_C_austin
                }else{
                    str = CConstants.PdfFileNameEXHIBIT_C
                }
                filePageCnt += CConstants.PdfFileNameEXHIBIT_CPageCount
            case CConstants.ActionTitleClosingMemo:
                str = CConstants.PdfFileNameClosingMemo
                filePageCnt += CConstants.PdfFileNameClosingMemoPageCount
            case CConstants.ActionTitleDesignCenter:
                str = CConstants.PdfFileNameDesignCenter
                filePageCnt += CConstants.PdfFileNameDesignCenterPageCount
            default:
                str = ""
                filePageCnt += 0
            }
            filesPageCountArray?.append(filePageCnt-lastheight)
            
            filesNames.append(str)
            
            let document = PDFDocument.init(resource: str)
            document.pdfName = title
            documents?.append(document)
            
            
            if let additionViews = document.forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y, pageMargin: CGFloat(lastheight)) as? [PDFWidgetAnnotationView]{
                
                
                fileDotsDic![title] = additionViews
                
                allAdditionViews.appendContentsOf( additionViews)
            }
            
        }
        
        if (!calledContract) {
            callService(CConstants.ActionTitleContract, param: param)
        }
//        let a = NSDate()
//        print(NSDate())
        pdfView = PDFView(frame: view2.bounds, dataOrPathArray: filesNames, additionViews: allAdditionViews)
        pdfView?.delegate = self
//        sendItem.im
//        sendItem.title = "\(a) == \(NSDate())"
        //        print(self.document?.forms)
        setAddendumC()
        
        
        view2.addSubview(pdfView!)
        getSignature()
        
        getAllSignature()
        
        
        
    }
//    static let dd = "WExecutedSign1"
//    static let yyyy = "WYearSign1"
//    static let mmm = "WDayofSign1"
    
    private func setHoaChecklist(){
        if let fDD = fileDotsDic {
            //            let tool = SetDotValue()
            //            var i = 0
            for (str, dots) in fDD {
                switch str{
                case CConstants.ActionTitleHoaChecklist:
                    for sign in dots {
                        if sign.isKindOfClass(PDFFormTextField) {
                            if let si = sign as? PDFFormTextField {
                                
                                if si.xname == "p3Hbuyer1DateSign1"{
                                    si.value = contractInfo?.approvedate
                                }
                                
                                if let s = contractInfo?.client2 {
                                    if s != "" {
                                        if si.xname == "p3Hbuyer2DateSign1"{
                                            si.value = contractInfo?.approvedate
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    return
                default:
                    break;
                    //                    i += 1
                }
                
            }
        }
    }
    private func setWarrantyAcknowledgement(){
        if let fDD = fileDotsDic {
            //            let tool = SetDotValue()
            //            var i = 0
            for (str, dots) in fDD {
                switch str{
                case CConstants.ActionTitleWarrantyAcknowledgement:
                    var dd  = ""
                    var mmm  = ""
                    var yyyy  = ""
                    if let c = contractInfo?.approveMonthdate {
                        let a = c.componentsSeparatedByString(" ")
                        dd = a[0]
                        mmm = a[1]
                        yyyy = a[2]
                    }
                    for sign in dots {
                        if sign.isKindOfClass(PDFFormTextField) {
                            if let si = sign as? PDFFormTextField {
                                
                                if si.xname == "WExecutedSign1"{
                                    si.value = dd
                                }
                                
                                if si.xname == "WDayofSign1"{
                                    si.value = mmm
                                }
                                if si.xname == "WYearSign1"{
                                    si.value = yyyy.substringFromIndex(yyyy.startIndex.advancedBy(2))
                                }
                                
                            }
                        }
                    }
                    
                    return
                default:
                    break;
                    //                    i += 1
                }
                
            }
        }
    }
    
    
    private func setFloodPlainAckDate(){
        if let fDD = fileDotsDic {
            //            let tool = SetDotValue()
            //            var i = 0
            for (str, dots) in fDD {
                switch str{
                case CConstants.ActionTitleFloodPlainAck:
                    var dd  = ""
                    var mmm  = ""
                    var yyyy  = ""
                    if let c = contractInfo?.approveMonthdate {
                        let a = c.componentsSeparatedByString(" ")
                        dd = a[0]
                        mmm = a[1]
                        yyyy = a[2]
                    }
                    for sign in dots {
                        if sign.isKindOfClass(PDFFormTextField) {
                            if let si = sign as? PDFFormTextField {
                                
                                if si.xname == "FloodDaySign2"{
                                    si.value = dd
                                }
                                
                                if si.xname == "FloodDayofSign2"{
                                    si.value = mmm
                                }
                                if si.xname == "year"{
                                    si.value = yyyy
                                }
                                
                            }
                        }
                    }
                    
                    return
                default:
                    break;
                    //                    i += 1
                }
                
            }
        }
    }
    private func setAddendumEDate(){
        if let fDD = fileDotsDic {
            //            let tool = SetDotValue()
            //            var i = 0
            for (str, dots) in fDD {
                switch str{
                case CConstants.ActionTitleAddendumE:
                    for sign in dots {
                        if sign.isKindOfClass(PDFFormTextField) {
                            if let si = sign as? PDFFormTextField {
                                
                                if si.xname == "p2AEbuyer1DateSign1"{
                                    si.value = contractInfo?.approvedate
                                }
                                
                                if let s = contractInfo?.client2 {
                                    if s != "" {
                                        if si.xname == "p2AEbuyer2DateSign1"{
                                            si.value = contractInfo?.approvedate
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    return
                default:
                    break;
                    //                    i += 1
                }
                
            }
        }
    }
    private func setAddendumDDate(){
        if let fDD = fileDotsDic {
            //            let tool = SetDotValue()
            //            var i = 0
            for (str, dots) in fDD {
                switch str{
                case CConstants.ActionTitleAddendumD:
                    for sign in dots {
                        if sign.isKindOfClass(PDFFormTextField) {
                            if let si = sign as? PDFFormTextField {
                                
                                if si.xname == "p2ADbuyer1DateSign1"{
                                    si.value = contractInfo?.approvedate
                                }
                                
                                if let s = contractInfo?.client2 {
                                    if s != "" {
                                        if si.xname == "p2ADbuyer2DateSign1"{
                                            si.value = contractInfo?.approvedate
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    return
                default:
                    break;
                    //                    i += 1
                }
                
            }
        }
    }
    
    
    private func setBrokerDate(){
        if let fDD = fileDotsDic {
//            let tool = SetDotValue()
//            var i = 0
            for (str, dots) in fDD {
                switch str{
                case CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES:
                    for sign in dots {
                        if sign.isKindOfClass(PDFFormTextField) {
                            if let si = sign as? PDFFormTextField {
//                                print(si.xname)
                                if si.xname == "p2Ibrokerbuyer1DateSign1" || si.xname == "p2Ibroker2buyer1DateSign1"{
                                    si.value = contractInfo?.approvedate
                                }
                                
                                if let s = contractInfo?.client2 {
                                    if s != ""{
                                        if si.xname == "p2Ibrokerbuyer2DateSign1" || si.xname == "p2Ibroker2buyer2DateSign1"{
                                            si.value = contractInfo?.approvedate
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                            
                    return
                default:
                    break;
//                    i += 1
                }
                
            }
        }
    }
    private func setSendItema(){
        self.showSkipToNext()
        if let _ = self.contractPdfInfo {
            seller2Item.title = ""
            if contractPdfInfo!.status == CConstants.ForApproveStatus {
                sendItem.image = nil
                seller2Item.title = "Status: \(CConstants.ForApproveStatus)"
            }else if contractPdfInfo!.status == CConstants.DisApprovedStatus {
                sendItem.image = nil
                seller2Item.title = "Status: \(CConstants.DisApprovedStatus)"
            }else if contractPdfInfo!.status == CConstants.ApprovedStatus {
                if let ds = self.contractPdfInfo?.signfinishdate {
                    if  ds != "01/01/1980"{
                        sendItem.image = nil
                        seller2Item.title = "Status: Finished"
                        let userInfo = NSUserDefaults.standardUserDefaults()
                        if (userInfo.stringForKey(CConstants.UserInfoEmail) ?? "").lowercaseString == CConstants.Administrator {
                            seller2Item.title = "Re-Create PDF"
                            sendItem.image = UIImage(named: "send.png")
                        }else{
                            sendItem.image = UIImage(named: "send.png")
                        }
                        
                    }else{
                        if let fs = self.contractPdfInfo?.approvedate {
                            if fs == "" || fs.hasSuffix("1980"){
                                seller2Item.title = nil
                                sendItem.image = nil
                            }else{
                                seller2Item.title = nil
                                sendItem.image = UIImage(named: "send.png")
                            }
                        }else{
                            seller2Item.title = nil
                            sendItem.image = nil
                        }
                        
                        //                    let hh = contractInfo?.approvedate ?? "1980"
                        //                    if (hh.hasSuffix("1980") || hh.isEmpty ) {
                        //                        sendItem.image = nil
                        //                        sendItem.title = "Status: \(CConstants.ApprovedStatus)"
                        //                    }else{
                        //                        sendItem.title = nil
                        //                        sendItem.image = UIImage(named: "send.png")
                        //                    }
                    }
                }
            }else{
                if let info = contractPdfInfo {
                    if info.status == CConstants.EmailSignedStatus {
                        if info.ipadsignyn != 1 {
                            if info.client2 == "" {
                                if info.verify_code != "" && info.buyer1SignFinishedyn != 1 {
                                    seller2Item.title = "Waiting for Email Sign"
                                    sendItem.image = UIImage(named: "send.png")
                                }else{
                                    seller2Item.title = nil
                                    sendItem.image = UIImage(named: "send.png")
                                }
                            }else{
                                if info.verify_code != "" && info.buyer1SignFinishedyn != 1 || info.verify_code2 != "" && info.buyer2SignFinishedyn != 1{
                                    seller2Item.title = "Waiting for Email Sign"
                                    sendItem.image = UIImage(named: "send.png")
                                }else{
                                    seller2Item.title = nil
                                    sendItem.image = UIImage(named: "send.png")
                                }
                            }
                        }else{
                            seller2Item.title = nil
                            sendItem.image = UIImage(named: "send.png")
                        }
                    }else{
                        seller2Item.title = nil
                        sendItem.image = UIImage(named: "send.png")
                    }
                    
                    
                }
                
            }
        }else{
            seller2Item.title = nil
            sendItem.image = nil
        }
        
        
//        setBuyer2()
        
    }
    
    
    private func showSkipToNext(){
        if let list = self.navigationItem.leftBarButtonItems {
            if list.count >= 3 {
                let b1 = list[1]
                let b2 = list[2]
                
                let tp = toolpdf()
                if let _ = contractPdfInfo {
                    if  contractPdfInfo?.status == CConstants.ApprovedStatus && contractPdfInfo?.signfinishdate ?? "" == "01/01/1980" {
                        //                let (n3, _) = tp.CheckSellerFinish(self.fileDotsDic, documents: self.documents)
                        //                tvc.showSellerGoToSign = !n3
                        b2.title = ""
                        b1.title = "Next"
//                        print(contractPdfInfo?.approvedate?.hasSuffix("1980"))
                        if let a = contractPdfInfo?.approvedate {
                            if a.hasSuffix("1980") || a == "" {
                                b2.title = ""
                                b1.title = ""
                            }
                        }
                    }else if  contractPdfInfo?.status == CConstants.ForApproveStatus || contractPdfInfo?.status == CConstants.DisApprovedStatus{
                        b2.title = ""
                        b1.title = ""
                    
                    }else{
                        //                b1.title = "Next B-1"
                        if self.contractPdfInfo?.buyer1SignFinishedyn == 1 || self.contractPdfInfo?.verify_code != ""{
                            b1.title = ""
                            //                    tvc.showBuyer1GoToSign = false
                        }else{
                            let (n, _) = tp.CheckBuyerFinish(self.fileDotsDic, documents: self.documents, isbuyer1: true)
                            //                    tvc.showBuyer1GoToSign = !n
                            
                            b1.title = !n ? "Next B-1" : ""
                        }
                        
                        
                        
                        if self.contractPdfInfo?.client2 == "" || self.contractPdfInfo?.buyer2SignFinishedyn == 1 || self.contractPdfInfo?.verify_code2 != ""{
                            //                    tvc.showBuyer2GoToSign = false
                            b2.title = ""
                        }else{
                            let (n1, _) = tp.CheckBuyerFinish(self.fileDotsDic, documents: self.documents, isbuyer1: false)
                            //                    tvc.showBuyer2GoToSign = !n1
                            b2.title = !n1 ? "Next B-2" : ""
                        }
                        
                    }
                }else{
                    b1.title = ""
                    b2.title = ""
                }
                
            }

        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSendItema()
        
//        var showBuyer1 : Bool?
//        if self.contractPdfInfo?.buyer1SignFinishedyn == 1 || self.contractPdfInfo?.verify_code != ""{
//            showBuyer1 = false
//        }else{
//            let (n, _) = tp.CheckBuyerFinish(self.fileDotsDic, documents: self.documents, isbuyer1: true)
//            showBuyer1 = !n
//        }
        
        
        
        let userinfo = NSUserDefaults.standardUserDefaults()
        userinfo.setInteger(0, forKey: "ClearDraftInfo")
        if userinfo.boolForKey(CConstants.UserInfoIsContract) {
            self.navigationItem.title = "Contract"
            
            if filesArray != nil {
                switch filesArray![0]{
                case CConstants.ActionTitleAddendumC:
                    self.pageChanged( 6)
                case CConstants.ActionTitleEXHIBIT_B:
                    self.pageChanged( 3)
                case CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES,
                    CConstants.ActionTitleAddendumD,
                    CConstants.ActionTitleAddendumE,
                    CConstants.ActionTitleHoaChecklist:
                    self.pageChanged( 1)
                case CConstants.ActionTitleAddendumA:
                    self.pageChanged( 2)
                case CConstants.ActionTitleEXHIBIT_C:
                    self.pageChanged( 4)
                case CConstants.ActionTitleDesignCenter:
                    self.pageChanged( 5)
                default:
                    break
                }
            }
        }else{
            self.navigationItem.title = "Draft"
//            buyer1Date.title = ""
//            buyer2Date.title = ""
//            buyer1Item.title = ""
//            buyer2Item.title = ""
//            seller1Item.title = ""
//            seller2Item.title = ""
        }
        
        
        if filesArray?.count == 1 {
            self.title = filesArray![0]
        }
        
       
    }
    
   
    // MARK: Request Data
    private func callService(printModelNm: String, param: [String: String]){
//        print(param)
        var serviceUrl: String?
        switch printModelNm{
        case CConstants.ActionTitleDesignCenter:
            serviceUrl = CConstants.DesignCenterServiceURL
        case CConstants.ActionTitleAddendumC:
            return
//            serviceUrl = CConstants.AddendumCServiceURL
        case CConstants.ActionTitleClosingMemo:
            serviceUrl = CConstants.ClosingMemoServiceURL
//        case CConstants.ActionTitleAddendumHOA:
//            return
        case CConstants.ActionTitleContract,
        CConstants.ActionTitleDraftContract:
            serviceUrl = CConstants.ContractServiceURL
      
        default:
            serviceUrl = CConstants.AddendumAServiceURL
        }
//        print(param)
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //                hud.mode = .AnnularDeterminate
        hud.labelText = CConstants.RequestMsg
//        print(param, serviceUrl)
        Alamofire.request(.POST,
            CConstants.ServerURL + serviceUrl!,
            parameters: param).responseJSON{ (response) -> Void in
                hud.hide(true)
//                print(param, serviceUrl)
                if response.result.isSuccess {
                    
                    if let rtnValue = response.result.value as? [String: AnyObject]{
                       
                        if let msg = rtnValue["message"] as? String{
                            if msg.isEmpty{
//                                var vc : PDFBaseViewController?
                                switch printModelNm {
                                
                                case CConstants.ActionTitleClosingMemo:
                                    self.closingMemoPdfInfo = ContractClosingMemo(dicInfo: rtnValue)
                                case CConstants.ActionTitleDesignCenter:
                                    self.designCenterPdfInfo = ContractDesignCenter(dicInfo: rtnValue)
                                case CConstants.ActionTitleContract,
                                CConstants.ActionTitleDraftContract:
                                    self.contractPdfInfo = ContractSignature(dicInfo: rtnValue)
                                
                                default:
//                                    print(rtnValue)
                                    self.addendumApdfInfo = AddendumA(dicInfo: rtnValue)
                                }
                                
                            }else{
                                self.PopMsgWithJustOK(msg: msg)
                            }
                        }else{
                            self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                        }
                    }else{
                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                    }
                }else{
                    //                            self.spinner?.stopAnimating()
                    self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                }
        }
        
    }
    
    @IBOutlet var sendItem: UIBarButtonItem!
    private func readContractFieldsFromTxt(fileName: String) ->[String: String]? {
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt") {
            var fieldsDic = [String : String]()
            do {
                let fieldsStr = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                let n = fieldsStr.componentsSeparatedByString("\n")
                
                for one in n{
                    let s = one.componentsSeparatedByString(":")
                    if s.count != 2 {
//                        print(one)
                    }else{
                        fieldsDic[s.first!] = s.last!
                    }
                }
            }
            catch {/* error handling here */}
            return fieldsDic
        }
        
        return nil
    }
    
    var senderItem : UIBarButtonItem?
    
    @IBAction func BuyerSign(sender: UIBarButtonItem) {
        return
        if sender.title == "" {
            return;
        }
        self.dismissViewControllerAnimated(true){}
//        print(self.pdfView?.pdfView.scrollView.contentSize.height)
        senderItem = sender
        
        getAllSignature()
        if selfSignatureViews != nil && selfSignatureViews?.count > 0 {
        
            let currentPoint = self.pdfView?.pdfView.scrollView.contentOffset
            for sign in selfSignatureViews! {
                if sender.tag == 3 || sender.tag == 4 {
                    
                    if currentPoint?.y < sign.frame.origin.y {
                        if sign.xname.containsString("bottom")
                            || sign.xname.containsString("eller")
                            || sign.xname.containsString("TitleSign")
                            || sign.xname.containsString("april2Sign"){
                            var frame = sign.frame
                            frame.size.height += 150
                            self.pdfView?.pdfView.scrollView.scrollRectToVisible(frame, animated: false)
                            break;
                        }
                        
                    }
                }else{
                    if currentPoint?.y < sign.frame.origin.y {
                        var frame = sign.frame
                        frame.size.height += 150
                        self.pdfView?.pdfView.scrollView.scrollRectToVisible(frame, animated: false)
                        break;
//                    }else if {
                    
                    }
                }
                
                
            }
            
            self.performSelector(#selector(PDFPrintViewController.afterGotofield), withObject: sender, afterDelay: 0.3)
        }
        
    }
    
    func afterGotofield(){
        if let sender = senderItem {
            if addendumCpdfInfo != nil {
                for doc in documents! {
                    if doc.pdfName == CConstants.ActionTitleAddendumC {
                        for a in doc.addedviewss {
                            if let sign = a as? SignatureView {
                                //                            print(sign.xname)
                                if !CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
                                    continue
                                }
                                
                                if sender.tag == 1 && sign.xname == "april0Sign"
                                    || sender.tag == 5 && sign.xname == "april1Sign"
                                    || sender.tag == 3 && sign.xname==("april2Sign")
                                    || sender.tag == 2 && sign.xname == "april3DateSign"
                                    || sender.tag == 6 && sign.xname == "april4DateSign"
                                    || sender.tag == 4 && sign.xname==("april5DateSign"){
                                        sign.toSignautre()
                                        return
                                }
                            }
                        }
                        break
                    }
                }
            }
            
            if fileDotsDic != nil {
                for (_, v) in fileDotsDic! {
                    for a in v {
                        if let sign = a as? SignatureView {
                            
                            //                        print(b.tag, b.superview)
                            if !CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
                                continue
                            }
                            
                            if sender.tag==3 && sign.xname == "seller2Sign"
                                || sender.tag==4 && sign.xname == "seller3Sign" {
                                    sign.toSignautre()
                                    return
                            }
                            //                          print(sign.xname)
                            if sender.tag == 1 && sign.xname.hasSuffix("bottom1")
                                || sender.tag == 2 && sign.xname.hasSuffix("bottom2")
                                || sender.tag == 3 && sign.xname.hasSuffix("bottom3")
                                || sender.tag == 4 && sign.xname.hasSuffix("bottom4"){
                                    //buyer1
                                    sign.toSignautre()
                                    return
                            }
                            if sender.tag == 1 && sign.xname == ("buyer2Sign")
                                || sender.tag == 2  && sender.title != "Date1" && sign.xname == ("buyer3Sign")
                                || sender.tag == 2  && sender.title == "Date1" && sign.xname.hasSuffix("buyer2DateSign")
                                || sender.tag == 4 && sign.xname == ("Exhibitbp1seller3Sign"){
                                    sign.toSignautre()
                                    return
                            }
                            
                            if self.title == CConstants.ActionTitleAddendumHOA {
                                continue
                            }
                            
                            //broker
                            if addendumApdfInfo != nil{
                                if let hasrealtor = addendumApdfInfo!.hasbroker {
                                    if hasrealtor == "" {
//                                        print(sender.title)
                                        if sender.tag == 1 && sign.xname.hasSuffix("buyer2Sign")
                                            || sender.tag == 2 && sign.xname.hasSuffix("buyer2DateSign")
                                            
                                            || sender.tag == 3 && sign.xname.hasSuffix("buyer3Sign") && !sender.title!.hasPrefix("Seller")
                                            || sender.tag == 4 && sign.xname.hasSuffix("buyer3DateSign"){
                                                sign.toSignautre()
                                                return
                                        }
                                    }else{
                                        if sender.tag == 1 && sign.xname.hasSuffix("buyer2Sign")
                                            || sender.tag == 2 && sign.xname.hasSuffix("buyer2DateSign")
                                            || sender.tag == 3 && sign.xname.hasSuffix("buyer3Sign")
                                            || sender.tag == 4 && sign.xname.hasSuffix("buyer3DateSign"){
                                                sign.toSignautre()
                                                return
                                        }
                                    }
                                }
                                //exhibit c
                                if sender.tag == 1 && sign.xname == "BYSign"
                                    || sender.tag == 2 && sign.xname == "NameSign"
                                    || sender.tag == 4 && sign.xname==("TitleSign"){
                                        sign.toSignautre()
                                        return
                                }
                                
                                //Addendum A
                                if sender.tag == 4 && sign.xname==("AddendumASeller3Sign"){
                                    sign.toSignautre()
                                    return
                                }
                            }
                            
                            
                            
                            
                            if designCenterPdfInfo != nil{
                                
                                if sender.tag == 1 && sign.xname == "homeBuyer1Sign"
                                    || sender.tag == 2 && sign.xname == "homeBuyer1DateSign"
                                    || sender.tag == 3 && sign.xname == "homeBuyer2Sign"
                                    || sender.tag == 4 && sign.xname == "homeBuyer2DateSign"
                                {
                                    sign.toSignautre()
                                    return
                                }
                                
                                
                            }
                            
                        }
                        
                    }
                }
            }
        }
        
    }
    

    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y / scrollView.bounds.size.height)
    }
    
    
    @IBAction func  SellerSign(sender: UIBarButtonItem) {
//        BuyerSign(sender)
        if sender.title != "" && (sender.title ?? "").hasPrefix("Re") {
            self.saveToServer1(2)
        }
        
    }
//    
//    @IBOutlet var buyer1Date: UIBarButtonItem!
//    @IBOutlet var buyer2Date: UIBarButtonItem!
//    @IBOutlet var buyer1Item: UIBarButtonItem!
//    @IBOutlet var buyer2Item: UIBarButtonItem!
    @IBOutlet var seller2Item: UIBarButtonItem!
//    @IBOutlet var seller1Item: UIBarButtonItem!
    func pageChanged(no: Int) {
        return;
//        if no == 0 {
//            buyer1Date.title = ""
//            buyer2Date.title = ""
//            buyer1Item.title = "Buyer1"
//            buyer2Item.title = "Buyer2"
////            seller1Item.title = "Seller1"
//            seller2Item.title = "Seller2"
//        } else if no == 1 {
//            // broker
//            buyer1Date.title = ""
//            buyer2Date.title = ""
//            buyer1Item.title = "Buyer1"
//            buyer2Item.title = "Date1"
////            seller1Item.title = "Buyer2"
//            seller2Item.title = "Date2"
//        } else if no == 2 {
//            // addendum a
//            buyer1Date.title = ""
//            buyer2Date.title = ""
//            buyer1Item.title = "Buyer1"
//            buyer2Item.title = "Buyer2"
////            seller1Item.title = "Seller"
//            seller2Item.title = "Day"
//        } else if no == 3 {
//            // exhibit b
//            buyer1Date.title = ""
//            buyer2Date.title = ""
//            buyer1Item.title = "Buyer1"
//            buyer2Item.title = "Buyer2"
////            seller1Item.title = ""
//            seller2Item.title = "Initial"
//        } else if no == 4 {
//            // exhibit c
//            buyer1Date.title = ""
//            buyer2Date.title = ""
//            buyer1Item.title = "BY"
//            buyer2Item.title = "Name"
////            seller1Item.title = ""
//            seller2Item.title = "Title"
//        } else if no == 5 {
//            // Design center
//            buyer1Date.title = ""
//            buyer2Date.title = ""
//            buyer1Item.title = "Buyer1"
//            buyer2Item.title = "Date1"
////            seller1Item.title = "Buyer2"
//            seller2Item.title = "Date2"
//        } else if no == 6 {
//            // Addendum c
//            buyer1Item.title = "Buyer1"
//            buyer2Item.title = "Date1"
//            buyer1Date.title = "Buyer2"
//            buyer2Date.title = "Date2"
////            seller1Item.title = "Seller"
//            seller2Item.title = "Date"
//        }  
        
    }
    func setBuyer21() {
        
//        let a = [buyer1Item, buyer2Item,buyer1Date,buyer2Date]
//        for item in a {
//            if item.title == "Buyer2" || item.title == "Date2" {
//                item.title = ""
//            }
//        }
    }
    func setBuyer2(){
        
//        buyer1Date.title = ""
//        buyer2Date.title = ""
//        buyer1Item.title = ""
//        buyer2Item.title = ""
//        seller1Item.title = ""
//        seller2Item.title = ""
        var showBuyer2 = false;
        var showBuyer1 = true
        if let contract = self.contractPdfInfo {
            if contract.client2! != "" {
                showBuyer2 = true;
            }
            if contract.verify_code2 != "" {
                showBuyer2 = false
            }
            
            if contract.verify_code != "" {
                showBuyer1 = false
            }
            if contract.buyer1SignFinishedyn == 1 {
            showBuyer1 = false
            }
            
            if contract.buyer2SignFinishedyn == 1 {
                showBuyer2 = false
            }
        }
        
        
        
        
        var alldots = [PDFWidgetAnnotationView]()
        if let fileDotsDic1 = fileDotsDic{
            for (_,allAdditionViews) in fileDotsDic1 {
                alldots.appendContentsOf(allAdditionViews)
            }
        }
        
       
        
        for doc in documents!{
            if let a = doc.addedviewss as? [PDFWidgetAnnotationView]{
                alldots.appendContentsOf(a)
            }
        }
        
        let tlpdf = toolpdf()
//        if let fileDotsDic1 = fileDotsDic{
//            for (_,allAdditionViews) in fileDotsDic1 {
                for sign in alldots {
                    if sign.isKindOfClass(SignatureView) {
//                        print(sign.xname!)
                        if let si = sign as? SignatureView {
//                            if si.xname.hasSuffix("bottom3"){
//                                print("\"\(si.xname)\",")
//                            }
                            
                            if contractInfo?.status != CConstants.ApprovedStatus {
                                if si.xname != "p1EBExhibitbp1sellerInitialSign" {
                                    if si.xname.containsString("seller")
                                        || si.xname.containsString("bottom3"){
                                        continue
                                    }
                                }else{
                                    if !showBuyer1{
                                        if si.menubtn != nil {
                                            si.menubtn.removeFromSuperview()
                                            si.menubtn = nil
                                        }
                                        
                                    }
//                                    continue
                                }
                                
                            }else{
                                if si.xname == "p1EBExhibitbp1sellerInitialSign"{
                                    
                                        continue
                                    
                                }else if (si.xname.containsString("buyer")
                                    || si.xname.containsString("bottom1")
                                    || si.xname.containsString("bottom2")
                                    || si.xname.hasSuffix("Sign3")){
                                    continue
                                }
                            }
//                            
                            // remove seller2's signature
                            if si.xname.hasSuffix("bottom4")
                                || si.xname.hasSuffix("seller2Sign")
                                || si.xname.hasSuffix("seller2DateSign")
                            {
                                if si.menubtn != nil {
                                    si.menubtn.removeFromSuperview()
                                    si.menubtn = nil
                                }
                                continue
                            }
                            
                            if !showBuyer2{
                                if si.xname.hasSuffix("bottom2")
                                    || si.xname.hasSuffix("buyer2Sign")
                                || si.xname.hasSuffix("buyer2DateSign")
                                    
                                {
                                    if si.menubtn != nil {
                                        si.menubtn.removeFromSuperview()
                                        si.menubtn = nil
                                    }
                                    continue
                                }
                            }
                            
                            if !showBuyer1 {
                                if (tlpdf.isBuyer1Sign(si)){
                                    if si.menubtn != nil {
                                        si.menubtn.removeFromSuperview()
                                        si.menubtn = nil
                                    }
                                    continue
                                }
                            }
                           
                            si.pdfViewsssss = pdfView!
                            if contractPdfInfo?.status ?? "" == CConstants.DraftStatus
                                || contractPdfInfo?.status ?? "" == "Email Sign"
                                || (contractPdfInfo?.status ?? "" == CConstants.ApprovedStatus
                                    && contractPdfInfo?.signfinishdate ?? "" == "01/01/1980"
                                && !(contractPdfInfo?.approvedate?.hasSuffix("1980") ?? true)) {
                                si.addSignautre(pdfView!.pdfView!.scrollView)
                            }
                            
                            
                        }
                    }
                }
//            }
//        }
        
//        getSignature()
    }
        
    var selfSignatureViews: [SignatureView]?
    func getAllSignature(){
        if selfSignatureViews == nil {
            selfSignatureViews = [SignatureView]()
        }else {
            return
        }
        if let dots = pdfView?.pdfWidgetAnnotationViews {
            for d in dots{
                if let sign = d as? SignatureView {
                    selfSignatureViews?.append(sign)
                }
            }
        }
        for doc in documents! {
            if let dd = doc.addedviewss {
                for d in dd{
                    if let sign = d as? SignatureView {
                        selfSignatureViews?.append(sign)
                    }
                }
            }
        }
        if selfSignatureViews?.count > 0 {
            selfSignatureViews?.sortInPlace(){
                if $1.frame.origin.y != $0.frame.origin.y {
                    return $1.frame.origin.y > $0.frame.origin.y
                }else{
                    return $1.frame.origin.x > $0.frame.origin.x
                }
            }
        }
        
        
        
        
        
    }
    
    
    override func startover() {
        let msg : String
        if self.contractPdfInfo?.status == CConstants.ApprovedStatus {
            msg = "Are you sure you want to Start Over?"
        }else{
            if self.contractPdfInfo?.buyer1SignFinishedyn == 1 {
                msg = "Buyer1's Sign have submitted, this operation will just clean buyer2's sign. Are you sure you want to Start Over?"
            }else if self.contractPdfInfo?.buyer2SignFinishedyn == 1 {
                msg = "Buyer2's Sign have submitted, this operation will just clean buyer1's sign. Are you sure you want to Start Over?"
            }else if self.contractPdfInfo?.verify_code2 != "" {
                msg = "This operation will just clean buyer1's sign. Are you sure you want to Start Over?"
            }else if self.contractPdfInfo?.verify_code != "" {
                msg = "This operation will just clean buyer2's sign. Are you sure you want to Start Over?"
            }else{
                msg = "Are you sure you want to Start Over?"
            }
        }
        
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: msg, preferredStyle: .Alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
            //Do some stufrf
            let tlpdf = toolpdf()
            
            for doc in self.documents! {
                if let dd = doc.addedviewss {
                    for d in dd{
                        if let sign = d as? SignatureView {
                            if self.contractPdfInfo?.status != CConstants.ApprovedStatus {
                                if self.contractPdfInfo?.buyer2SignFinishedyn == 1 || self.contractPdfInfo?.verify_code2 != ""{
                                    if !tlpdf.isBuyer2Sign(sign) {
                                        
//                                        print(sign.xname)
                                       self.clearSignature(sign)
                                    }
                                }else if self.contractPdfInfo?.buyer1SignFinishedyn == 1 || self.contractPdfInfo?.verify_code != "" {
                                    if !tlpdf.isBuyer1Sign(sign) {
                                        self.clearSignature(sign)
                                    }
                                }else{
                                    self.clearSignature(sign)
                                }
                            }else{
                                self.clearSignature(sign)
                            }
                            
                        }
                    }
                }
                
                
            }
            if let fDD = self.fileDotsDic {
                
                
                for (_, dots) in fDD {
                    
                    for si in dots {
                        if let sign = si as? SignatureView{
                            if self.contractPdfInfo?.status != CConstants.ApprovedStatus {
                                if self.contractPdfInfo?.buyer2SignFinishedyn == 1 || self.contractPdfInfo?.verify_code2 != ""{
                                    if !tlpdf.isBuyer2Sign(sign) {
                                        self.clearSignature(sign)
                                    }
                                }else if self.contractPdfInfo?.buyer1SignFinishedyn == 1 || self.contractPdfInfo?.verify_code != ""{
                                    if !tlpdf.isBuyer1Sign(sign) {
                                        self.clearSignature(sign)
                                    }
                                }else{
                                    self.clearSignature(sign)
                                }
                            }else{
                                self.clearSignature(sign)
                            }
                            
                        }
                    }
                }
            }
            if self.contractInfo!.status! == CConstants.ApprovedStatus {
                self.initial_s1 = nil
                self.initial_s1yn = nil
                self.signature_s1yn = nil
                self.signature_s1 = nil
            }else{
                if self.contractPdfInfo?.buyer2SignFinishedyn == 1 {
                    self.initial_b1 = nil
                    self.initial_s1 = nil
                    self.initial_b1yn = nil
                    self.initial_s1yn = nil
                    self.signature_b1yn = nil
                    self.signature_s1yn = nil
                    self.signature_b1 = nil
                    self.signature_s1 = nil
                    self.initial_index = nil
                }else if self.contractPdfInfo?.buyer1SignFinishedyn == 1 {
                    self.initial_b2 = nil
                    self.initial_b2yn = nil
                    self.signature_b1yn = nil
                    self.signature_b2yn = nil
                    self.initial_s1 = nil
                    self.initial_s1yn = nil
                    self.signature_s1yn = nil
                    self.signature_s1 = nil
                    self.signature_b2 = nil
                }else{
                    self.initial_b1 = nil
                    self.initial_b2 = nil
                    self.initial_s1 = nil
                    self.initial_b1yn = nil
                    self.initial_b2yn = nil
                    self.initial_s1yn = nil
                    self.signature_b1yn = nil
                    self.signature_b2yn = nil
                    self.signature_s1yn = nil
                    self.signature_b1 = nil
                    self.signature_b2 = nil
                    self.signature_s1 = nil
                    self.initial_index = nil
                }
                
                
            }
            
        }
        alert.addAction(oKAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
         alert.addAction(cancelAction)
        
        //Present the AlertController
        self.presentViewController(alert, animated: true, completion: nil)
        
        
       
    }
    
    private func clearSignature(sign : SignatureView){
        if self.contractInfo!.status! == CConstants.ApprovedStatus {
            if sign.xname.hasSuffix("bottom3") || sign.xname.hasSuffix("seller1Sign") {
                if (sign.lineArray != nil){
                    sign.lineArray = nil
                    sign.LineWidth = 0.0
                    sign.showornot = true
                    if sign.menubtn != nil {
                        sign.superview?.addSubview(sign.menubtn)
                    }else{
                        sign.addSignautre(self.pdfView!.pdfView!.scrollView)
                    }
                    
                }
            }
        }else{
//            if !(contractPdfInfo?.approvedate?.hasSuffix("1980") ?? true) {
                if (sign.lineArray != nil){
                    sign.lineArray = nil
                    sign.LineWidth = 0.0
                    sign.showornot = true
                    if sign.menubtn != nil {
                        sign.superview?.addSubview(sign.menubtn)
                    }else{
                        sign.addSignautre(self.pdfView!.pdfView!.scrollView)
                    }
                    
                }
//            }
            
        }
    }
    
   
    
    override func clearDraftInfo() {
        let userInfo = NSUserDefaults.standardUserDefaults()
        userInfo.setInteger(1, forKey: "ClearDraftInfo")
        if self.addendumApdfInfo != nil{
            let a = self.addendumApdfInfo?.Client
            self.addendumApdfInfo?.Client = ""
            self.addendumApdfInfo = self.addendumApdfInfo!
            self.addendumApdfInfo?.Client = a
        }
        
        if self.contractPdfInfo != nil {
            let bmobile = self.contractPdfInfo?.bmobile1!
            let bemail = self.contractPdfInfo?.bemail1
            let client = self.contractPdfInfo?.client
            let client2 = self.contractPdfInfo?.client2
            let tobuyer2 = self.contractPdfInfo?.tobuyer2
            
            self.contractPdfInfo?.bmobile1 = ""
            self.contractPdfInfo?.bemail1 = ""
            self.contractPdfInfo?.client2 = ""
            self.contractPdfInfo?.client = ""
            self.contractPdfInfo?.tobuyer2 = ""
            self.contractPdfInfo = self.contractPdfInfo!
            self.contractPdfInfo?.bmobile1 = bmobile
            self.contractPdfInfo?.bemail1 = bemail
            self.contractPdfInfo?.client2 = client2
            self.contractPdfInfo?.client = client
            self.contractPdfInfo?.tobuyer2 = tobuyer2
        }
        
    }
    
    override func fillDraftInfo() {
        let userInfo = NSUserDefaults.standardUserDefaults()
        userInfo.setInteger(0, forKey: "ClearDraftInfo")
        
        if self.addendumApdfInfo != nil{
            self.addendumApdfInfo = self.addendumApdfInfo!
        }
        
        if self.contractPdfInfo != nil {
            self.contractPdfInfo = self.contractPdfInfo!
        }
        
    }
    
    let hoapage1fields = ["p1Hhoa1Sign3",
                          "p1Hhoa2Sign3",
                          "p1Hhoa3Sign3",
                          "p1Hhoa3aSign3",
                          "p1Hhoa3bSign3",
                          "p1Hhoa4Sign3",
                          "p1Hhoa4aSign3",
                          "p1Hhoa4bSign3",
                          "p1Hhoa4cSign3",
                          "p1Hhoa4dSign3",
                          "p1Hhoa4eSign3",
                          "p1Hhoa5Sign3",
                          "p1Hhoa6Sign3",
                          "p1Hhoa6aSign3"]
    let hoapage2fields = ["p2Hhoa6bSign3",
                          "p2Hhoa6cSign3",
                          "p2Hhoa6dSign3",
                          "p2Hhoa6eSign3",
                          "p2Hhoa6fSign3",
                          "p2Hhoa6gSign3",
                          "p2Hhoa6hSign3",
                          "p2Hhoa6iSign3",
                          "p2Hhoa7Sign3",
                          "p2Hhoa8Sign3",
                          "p2Hhoa9Sign3",
                          "p2Hhoa10Sign3",
                          "p2Hhoa11Sign3"]
    let hoapage3fields = ["p3Hhoa12Sign3",
                          "p3Hhoa12aSign3",
                          "p3Hhoa12bSign3",
                          "p3Hhoa13Sign3",
                          "p3Hhoa14Sign3",
                          "p3Hhoa15Sign3",
                          "p3Hhoa16Sign3"]
    
    private func getPDFSignaturePrefix() -> [[String]]{
        let contractP = ["p1", "p2", "p3", "p4", "p5", "p6", "p7", "p8", "p9"]
        let thirdParty = ["p1T3", "p2T3"]
        let InforBroker = ["p1I", "p2I"]
        var addendumA : [String] = [String]()
        for i in 1...6 {
            addendumA.append("p\(i)A")
        }
        let EA = ["p1EA"]
        let EB = ["p1EB"]
        let EC = ["p1EC", "p2EC", "p3EC"]
        var BuyerE : [String] = [String]()
        for i in 1...5 {
            BuyerE.append("p\(i)B")
        }
        let AC = ["p1AC", "p2AC"]
        let AD = ["p1AD", "p2AD"]
        let AE = ["p1AE", "p2AE"]
        let Flood = ["p1F", "p2F"]
        let Warraty = ["p1W", "p2W"]
        let Desgin = ["p1D"]
        let HOAC = ["p1H", "p2H", "p3H"]
        let AH = ["p1AH", "p2AH"]
        
        var nameArray = [[String]]()
        nameArray.append(contractP)
        nameArray.append(thirdParty)
        nameArray.append(InforBroker)
        nameArray.append(addendumA)
        nameArray.append(EA)
        nameArray.append(EB)
        nameArray.append(EC)
        nameArray.append(BuyerE)
        nameArray.append(AC)
        nameArray.append(AD)
        nameArray.append(AE)
        nameArray.append(Flood)
        nameArray.append(Warraty)
        nameArray.append(Desgin)
        nameArray.append(HOAC)
        nameArray.append(AH)
        return nameArray
    }
    override func saveToServer() {
        saveToServer1(0)
    }
    func saveToServer1(xtype: Int8) {
        
        var b1i : [[String]]?
        var b2i : [[String]]?
        var b1s : [[String]]?
        var b2s : [[String]]?
        var s1i : [[String]]?
        var s1s : [[String]]?
//        var si : String?
//        var ss : String?
        
        
        var pdfname = [String]()
        pdfname.append(CConstants.ActionTitleDraftContract)
        pdfname.append(CConstants.ActionTitleThirdPartyFinancingAddendum)
        pdfname.append(CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES)
        pdfname.append(CConstants.ActionTitleAddendumA)
        pdfname.append(CConstants.ActionTitleEXHIBIT_A)
        pdfname.append(CConstants.ActionTitleEXHIBIT_B)
        pdfname.append(CConstants.ActionTitleEXHIBIT_C)
        pdfname.append(CConstants.ActionTitleBuyersExpect)
        pdfname.append(CConstants.ActionTitleAddendumC)
        pdfname.append(CConstants.ActionTitleAddendumD)
        pdfname.append(CConstants.ActionTitleAddendumE)
        pdfname.append(CConstants.ActionTitleFloodPlainAck)
        pdfname.append(CConstants.ActionTitleWarrantyAcknowledgement)
        pdfname.append(CConstants.ActionTitleDesignCenter)
        pdfname.append(CConstants.ActionTitleHoaChecklist)
        pdfname.append(CConstants.ActionTitleAddendumHOA)
        
        let cntArray = [9, 2, 2, 6, 1, 1, 3, 5, 2, 2, 2, 1, 2, 1, 3, 1]
        
        var b1iynArray : [[String]]
        var b2iynArray : [[String]]
        var b1isnArray : [[String]]
        var b2isnArray : [[String]]
        
        var s1iynArray : [[String]]
        var s1isnArray : [[String]]
        
        var exhibitB : [String]
        var hoapage1 : [String]
        var hoapage2 : [String]
        var hoapage3 : [String]
        
        
//        if self.initial_b1yn != nil{
//            b1iynArray = self.initial_b1yn!
//            b2iynArray = self.initial_b2yn!
//            b1isnArray = self.signature_b1yn!
//            b2isnArray = self.signature_b2yn!
//            
//            if let _ = self.initial_s1yn {
//                s1iynArray = self.initial_s1yn!
//                s1isnArray = self.signature_s1yn!
//            }else{
//                s1iynArray = [[String]]()
//                s1isnArray = [[String]]()
//                for i in 0...(cntArray.count-1){
//                    s1iynArray.append([String]())
//                    s1isnArray.append([String]())
//                    
//                    for _ in 0...cntArray[i]-1 {
//                        s1iynArray[i].append("0")
//                        s1isnArray[i].append("0")
//                    }
//                }
//            }
//            
//            exhibitB = self.initial_index![0]
//            hoapage1 = self.initial_index![1]
//            hoapage2 = self.initial_index![2]
//            hoapage3 = self.initial_index![3]
//            
//            
//        }else{
             b1iynArray = [[String]]()
             b2iynArray = [[String]]()
             b1isnArray = [[String]]()
             b2isnArray = [[String]]()
            
            s1iynArray = [[String]]()
            s1isnArray = [[String]]()
            
            for i in 0...(cntArray.count-1){
                b1iynArray.append([String]())
                b2iynArray.append([String]())
                b1isnArray.append([String]())
                b2isnArray.append([String]())
                s1iynArray.append([String]())
                s1isnArray.append([String]())
                for _ in 0...cntArray[i]-1 {
                    b1iynArray[i].append("0")
                    b2iynArray[i].append("0")
                    b1isnArray[i].append("0")
                    b2isnArray[i].append("0")
                    s1iynArray[i].append("0")
                    s1isnArray[i].append("0")
                }
            }
            
            exhibitB = ["0"]
            hoapage1 = [String]()
            for _ in 0...13{
                hoapage1.append("0")
            }
            hoapage2 = [String]()
            for _ in 0...12{
                hoapage2.append("0")
            }
            hoapage3 = [String]()
            for _ in 0...6{
                hoapage3.append("0")
            }
//        }
        
        
        
        
        
       
        
        let nameArray = getPDFSignaturePrefix()
        
        var alldots = [PDFWidgetAnnotationView]()
        if let a = self.pdfView?.pdfWidgetAnnotationViews as? [PDFWidgetAnnotationView]{
             alldots.appendContentsOf(a)
        }
       
        for doc in documents!{
            if let a = doc.addedviewss as? [PDFWidgetAnnotationView]{
                alldots.appendContentsOf(a)
            }
        }
        
        
        var brokerb1 = false
        var brokerb2 = false
        for d in alldots{
            if let sign = d as? SignatureView {
//                print("\"\(sign.xname!)\",")
                if contractInfo!.status! != CConstants.ApprovedStatus {
                    if sign.lineArray != nil && sign.xname.hasSuffix("bottom1") || sign.xname.hasSuffix("Sign3") || sign.xname == "p1EBExhibitbp1sellerInitialSign" {
                        if sign.lineArray != nil && sign.lineArray.count > 0 && sign.LineWidth > 0{
                            if b1i == nil {
                                b1i = sign.lineArray as? [[String]]
                            }
                            if sign.xname == "p1EBExhibitbp1sellerInitialSign"{
                                exhibitB[0] = "1"
                            }else if sign.xname.hasSuffix("Sign3") {
//                                print(sign.xname)
                                if sign.xname.hasPrefix("p1H") {
                                    for l in hoapage1fields {
                                        if l == sign.xname {
                                            hoapage1[hoapage1fields.indexOf(l) ?? 0] = "1"
                                        }
                                    }
                                }
                                if sign.xname.hasPrefix("p2H") {
                                    for l in hoapage2fields {
                                        if l == sign.xname {
                                            hoapage2[hoapage2fields.indexOf(l) ?? 0] = "1"
                                        }
                                    }
                                }
                                if sign.xname.hasPrefix("p3H") {
                                    for l in hoapage3fields {
                                        if l == sign.xname {
                                            hoapage3[hoapage3fields.indexOf(l) ?? 0] = "1"
                                        }
                                    }
                                }
                            }else{
                                var cont = sign.xname.hasSuffix("bottom1")
                                for j in 0...nameArray.count-1 {
                                    if cont {
                                        let names = nameArray[nameArray.count-1-j]
                                        for k in 0...names.count-1 {
                                            let name = names[k]
                                            if sign.xname.hasPrefix(name) {
                                                b1iynArray[nameArray.count-1-j][k] = "1"
                                                cont = false
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                        
                    }
                    if sign.xname.hasSuffix("bottom2") {
                        if sign.lineArray != nil && sign.lineArray.count > 0 && sign.LineWidth > 0{
                            if b2i == nil {
                                //                                b2i = "\(sign.lineArray)"
                                b2i = sign.lineArray as? [[String]]
                            }
                            var cont = true
                            for j in 0...nameArray.count-1 {
                                if cont {
                                    let names = nameArray[nameArray.count-1-j]
                                    for k in 0...names.count-1 {
                                        let name = names[k]
                                        if sign.xname.hasPrefix(name) {
                                            b2iynArray[nameArray.count-1-j][k] = "1"
                                            cont = false
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    if sign.xname.hasSuffix("buyer1Sign") {
                        
                        if sign.lineArray != nil && sign.lineArray.count > 0 && sign.LineWidth > 0 {
                            if b1s == nil {
                                b1s = sign.lineArray as? [[String]]
                            }
                            var cont = true
                            for j in 0...nameArray.count-1 {
                                if cont {
                                    let names = nameArray[nameArray.count-1-j]
                                    for k in 0...names.count-1 {
                                        let name = names[k]
                                        if sign.xname == "p2Ibroker2buyer1Sign" {
                                            brokerb1 = true
                                        } else if sign.xname.hasPrefix(name) {
                                            b1isnArray[nameArray.count-1-j][k] = "1"
                                            cont = false
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    if sign.xname.hasSuffix("buyer2Sign") {
                        if sign.lineArray != nil && sign.lineArray.count > 0 && sign.LineWidth > 0{
                            if b2s == nil {
                                //                                b2s = "\(sign.lineArray)"
                                b2s = sign.lineArray as? [[String]]
                            }
                            
                            var cont = true
                            for j in 0...nameArray.count-1 {
                                if cont {
                                    let names = nameArray[nameArray.count-1-j]
                                    for k in 0...names.count-1 {
                                        let name = names[k]
                                         if sign.xname == "p2Ibroker2buyer2Sign" {
                                            brokerb2 = true
                                        }else if sign.xname.hasPrefix(name) {
                                            b2isnArray[nameArray.count-1-j][k] = "1"
                                            cont = false
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                    }
                }else{
                    brokerb1 = true
                    if self.contractPdfInfo?.client2 != ""{
                    brokerb2 = true
                    }
                    if sign.xname.hasSuffix("seller1Sign") {
                        if sign.lineArray != nil && sign.lineArray.count > 0 && sign.LineWidth > 0 {
                            if s1s == nil {
                                s1s = sign.lineArray as? [[String]]
                            }
                            var cont = true
                            for j in 0...nameArray.count-1 {
                                if cont {
                                    let names = nameArray[nameArray.count-1-j]
                                    for k in 0...names.count-1 {
                                        let name = names[k]
                                        if sign.xname.hasPrefix(name) {
                                            s1isnArray[nameArray.count-1-j][k] = "1"
                                            cont = false
                                        }
                                    }
                                }
                                
                            }
                        }
                    }else if sign.xname.hasSuffix("bottom3") {
                        if sign.lineArray != nil && sign.lineArray.count > 0 && sign.LineWidth > 0 {
                            if s1i == nil {
                                s1i = sign.lineArray as? [[String]]
                            }
                            var cont = true
                            for j in 0...nameArray.count-1 {
                                if cont {
                                    let names = nameArray[nameArray.count-1-j]
                                    for k in 0...names.count-1 {
                                        let name = names[k]
                                        if sign.xname.hasPrefix(name) {
                                            s1iynArray[nameArray.count-1-j][k] = "1"
                                            cont = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
//        return
        
        var param = [String: String]()
        param["idcontract1"] = contractInfo?.idnumber
        param["doc"] = "1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16"
        param["page"] = "9;2;2;6;1;1;3;5;2;2;2;1;2;1;3;1"
//        param["doc"] = "\([1 23;4;5;6;7;8;9;10;11;12;13;14;15;16])"
//        param["page"] = "\(cntArray)"
//        try{
//        let a = NSJSONSerialization.dataWithJSONObject("\(b1iynArray)", options: nil)
//        let c = String(data: a)
//            print(c)
//        }catch{}
//        return
        
//        print(getStr(b1iynArray))
//        return
//        brokerb1 = false
//        brokerb2 = false
        
        param["brokerInfoPage2"] = (brokerb1 ? "1" : "0") + "|" +  (brokerb2 ? "1" : "0")
        var initial_index : [[String]] =  [[String]]()
        initial_index.append(exhibitB)
        initial_index.append(hoapage1)
        initial_index.append(hoapage2)
        initial_index.append(hoapage3)
        
        if contractInfo!.status! == CConstants.ApprovedStatus {
            param["initial_index"] = " "
            //        print(getStr(initial_index))
            param["initial_b1yn"] = " "
            //        print(getStr(b1iynArray))
            
            param["initial_b2yn"] = " "
            param["signature_b1yn"] = " "
            param["signature_b2yn"] = " "
            param["initial_s1yn"] = getStr(s1iynArray)
            param["signature_s1yn"] = getStr(s1isnArray)
            param["initial_b1"] = " "
            //        print(getStr(b1i))
            param["initial_b2"] = " "
            param["signature_b1"] = " "
            param["signature_b2"] = " "
            param["initial_s1"] = getStr(s1i)
            param["signature_s1"] = getStr(s1s)
        }else{
            param["initial_index"] = getStr(initial_index)
            //        print(getStr(initial_index))
            param["initial_b1yn"] = getStr(b1iynArray)
            param["initial_b2yn"] = getStr(b2iynArray)
            param["signature_b1yn"] = getStr(b1isnArray)
            param["signature_b2yn"] = getStr(b2isnArray)
            
            param["initial_s1yn"] = "0|0|0|0|0|0|0|0|0;0|0;0|0;0|0|0|0|0|0;0;0;0|0|0;0|0|0|0|0;0|0;0|0;0|0;0;0|0;0;0|0|0;0"
            param["signature_s1yn"] = "0|0|0|0|0|0|0|0|0;0|0;0|0;0|0|0|0|0|0;0;0;0|0|0;0|0|0|0|0;0|0;0|0;0|0;0;0|0;0;0|0|0;0"
            param["initial_b1"] = getStr(b1i)
            param["initial_b2"] = getStr(b2i)
            param["signature_b1"] = getStr(b1s)
            param["signature_b2"] = getStr(b2s)
            param["initial_s1"] = " "
            param["signature_s1"] = " "
        }
         param["checked_photo"] = " "
        var reurl : String
        if self.contractPdfInfo?.verify_code != "" {
            param["whichBuyer"] = "2"
            reurl = "bacontract_save_signNew.json"
        }else if contractPdfInfo?.verify_code2 != "" {
            param["whichBuyer"] = "1"
            reurl = "bacontract_save_signNew.json"
        }else{
            reurl = "bacontract_save_sign.json"
        }
        
        print(reurl , param)
//        return;
        self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.hud?.labelText = CConstants.SavedMsg
        
//        print(param)
        
        
        Alamofire.request(.POST,
            CConstants.ServerURL + reurl,
            parameters: param).responseJSON{ (response) -> Void in
                //                self.hud?.hide(true)
//                print(response.result.value)
                if response.result.isSuccess {
                    if let rtnValue = response.result.value as? Bool{
//                        print(rtnValue)
                        if rtnValue {
                            if xtype == 1 {
                                self.submitStep0()
                                self.hud?.mode = .Text
                                self.hud?.labelText = "Submitting for approve..."
                                 return
                            }else if xtype == 2 || xtype == 3{
                                self.saveAndFinish2(xtype)
                            return
                            }else if xtype == 4 {
                                self.hud?.mode = .Text
                                self.hud?.labelText = "Submitting to Sever..."
                            // submit buyer1's sign finishe.
                                self.submitBuyerSignStep2(true)
                            }else if xtype == 5 {
                                self.hud?.mode = .Text
                                self.hud?.labelText = "Submitting to Sever..."
                                // submit buyer2's sign finishe.
                                self.submitBuyerSignStep2(false)
                            }else{
                                self.hud?.mode = .CustomView
                                let image = UIImage(named: CConstants.SuccessImageNm)
                                self.hud?.customView = UIImageView(image: image)
                                
                                self.hud?.labelText = CConstants.SavedSuccessMsg
                            }
                            
                        }else{
                            self.hud?.mode = .Text
                            self.hud?.labelText = CConstants.SavedFailMsg
                        }
                    }else{
                        self.hud?.mode = .Text
                        self.hud?.labelText = CConstants.MsgServerError
                    }
                }else{
                    self.hud?.mode = .Text
                    self.hud?.labelText = CConstants.MsgNetworkError
                }
                self.performSelector(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), withObject: nil, afterDelay: 0.5)
                
    }
    
}
    
    private func isCanSignature(nameArray: [[String]], sign: SignatureView
        , ynarr: [[String]]?, inarr: String?) {
        for j in 0...nameArray.count-1 {
            let ji = nameArray.count-1-j
            let na = nameArray[ji]
            for k in 0...na.count-1 {
                let t = na[k]
                if sign.xname.hasPrefix(t) {
                    self.setShowSignature(sign, signs: inarr!, idcator: ynarr![ji][k])
                    
                    return
                }
            }
        }
    }

private func getStr(h : [[String]]?) -> String {
    if let a = h {
        var s : [String] = [String]()
        for n in a {
            s.append(n.joinWithSeparator("|"))
        }
        return s.joinWithSeparator(";")
    }else{
        return " "
    }
}
    
    private func getArr(str: String) -> [[String]] {
        
        return (str.stringByReplacingOccurrencesOfString(" ", withString: "")).componentsSeparatedByString(";").map(){$0.componentsSeparatedByString("|")}
    }

    var initial_b1yn : [[String]]?
    var initial_b2yn : [[String]]?
    var signature_b1yn : [[String]]?
    var signature_b2yn : [[String]]?
    
    var initial_s1yn : [[String]]?
    var signature_s1yn : [[String]]?
    
    var initial_index : [[String]]?
    
    var initial_b1 : String?
    var initial_b2 : String?
    var signature_b1 : String?
    var signature_b2 : String?
    
    var initial_s1 : String?
    var signature_s1 : String?
    
    
    func getSignature(){
//        print(["idcontract1" : self.contractInfo!.idnumber!])
        Alamofire.request(.POST,
            CConstants.ServerURL + "bacontract_GetSignedContract.json",
            parameters: ["idcontract1" : self.contractInfo!.idnumber!]).responseJSON{ (response) -> Void in
//                hud.hide(true)
                if response.result.isSuccess {
//                    print(response.result.value)
                    if let rtnValue = response.result.value as? [String: AnyObject]{
//                       print(rtnValue)
                        let rtn = SignatrureFields(dicInfo: rtnValue)
                        if rtn.initial_b1yn! != "" {
//                             print(rtn.initial_b1yn)
                            var brokerb1 = false
                            var brokerb2 = false
                            if rtn.brokerInfoPage2 != "" {
                                if rtn.brokerInfoPage2!.containsString("|") {
                                    let cc = rtn.brokerInfoPage2!.componentsSeparatedByString("|")
                                    brokerb1 = (cc[0] == "1")
                                    brokerb2 = (cc[1] == "1")
                                }else{
                                    brokerb1 = (rtn.brokerInfoPage2! == "1")
                                }
                            }
                            self.initial_b1yn = self.getArr(rtn.initial_b1yn!)
                            self.initial_b2yn = self.getArr(rtn.initial_b2yn!)
                            self.initial_s1yn = self.getArr(rtn.initial_s1yn!)
                            self.signature_b1yn = self.getArr(rtn.signature_b1yn!)
                            self.signature_b2yn = self.getArr(rtn.signature_b2yn!)
                            self.signature_s1yn = self.getArr(rtn.signature_s1yn!)
                            
                            self.initial_b1 = rtn.initial_b1
                            self.initial_b2 = rtn.initial_b2
                            self.signature_b1 = rtn.signature_b1
                            self.signature_b2 = rtn.signature_b2
                            self.initial_s1 = rtn.initial_s1
                            self.signature_s1 = rtn.signature_s1
                            
                            if rtn.initial_index == "" {
                                let exhibitB = ["0"]
                                var hoapage1 = [String]()
                                var hoapage2 = [String]()
                                var hoapage3 = [String]()
                                for _ in 0...13{
                                    hoapage1.append("0")
                                }
                                for _ in 0...12{
                                    hoapage2.append("0")
                                }
                                for _ in 0...6{
                                    hoapage3.append("0")
                                }
                                self.initial_index = [[String]]()
                                self.initial_index?.append(exhibitB)
                                self.initial_index?.append(hoapage1)
                                self.initial_index?.append(hoapage2)
                                self.initial_index?.append(hoapage3)
                            }else{
                                self.initial_index = self.getArr(rtn.initial_index!)
                            }
                            
                            
                            
                            
                            let nameArray = self.getPDFSignaturePrefix()
                            
                            var alldots = [PDFWidgetAnnotationView]()
//                            if let a = self.pdfView?.pdfWidgetAnnotationViews as? [PDFWidgetAnnotationView]{
//                                alldots.appendContentsOf(a)
//                            }
                            
                            for (_,allAdditionViews) in self.fileDotsDic!{
                                alldots.appendContentsOf(allAdditionViews)
                            }
                            
                            for doc in self.documents!{
                                if let a = doc.addedviewss as? [PDFWidgetAnnotationView]{
                                    alldots.appendContentsOf(a)
                                }
                            }
                            
//                            for h in alldots{
//                            print(h.xname)
//                            }
                            
                            var showseller = true
//                            if let ds = self.contractInfo?.signfinishdate, ss = self.contractInfo?.status {
//                                showseller =  ds != "01/01/1980" && ss == CConstants.ApprovedStatus
//                            }
                            if let ss = self.contractInfo?.status {
//                                showseller =  (ds != "01/01/1980" && ss == CConstants.ApprovedStatus)
                                showseller =  ss == CConstants.ApprovedStatus
                            }
//                            let v = SignatureView()
//                            let initial_b1Line = v.getNewOriginLine(self.initial_b1.componentsSeparatedByString(";").map(){$0.componentsSeparatedByString("|")})
//                            var initial_b2Line : String?
//                            var signature_b1Line : String?
//                            var signature_b2Line : String?
//                            var initial_s1Line : String?
//                            var signature_s1Line : String?
                            
                            for d in alldots{
                                if let sign = d as? SignatureView {
//                                    if  sign.xname.hasSuffix("bottom4")
//                                        || sign.xname.hasSuffix("seller2Sign")
//                                        {
//                                        print("\"" + sign.xname + "\"" + ",")
//                                    }
                                    
                                    
                                    if sign.xname == "p2Ibroker2buyer1Sign" {
                                    
                                        self.setShowSignature(sign, signs: self.signature_b1!, idcator: brokerb1 ? "1" : "0")
                                    
                                        continue
                                    }else if sign.xname == "p2Ibroker2buyer2Sign" {
                                        self.setShowSignature(sign, signs: self.signature_b2!, idcator: (brokerb2 ? "1" : "0"))
                                        
                                        
                                        continue
                                    }
                                    
                                    if sign.xname.hasSuffix("bottom1") {
                                        if sign.xname == "p3Hbottom1" {
                                         self.isCanSignature(nameArray, sign: sign, ynarr: self.initial_b1yn, inarr: self.initial_b1)
                                        }else{
                                            self.isCanSignature(nameArray, sign: sign, ynarr: self.initial_b1yn, inarr: self.initial_b1)
                                        }
                                    }else if sign.xname.hasSuffix("bottom2") {
//                                        print(sign.xname)
                                        if self.contractInfo!.client2! != "" {
                                            self.isCanSignature(nameArray, sign: sign, ynarr: self.initial_b2yn, inarr: self.initial_b2)
                                        }
                                    }else if sign.xname.hasSuffix("bottom3") && showseller {
                                        self.isCanSignature(nameArray, sign: sign, ynarr: self.initial_s1yn, inarr: self.initial_s1)
                                        
                                    }else if sign.xname.hasSuffix("buyer1Sign") {
                                        self.isCanSignature(nameArray, sign: sign, ynarr: self.signature_b1yn, inarr: self.signature_b1)
                                    }else if sign.xname.hasSuffix("seller1Sign") && showseller {
                                        self.isCanSignature(nameArray, sign: sign, ynarr: self.signature_s1yn, inarr: self.signature_s1)
                                     }else if sign.xname.hasSuffix("buyer2Sign") {
                                        if self.contractInfo!.client2! != "" {
                                            self.isCanSignature(nameArray, sign: sign, ynarr: self.signature_b2yn, inarr: self.signature_b2)
                                        }
                                        
                                    }else if sign.xname == "p1EBExhibitbp1sellerInitialSign" {
                                        self.setShowSignature(sign, signs: self.initial_b1!, idcator: self.initial_index![0][0])
                                    }else if sign.xname.hasSuffix("Sign3") {
                                        if sign.xname.hasPrefix("p1H") {
                                            var ab = false
                                            for l in self.hoapage1fields {
                                                if l == sign.xname {
                                                    ab = true
                                                    if self.initial_b1! != "" {
                                                        self.setShowSignature(sign, signs: self.initial_b1!, idcator: self.initial_index![1][self.hoapage1fields.indexOf(l)!])
                                                    }
                                                    
                                                    break;
                                                }
                                                
                                            }
                                            if !ab {
                                                self.setShowSignature(sign, signs: self.initial_b1!, idcator: "0")
                                            }
                                        }else if sign.xname.hasPrefix("p2H") {
                                            var ab = false
                                            for l in self.hoapage2fields {
                                                if l == sign.xname {
                                                    ab = true
                                                    self.setShowSignature(sign, signs: self.initial_b1!, idcator: self.initial_index![2][self.hoapage2fields.indexOf(l)!])
                                                    break;
                                                }
                                            }
                                            if !ab {
                                                self.setShowSignature(sign, signs: self.initial_b1!, idcator: "0")
                                            }
                                        }else if sign.xname.hasPrefix("p3H") {
                                            var ab = false
                                            for l in self.hoapage3fields {
                                                if l == sign.xname {
                                                    ab = true
                                                    
                                                    self.setShowSignature(sign, signs: self.initial_b1!, idcator: self.initial_index![3][self.hoapage3fields.indexOf(l)!])
                                                    break;
                                                }
                                            }
                                            if !ab {
                                                self.setShowSignature(sign, signs: self.initial_b1!, idcator: "0")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
//                        }
                    }else{
                       self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                    }
                }else{
                    self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                }
        }
        
    }
    
    private func setShowSignature(si: SignatureView, signs signsx: String, idcator : String) {
       
//        if si.xname == "p1EBbottom2" {
//        print(signsx)
//        }
        let signs = signsx
        if signs == "" {
            return
        }
        let signa = signs.componentsSeparatedByString(";").map(){$0.componentsSeparatedByString("|")}
//        print(signa)
        si.frame = si.frame
//         print(si.frame)
        let ct = si.frame
        var ct2 = ct
        ct2.origin.x = 0.0
        ct2.origin.y = 0.0
        si.frame = ct2
        si.frame = ct
        
//        if si.xname == "p1EBbottom2" {
//            print(si.frame )
//        }
        
//        print(si.frame)
//        
//        if si.xname == "p1EBExhibitbp1sellerInitialSign" {
//            print(si.xname)
//        }
        si.lineArray = si.getNewOriginLine(signa as! NSMutableArray)
        si.lineArray = si.getNewOriginLine(si.lineArray as NSMutableArray)
//        if si.xname == "p1EBbottom2" {
//            print(si.lineArray)
//        }
        let ct3 = si.getOriginFrame()
//        ct3 = si.getOriginFrame()
        
        si.originWidth = Float(ct3.width)
        si.originHeight = Float(ct3.height)
        
        if idcator == "1" {
            si.LineWidth = 5.0
        }else{
            si.LineWidth = 0.0
        }
        
       
        
    }
    
    
    override func submit() {
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: "Do you want to submit for approval?", preferredStyle: .Alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
            //save signature to sever
//            self.locked = true
            self.saveToServer1(1)
            
        }
        alert.addAction(oKAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        
        //Present the AlertController
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    var SubmitRtn : [String : AnyObject]?
    
    func submitStep0() {
        // do submit for approve
        let userInfo = NSUserDefaults.standardUserDefaults()
        
//        print(["idcontract1" : self.contractInfo!.idnumber!, "idcia": self.contractInfo!.idcia!, "email": userInfo.stringForKey(CConstants.UserInfoEmail) ?? ""])
        Alamofire.request(.POST,
            CConstants.ServerURL + "bacontract_getSubmitForApproveEmail.json",
            parameters: ["idcontract1" : self.contractInfo!.idnumber!, "idcia": self.contractInfo!.idcia!, "email": userInfo.stringForKey(CConstants.UserInfoEmail) ?? ""]).responseJSON{ (response) -> Void in
                self.hud!.hide(true)
                if response.result.isSuccess {
                    if let rtnValue = response.result.value as? [String: AnyObject]{
//                        print(rtnValue)
                        if rtnValue["result"] as? String ?? "-1" == "-1" {
                            self.PopErrorMsgWithJustOK(msg: rtnValue["message"] as? String ?? "Server Error"){ action -> Void in
                                
                            }
                        }else{
                            self.SubmitRtn = rtnValue
                            if self.contractInfo!.flood! == 1 {
                                
                                let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: "This requires flood acknowledgement signed.", preferredStyle: .Alert)
                                
                                //Create and add the OK action
                                let oKAction: UIAlertAction = UIAlertAction(title: "Continue", style: .Default) { action -> Void in
                                    self.submitStep2()
                                }
                                alert.addAction(oKAction)
                                
                                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                                alert.addAction(cancelAction)
                                
                                //Present the AlertController
                                self.presentViewController(alert, animated: true, completion: nil)
                            }else{
                                self.submitStep2()
                            }
                        }
                        
                    }else{
                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                    }
                }else{
                    //                            self.spinner?.stopAnimating()
                    self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                }
        }
    }
    func submitStep2() {
        if self.contractInfo!.environment! == 1 {
            let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: "This requires environment acknowledgement signed.", preferredStyle: .Alert)
            
            //Create and add the OK action
            let oKAction: UIAlertAction = UIAlertAction(title: "Continue", style: .Default) { action -> Void in
                self.submitStep3()
                
                
                
            }
            alert.addAction(oKAction)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            
            //Present the AlertController
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }else{
            self.submitStep3()
        }
    }
    func submitStep3() {
        
        if let rtn = self.SubmitRtn {
            self.performSegueWithIdentifier("showSubmit", sender: rtn)
        }
//            "Please approve the following Contract."
            
        
        
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        switch identifier {
        case CConstants.SegueToOperationsPopover:
//            if let ds = self.contractInfo?.signfinishdate, ss = self.contractInfo?.status {
//                if  ds != "01/01/1980" && ss == CConstants.ApprovedStatus {
//                    return false
//                }
//            }
            if self.seller2Item.title == "Status: Email Sign" {
                return false
            }
            if self.contractPdfInfo?.status == CConstants.ApprovedStatus {
                if let fs = self.contractPdfInfo?.approvedate {
                    if fs == "" || fs.hasSuffix("1980"){
                        return false
                    }
                }else{
                    return false
                }
            }
            
            
            return contractInfo!.status != CConstants.ForApproveStatus
        default:
            return true
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if let identifier = segue.identifier {
            if identifier == constants.segueToSendEmailAfterApproved {
                if let con = segue.destinationViewController as? EmailAfterApprovedViewController {
                    con.contractInfo = self.contractInfo
                }
            }else if identifier == constants.segueToEmailContractToBuyer {
                if let con = segue.destinationViewController as? EmailContractToBuyerViewController {
                    con.contractInfo = self.contractPdfInfo
                    con.delegate = self
                }
            
            }else if identifier == "showSubmit" {
                if let controller = segue.destinationViewController as? SubmitForApproveViewController {
                    if let contrat = self.contractInfo, let rtn = sender as? [String: AnyObject] {
                        controller.delegate = self
                        controller.xtitle = "Contract - \(contrat.idnumber ?? "")"
                        controller.xtitle2 = "Project # \(contrat.idproject ?? "") ~ \(contrat.nproject ?? "" )"
                        controller.xemailList = rtn["list"] as? [String]
                        
                        controller.xdes = "Please approve the following Contract."
                    }
                }
            }else if identifier == "showSkipFile" {
                self.dismissViewControllerAnimated(true, completion: nil)
                if let controller = segue.destinationViewController as? GoToFileViewController {
                    controller.delegate = self
                    controller.printList = self.filesArray!
                }
            }else if identifier == "showAttachPhoto" {
                if let controller = segue.destinationViewController as? BigPictureViewController{
                    controller.imageUrl = NSURL(string: CConstants.ServerURL + "bacontract_photoCheck.json?ContractID=" + (self.contractInfo?.idnumber ?? ""))
                    controller.contractPdfInfo = self.contractPdfInfo
                    
//                    print(CConstants.ServerURL + "bacontract_photoCheck.json?ContractID=" + (self.contractInfo?.idnumber ?? ""))
                }
            
            }else if identifier == "showEmail" {
                if let controller = segue.destinationViewController as? SaveAndEmailViewController {
                    if let contrat = self.contractInfo {
                        controller.delegate = self
                        controller.xtitle = "Send Email"
                        controller.xtitle2 = "Project # \(contrat.idproject ?? "") ~ \(contrat.nproject ?? "" )"
                        var emailList : [String] = [String]()
                        if let email1 = contrat.buyer1email {
                            emailList.append(email1)
                        }
                        if let email1 = contrat.buyer2email {
                            emailList.append(email1)
                        }
                        emailList.append("phalycak@kirbytitle.com")
                        emailList.append("heatherb@kirbytitle.com")
                        
                        controller.xemailList = emailList
                        let userInfo = NSUserDefaults.standardUserDefaults()
                        let email = userInfo.valueForKey(CConstants.UserInfoEmail) as? String
                        
                        controller.xemailcc = email ?? ""
                        controller.xdes = "This is the contract of your new house."
                    }
                }
            }else{
                if let identifier = segue.identifier {
                    switch identifier {
                    case CConstants.SegueToOperationsPopover:
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        if let tvc = segue.destinationViewController as? SendOperationViewController {
                            if let ppc = tvc.popoverPresentationController {
                                var showSave = false
                                var showSubmit = true
                                var isapproved = false
                                var fromWeb = false
                                var justShowEmail = false
                                
                                if let c = contractPdfInfo?.status {
                                    if c == CConstants.ApprovedStatus {
                                        isapproved = true
                                        
                                        if let ds = self.contractInfo?.signfinishdate {
                                            if  ds != "01/01/1980"  {
                                                justShowEmail = true
                                            }
                                        }
                                        
                                    }else if c == CConstants.EmailSignedStatus{
                                        fromWeb = true
                                    }
                                }
                                tvc.contractInfo = self.contractPdfInfo
                                tvc.justShowEmail = justShowEmail
                                tvc.isapproved = isapproved
                                tvc.FromWebSide = fromWeb
                                tvc.hasCheckedPhoto = contractPdfInfo?.hasCheckedPhoto ?? "0"
//                                print(tvc.hasCheckedPhoto)
//                                let tp = toolpdf()
//                                if isapproved {
//                                    let (n3, _) = tp.CheckSellerFinish(self.fileDotsDic, documents: self.documents)
//                                    tvc.showSellerGoToSign = !n3
//                                }else{
//                                    if self.contractPdfInfo?.buyer1SignFinishedyn == 1 || self.contractPdfInfo?.verify_code != ""{
//                                        tvc.showBuyer1GoToSign = false
//                                    }else{
//                                        let (n, _) = tp.CheckBuyerFinish(self.fileDotsDic, documents: self.documents, isbuyer1: true)
//                                        tvc.showBuyer1GoToSign = !n
//                                    }
//                                    
//                                    
//                                    
//                                    if self.contractPdfInfo?.client2 == "" || self.contractPdfInfo?.buyer2SignFinishedyn == 1 || self.contractPdfInfo?.verify_code2 != ""{
//                                        tvc.showBuyer2GoToSign = false
//                                    }else{
//                                        let (n1, _) = tp.CheckBuyerFinish(self.fileDotsDic, documents: self.documents, isbuyer1: false)
//                                        tvc.showBuyer2GoToSign = !n1
//                                    }
//                                   
//                                }
                                
                                if let dots = pdfView?.pdfWidgetAnnotationViews {
                                    let ddd = dots
                                    for doc in documents! {
                                        if let dd = doc.addedviewss {
                                            ddd.addObjectsFromArray(dd)
                                        }
                                    }
                                    for v in ddd {
                                        if let sign = v as? SignatureView {
                                            if (isapproved && (sign.xname.hasSuffix("bottom3") || sign.xname.hasSuffix("seller1Sign"))) || (!isapproved && !(sign.xname.hasSuffix("bottom3") || sign.xname.hasSuffix("seller1Sign"))){
                                                if sign.lineArray?.count  > 0 {
                                                    //                                            if sign.xname == "p1EBbuyer1Sign" {
                                                    //
                                                    //                                            }
                                                    
                                                        showSave = true
//                                                    }
                                                    
                                                    if sign.LineWidth == 0.0 && sign.xname != "p1EBExhibitbp1sellerInitialSign"{
//                                                                                                        print(sign.xname, sign.LineWidth, sign.lineArray)
                                                        showSubmit = false
                                                    }
                                                }else{
                                                    if sign.menubtn != nil && sign.menubtn.superview != nil && sign.xname != "p1EBExhibitbp1sellerInitialSign"{
                                                        showSubmit = false
                                                    }
                                                    
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                                
                                tvc.showSave = showSave
                                tvc.showSubmit = showSubmit
//                                tvc.showSubmit = true
                                ppc.delegate = self
                                tvc.delegate1 = self
                            }
                            //                    tvc.text = "april"
                        }
                    case CConstants.SegueToPrintModelPopover:
                        self.dismissViewControllerAnimated(true, completion: nil)
                        if let tvc = segue.destinationViewController as? PrintModelTableViewController {
                            if let ppc = tvc.popoverPresentationController {
                                ppc.delegate = self
                                tvc.delegate = self
                            }
                            //                    tvc.text = "april"
                        }
                    case CConstants.SegueToAddressModelPopover:
                        self.dismissViewControllerAnimated(true, completion: nil)
                        if let tvc = segue.destinationViewController as? AddressListModelViewController {
                            if let ppc = tvc.popoverPresentationController {
                                ppc.delegate = self
//                                tvc.AddressListOrigin = self.AddressList
                                tvc.delegate = self
                            }
                            //                    tvc.text = "april"
                        }
                    default: break
                    }
                }
            }
        }
    }
    
    func GoToSubmit(email: String, emailcc: String, msg: String) {
        
        let userInfo = NSUserDefaults.standardUserDefaults()
//        self.hud?.show(true)
//        print(["idcontract1" : self.contractInfo!.idnumber!, "idcia": self.contractInfo!.idcia!, "email": userInfo.stringForKey(CConstants.UserInfoEmail) ?? "", "emailto" : email, "emailcc": emailcc, "msg": msg])
        
//
        
//        ["idcontract1" : self.contractInfo!.idnumber!, "idcia": self.contractInfo!.idcia!, "email": userInfo.stringForKey(CConstants.UserInfoEmail) ?? "", "emailto" : email, "emailcc": emailcc, "msg": msg]
//        if hud == nil {
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        }
        hud?.labelText = "Submitting..."
//        
        
       let a =  ["idcontract1" : self.contractInfo!.idnumber!, "idcia": self.contractInfo!.idcia!, "email": userInfo.stringForKey(CConstants.UserInfoEmail) ?? "", "emailto" : email, "emailcc": emailcc, "msg": msg]
////
////        let a = ["idcontract1" : self.contractInfo!.idnumber!, "idcia": self.contractInfo!.idcia!, "email": userInfo.stringForKey(CConstants.UserInfoEmail) ?? "", "emailto" : "Roberto Reletez (roberto@buildersaccess.com)", "emailcc": "Kevin Zhao (kevin@buildersaccess.com)", "msg": msg]
        
//         let a = ["idcontract1" : self.contractInfo!.idnumber!, "idcia": self.contractInfo!.idcia!, "email": userInfo.stringForKey(CConstants.UserInfoEmail) ?? "", "emailto" : "April Lv (April@buildersaccess.com)", "emailcc": "xiujun_85@163.com", "msg": msg]
        
//        return;
//        print(a)
        Alamofire.request(.POST,
            CConstants.ServerURL + "bacontract_submitForApprove.json",
            parameters:a).responseJSON{ (response) -> Void in
                //                hud.hide(true)
                
                if response.result.isSuccess {
                    if let rtnValue = response.result.value as? [String: AnyObject]{
//                        print(rtnValue)
                        if rtnValue["result"] as? String ?? "-1" == "-1" {
                            self.hud?.hide(true)
                            self.PopErrorMsgWithJustOK(msg: rtnValue["message"] as? String ?? "Sever Error") {
                                (action : UIAlertAction) -> Void in
                                
                            }
                        }else{
                            self.contractInfo?.status = CConstants.ForApproveStatus
                            self.contractPdfInfo?.status = CConstants.ForApproveStatus
                            self.setSendItema()
                            
                            self.hud?.mode = .CustomView
                            let image = UIImage(named: CConstants.SuccessImageNm)
                            self.hud?.customView = UIImageView(image: image)
                            
                            self.hud?.labelText = "Submit successfully."
                            self.performSelector(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), withObject: nil, afterDelay: 0.5)
                        }
                    }else{
                        self.hud?.mode = .Text
                        self.hud?.labelText = CConstants.SavedFailMsg
                    }
                }else{
                    self.hud?.mode = .Text
                    self.hud?.labelText = CConstants.MsgServerError
                }
                self.performSelector(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), withObject: nil, afterDelay: 0.5)
        }
    }
    
    override func saveFinish() {
        self.saveToServer1(2)
    }
    
//    @IBOutlet var LaterWeb: UIWebView!
    func saveAndFinish2(xtype: Int8){
//        self.savePDFToServer(fileName!, nextFunc: nil)
        
//        func savePDFToServer(xname: String, nextFunc: String?){
        
            var parame : [String : String] = ["idcia" : pdfInfo0!.idcia!
                , "idproject" : pdfInfo0!.idproject!
                , "code" : pdfInfo0!.code!
                , "idcontract" : pdfInfo0!.idnumber ?? ""
                ,"filetype" : pdfInfo0?.nproject ?? "" + "_\(fileName!)_FromApp"]
            
            var savedPdfData: NSData?
            
            if self.documents != nil && self.documents?.count > 0 {
                savedPdfData = PDFDocument.mergedDataWithDocuments(self.documents)
            }else{
                if let added = pdfView?.addedAnnotationViews{
                    //            print(added)
                    savedPdfData = document?.savedStaticPDFData(added)
                }else{
                    savedPdfData = document?.savedStaticPDFData()
                }
            }
    
//        return
        
            let fileBase64String = savedPdfData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
            parame["file"] = fileBase64String
            parame["username"] = NSUserDefaults.standardUserDefaults().valueForKey(CConstants.LoggedUserNameKey) as? String ?? ""
            
            if hud == nil {
                hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            }
            hud?.labelText = CConstants.SavedMsg
//            print(parame)
            Alamofire.request(.POST,
                CConstants.ServerURL + CConstants.ContractUploadPdfURL,
                parameters: parame).responseJSON{ (response) -> Void in
                    print(response.result.value)
                    if response.result.isSuccess {
                        if let rtnValue = response.result.value as? [String: String]{
                            if rtnValue["status"] == "success" {
                                self.contractPdfInfo?.signfinishdate = "04/28/2016"
                                self.contractInfo?.signfinishdate = "04/28/2016"
                                self.setSendItema()
                                self.hud?.mode = .CustomView
                                let image = UIImage(named: CConstants.SuccessImageNm)
                                self.hud?.customView = UIImageView(image: image)
                                self.hud?.labelText = CConstants.SavedSuccessMsg
                                
                                
//                                self.pdfView?.removeFromSuperview()
//                                self.view2.hidden = true
//                                self.LaterWeb.hidden = false
//                                self.LaterWeb.scalesPageToFit = true
//                                self.LaterWeb.scrollView.bouncesZoom = false
//                                
////                                _pdfView.scalesPageToFit = YES;
////                                _pdfView.scrollView.delegate = self;
////                                _pdfView.scrollView.bouncesZoom = NO;
////                                _pdfView.delegate = self;
//                                self.LaterWeb.backgroundColor = UIColor.whiteColor()
////                                NSString *url = @"http://google.com?get=something&...";
////                                NSURL *nsUrl = [NSURL URLWithString:url];
////                                NSURLRequest *request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
//
//                                let url = "https://contractssl.buildersaccess.com/bacontract_contractDocument2?idcia=9999&idproject=100005"
////                                let blank = "about:blank"
//                                if let nsurl = NSURL(string: url){
//                                    let request = NSURLRequest(URL: nsurl)
//                                    self.LaterWeb.loadRequest(request)
//                                }
                            
                                
                                
                                if xtype == 3 {
                                    self.saveEmail2(fileBase64String!)
                                }
                            }else{
                                self.hud?.mode = .Text
                                self.hud?.labelText = CConstants.SavedFailMsg
                            }
                        }else{
                            self.hud?.mode = .Text
                            self.hud?.labelText = CConstants.MsgServerError
                        }
                    }else{
                        self.hud?.mode = .Text
                        self.hud?.labelText = CConstants.MsgNetworkError
                    }
//                    if let _ = nextFunc {
//                        self.performSelector(#selector(PDFBaseViewController.dismissProgressThenEmail as (PDFBaseViewController) -> () -> ()), withObject: nextFunc, afterDelay: 0.5)
//                        
//                    }else{
                    self.performSelector(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), withObject: nil, afterDelay: 0.5)
//                    }
            }
//        }
        
    }
    
  override  func saveEmail() {
        saveToServer1(3)
    }
    
//    var emailData : String?
    func saveEmail2(savedPdfData: String) {
        self.performSegueWithIdentifier("showEmail", sender: nil)
//        emailData = savedPdfData
    }
    
    func GoToEmailSubmit(email: String, emailcc: String, msg: String) {
//        let userInfo = NSUserDefaults.standardUserDefaults()
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud?.labelText = "Sending Email..."
        
        //        let a =  ["idcontract1" : self.contractInfo!.idnumber!, "idcia": self.contractInfo!.idcia!, "email": userInfo.stringForKey(CConstants.UserInfoEmail) ?? "", "emailto" : email, "emailcc": emailcc, "msg": msg]
        
        //        let a = ["idcontract1" : self.contractInfo!.idnumber!, "idcia": self.contractInfo!.idcia!, "email": userInfo.stringForKey(CConstants.UserInfoEmail) ?? "", "emailto" : "Roberto Reletez (roberto@buildersaccess.com)", "emailcc": "Kevin Zhao (kevin@buildersaccess.com)", "msg": msg]
        
        var email1 = email.stringByReplacingOccurrencesOfString(" ", withString: "")
        email1 = email1.stringByReplacingOccurrencesOfString("\n", withString: "")
        if email1.hasSuffix(",") {
            email1 = email1.stringByReplacingOccurrencesOfString(",", withString: "")
        }
        var emailcc1 = emailcc.stringByReplacingOccurrencesOfString(" ", withString: "")
        if emailcc1.hasSuffix(",") {
            emailcc1 = emailcc1.stringByReplacingOccurrencesOfString(",", withString: "")
        }
        let userInfo = NSUserDefaults.standardUserDefaults()
         let a = ["idcontract":contractInfo?.idnumber ?? "","EmailTo":email,"EmailCc":emailcc,"Subject":"\(contractInfo!.nproject!)'s Contract","Body":msg,"idcia":contractInfo?.idcia ?? "","idproject":contractInfo?.idproject ?? "", "salesemail": userInfo.stringForKey(CConstants.UserInfoEmail) ?? "", "salesname": userInfo.stringForKey(CConstants.UserInfoName) ?? ""]
        
//        let a = [ "idcontract": contractPdfInfo?.idnumber ?? " ", "EmailTo": email1, "EmailCc" : emailcc1, "Subject": "\(contractInfo!.nproject!)'s Contract",
//                  "Body" : msg, "Attachment1": emailData ?? " ", "Attachment2": " ", "Attachment3": " "]
//        print(a)
        
//        IdCia	query	int	No
//        EmailTo	query	string	No
//        EmailCc	query	string	No
//        Subject	query	string	No
//        Body	query	string	No
//        Attachment1	query	string	No
//        Attachment2	query	string	No	
//        Attachment3
        
        //        return;
//        print(a)
        Alamofire.request(.POST,
            CConstants.ServerURL + "bacontract_SendEmail2.json",
            parameters:a).responseJSON{ (response) -> Void in
//                self.emailData = nil
//                 print(response.result.value)
//                print(rtnValue)
                if response.result.isSuccess {
                    if let rtnValue = response.result.value as? Bool{
                        
                        if !rtnValue {
                            self.hud?.hide(true)
                            self.PopErrorMsgWithJustOK(msg: "Email sent failed.") {
                                (action : UIAlertAction) -> Void in
                            
                            }
                        }else{
                            
                            self.hud?.mode = .CustomView
                            let image = UIImage(named: CConstants.SuccessImageNm)
                            self.hud?.customView = UIImageView(image: image)
                            
                            self.hud?.labelText = "Email sent successfully."
                            self.performSelector(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), withObject: nil, afterDelay: 0.5)
                        }
                    }else{
                        self.hud?.mode = .Text
                        self.hud?.labelText = CConstants.SavedFailMsg
                    }
                }else{
                    self.hud?.mode = .Text
                    self.hud?.labelText = CConstants.MsgServerError
                }
                self.performSelector(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), withObject: nil, afterDelay: 0.5)
        }
    }
    
    func ClearEmailData(){
//        emailData = nil
    }
    
    var imagePicker: UIImagePickerController?
    
    override func attachPhoto() {
        self.performSegueWithIdentifier("showAttachPhoto", sender: nil)
        return
        
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imagePicker?.dismissViewControllerAnimated(true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let c = self.contractPdfInfo?.hasCheckedPhoto {
                if c == "1" {
                    let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: constants.operationMsg, preferredStyle: .Alert)
                    
                    //Create and add the OK action
                    let oKAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
                        self.uploadAttachedPhoto(image)
                    }
                    alert.addAction(oKAction)
                    
                    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                    alert.addAction(cancelAction)
                    
                    //Present the AlertController
                    self.presentViewController(alert, animated: true, completion: nil)
                }else{
                    uploadAttachedPhoto(image)
                }
            }else{
                uploadAttachedPhoto(image)
            }
        }
        
        
        
        
        
    }
    
    private func uploadAttachedPhoto(image : UIImage){
        let imageData = UIImageJPEGRepresentation(image, 0.65)
        let string = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //                hud.mode = .AnnularDeterminate
        self.hud?.labelText = "Uploading photo to BA Server..."
        let param = ["idcontract1" : contractInfo?.idnumber ?? "0" , "checked_photo" : string]
        Alamofire.request(.POST,
            CConstants.ServerURL + CConstants.UploadCheckedPhotoURL,
            parameters: param).responseJSON{ (response) -> Void in
//                hud.hide(true)
                //                print(param, serviceUrl, response.result.value)
                if response.result.isSuccess {
                    
                    if let rtnValue = response.result.value as? Bool{
                        
                        if rtnValue{
                            self.contractPdfInfo?.hasCheckedPhoto = "1"
                            self.hud?.mode = .CustomView
                            let image = UIImage(named: CConstants.SuccessImageNm)
                            self.hud?.customView = UIImageView(image: image)
                            
                            self.hud?.labelText = "Saved successfully."
                            
                        }else{
                            self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                        }
                    }else{
                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                    }
                }else{
                    //                            self.spinner?.stopAnimating()
                    self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                }
                self.performSelector(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), withObject: nil, afterDelay: 0.5)
        }
    }
    
    func sumOf(numbers: [Int]) -> Int {
        var sum = 0
        for number in numbers {
            sum += number
        }
        return sum
    }
    
    func skipToFile(filenm: String) {
        var pageCnt = 0
        for i in 0...(self.filesArray?.count ?? 0){
            if filenm != self.filesArray![i] {
                pageCnt += self.filesPageCountArray![i] ?? 0
            }else{
                break
            }
        }
        
        let t = sumOf(self.filesPageCountArray!)
        
        let h = (self.pdfView?.pdfView.scrollView.contentSize.height ?? 0) - getMargins2()
        if h > 0 {
            let ch = (h / CGFloat(t)) * CGFloat(pageCnt)
            self.pdfView?.pdfView.scrollView.setContentOffset(CGPoint(x: 0.0, y: Double(ch)), animated: false)
        }
    }
    
    func getMargins2() -> CGFloat {
        let currentOrientation = UIApplication.sharedApplication().statusBarOrientation
        if UIInterfaceOrientationIsPortrait(currentOrientation) {
            return 6.1
        }else{
            if max(self.view.frame.size.height, self.view.frame.size.width) > 1024 {
                return 2.5
            }else{
                return 7.5
            }
        }
    }
    
   override func sendEmail2() {
    self.performSegueWithIdentifier(constants.segueToSendEmailAfterApproved, sender: nil)
    }
    
   override func emailContractToBuyer() {
    self.performSegueWithIdentifier(constants.segueToEmailContractToBuyer, sender: nil)
    
    }
    
override func viewAttachPhoto(){
    self.performSegueWithIdentifier("showAttachPhoto", sender: nil)
    }

    
    

func GoToSendEmailToBuyer(msg msg: String, hasbuyer1: Bool, hasbuyer2: Bool) {
    //bacontract_SendContractToBuyer
//    print("checkBuyer1", checkBuyer1())
//    print("checkBuyer2", checkBuyer2())
    if hasbuyer1 || hasbuyer2 {
        
        var b1:String
        var b1email : String
        var b2: String
        var b2email: String
        if hasbuyer1 {
            b1email = contractPdfInfo?.bemail1 ?? ""
            b1 = contractPdfInfo?.client ?? ""
        }else{
            b1email = " "
            b1 = " "
        }
        
        if hasbuyer2 {
            b2email = contractPdfInfo?.bemail2 ?? ""
            b2 = contractPdfInfo?.client2 ?? ""
        }else{
            b2email = " "
            b2 = " "
        }
        let userInfo = NSUserDefaults.standardUserDefaults()
        let param = ["idcontract":"\(self.contractInfo?.idnumber ?? "")","buyer1email":"\(b1email)", "buyer2email":"\(b2email)","idcity":"\(self.contractInfo?.idcity ?? "")","idcia":"\(self.contractInfo?.idcia ?? "")","emailcc":"","buyer1name":"\(b1)","buyer2name":"\(b2)","emailbody":"\(msg)","emailsubject":"Sign contract online", "salesemail": userInfo.stringForKey(CConstants.UserInfoEmail) ?? "", "salesname": userInfo.stringForKey(CConstants.UserInfoName) ?? ""]
//        return
//        print(param)
//        return
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //                hud.mode = .AnnularDeterminate
        hud.labelText = "Sending Email..."
        //        print(printModelNm, serviceUrl)
        Alamofire.request(.POST,
            CConstants.ServerURL + "bacontract_SendContractToBuyer.json",
            parameters: param).responseJSON{ (response) -> Void in
                hud.hide(true)
//                print(param)
                if response.result.isSuccess {
//                    print(response.result.value)
                    
                    if let a = response.result.value as? Bool {
                        if a {
                            
                            self.contractPdfInfo?.status = "Email Sign"
                            if hasbuyer1 {
                                self.contractPdfInfo?.verify_code = "1"
                            }
                            if hasbuyer2 {
                                self.contractPdfInfo?.verify_code2 = "1"
                            }
                            self.setSendItema()
                            self.setBuyer2()
                            self.PopMsgWithJustOK(msg: "Email Contract to Buyer successfully.")
//                            self.sendItem.image = UIImage(named: "send.png")
////                            self.sendItem.image = nil
//                            self.seller2Item.title = "Status: Email Sign"
                        }else{
                            self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                        }
                    }else{
                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                    }
//                    if let rtnValue = response.result.value as? [String: AnyObject]{
//                        print
//                    }else{
//                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
//                    }
                }else{
                    //                            self.spinner?.stopAnimating()
                    self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                }
        }
    }
    
    }
    
    
    func checkBuyer1() -> (Bool, SignatureView?) {
        let tl = toolpdf()
        var tmpa = [String]()
        for (_, tmp) in tl.pdfBuyer1SignatureFields {
            tmpa.appendContentsOf(tmp)
        }
        
        var alldots = [PDFWidgetAnnotationView]()
        
        for (_,allAdditionViews) in self.fileDotsDic!{
            alldots.appendContentsOf(allAdditionViews)
        }
        
        for doc in self.documents!{
            if let a = doc.addedviewss as? [PDFWidgetAnnotationView]{
                alldots.appendContentsOf(a)
            }
        }
        
        for c in alldots {
            if let a = c as? SignatureView {
                if tmpa.contains(a.xname) {
                    if !(a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0){
//                        print(a.xname)
                        return (false, a)
                    }
                    
                }
            }
        }
        return (true, nil)
    }
    
    func checkBuyer2() -> Bool {
        let tl = toolpdf()
        var tmpa = [String]()
        for (_, tmp) in tl.pdfBuyer2SignatureFields {
            tmpa.appendContentsOf(tmp)
        }
        
        var alldots = [PDFWidgetAnnotationView]()
        
        for (_,allAdditionViews) in self.fileDotsDic!{
            alldots.appendContentsOf(allAdditionViews)
        }
        
        for doc in self.documents!{
            if let a = doc.addedviewss as? [PDFWidgetAnnotationView]{
                alldots.appendContentsOf(a)
            }
        }
        
        for c in alldots {
            if let a = c as? SignatureView {
                if tmpa.contains(a.xname) {
                    if !(a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0){
//                        print(a.xname)
                        return false
                    }
                    
                }
            }
        }
        return true
    }
    
    
    override func submitBuyer1Sign(){
        
        
    submitBuyerSignStep1(true)
    }
    
    private func submitBuyerSignStep1(isbuyer1: Bool){
        let tlpdf = toolpdf()
        let (finishYN, sign) = tlpdf.CheckBuyerFinish(self.fileDotsDic, documents: self.documents, isbuyer1: isbuyer1)
//        print(sign?.xname)
        if finishYN {
            var msg : String
            if isbuyer1 {
                msg = "Are you sure you want to submit buyer1's Sign?"
            }else{
                msg = "Are you sure you want to submit buyer2's Sign?"
            }
            let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: msg, preferredStyle: .Alert)
            
            //Create and add the OK action
            let oKAction: UIAlertAction = UIAlertAction(title: "YES", style: .Default)  { Void in
                self.saveToServer1(isbuyer1 ? 4 : 5)
                
            }
            alert.addAction(oKAction)
            
            let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel){ Void in
                
            }
            alert.addAction(cancel)
            
            
            
            //Present the AlertController
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            
            let  buyerSign =  isbuyer1 ? tlpdf.pdfBuyer1SignatureFields : tlpdf.pdfBuyer2SignatureFields
            for (x, f) in buyerSign {
                if f.contains(sign?.xname ?? "") && (sign?.xname ?? "") != "p1EBExhibitbp1sellerInitialSign" {
                    
                    //                    self.PopMsgWithJustOK(msg: "There is a filed need sign in \(x) document.")
                    
                    let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: "There is a filed need to be signed in \(x) document. Go to that field?", preferredStyle: .Alert)
                    
                    //Create and add the OK action
                    let oKAction: UIAlertAction = UIAlertAction(title: CConstants.MsgOKTitle, style: .Default)  { Void in
                        
                        if let cg0 = sign?.center {
                            var cg = cg0
                            cg.x = 0
                            cg.y = cg.y - self.view.frame.height/2
                            if cg.y ?? 0 > 0 {
                                self.pdfView?.pdfView.scrollView.setContentOffset(cg, animated: false)
                            }
                        }
                        
                        
                    }
                    alert.addAction(oKAction)
                    
                    let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel){ Void in
                        
                    }
                    alert.addAction(cancel)
                    
                    
                    
                    //Present the AlertController
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    private func submitBuyerSignStep2(isbuyer1: Bool){
//        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        //                hud.mode = .AnnularDeterminate
//        hud.labelText = CConstants.RequestMsg
        //        print(param, serviceUrl)
        let param = ["idcontract":self.contractPdfInfo?.idnumber ?? "","buyer1yn": (isbuyer1 ? "1" : "0") ,"buyer2yn":(isbuyer1 ? "0" : "1")]
        Alamofire.request(.POST,
            CConstants.ServerURL + "bacontract_SubmitBuyerSignFinshed.json",
            parameters: param).responseJSON{ (response) -> Void in
                self.hud?.hide(true)
                //                print(param, serviceUrl)
                if response.result.isSuccess {
                    
                    if let rtnValue = response.result.value as? Bool{
                        
                        if rtnValue{
                            if isbuyer1 {
                                self.contractPdfInfo?.buyer1SignFinishedyn = 1
                            }else{
                                self.contractPdfInfo?.buyer2SignFinishedyn = 1
                            }
                            self.PopMsgWithJustOK(msg: "Submit successfully.")
                        }else{
                            self.PopMsgWithJustOK(msg: "Error happened when submit, please try it again later.")
                        }
                    }else{
                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                    }
                }else{
                    //                            self.spinner?.stopAnimating()
                    self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                }
        }
    }
    override func submitBuyer2Sign(){
    submitBuyerSignStep1(false)
    }
    
    
    override func changeBuyre1ToIPadSign(){
        changeBuyreToIPadSign(true)
    }
    override func changeBuyre2ToIPadSign(){
        changeBuyreToIPadSign(false)
    
    }
    
    private func changeBuyreToIPadSign(isbuyer1 : Bool) {
        var msg : String
        if isbuyer1 {
            if self.contractPdfInfo?.client2 == "" {
                msg = "If you change buyer to ipad sign, buyer will cannot sign online. Are you sure you want to submit?"
            }else{
                msg = "If you change buyer1 to ipad sign, buyer1 will cannot sign online. Are you sure you want to submit?"
            }
            
        }else{
            msg = "If you change buyer2 to ipad sign, buyer2 will cannot sign online. Are you sure you want to submit?"
        }
        
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: msg, preferredStyle: .Alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: "YES", style: .Default)  { Void in
            self.changeBuyreToIPadSignStep2(isbuyer1)
            
        }
        alert.addAction(oKAction)
        
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel){ Void in
            
        }
        alert.addAction(cancel)
        
        
        
        //Present the AlertController
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func changeBuyreToIPadSignStep2(isbuyer1 : Bool) {
        let param = ["idcontract":self.contractPdfInfo?.idnumber ?? "","buyer1yn": (isbuyer1 ? "1" : "0") ,"buyer2yn":(isbuyer1 ? "0" : "1")]
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                //                hud.mode = .AnnularDeterminate
                hud.labelText = CConstants.SubmitMsg
        Alamofire.request(.POST,
            CConstants.ServerURL + "bacontract_ChangeEmailSignToIpadSign.json",
            parameters: param).responseJSON{ (response) -> Void in
                hud.hide(true)
                //                print(param, serviceUrl)
                if response.result.isSuccess {
                    
                    if let rtnValue = response.result.value as? Bool{
                        
                        if rtnValue{
                            
                            if isbuyer1 {
                                self.contractPdfInfo?.verify_code = ""
                                if self.contractPdfInfo?.verify_code2 == "" {
                                    self.contractPdfInfo?.status = "iPad Sign"
                                }
                            }else {
                                self.contractPdfInfo?.verify_code2 = ""
                                if self.contractPdfInfo?.verify_code == "" {
                                    self.contractPdfInfo?.status = "iPad Sign"
                                }
                            }
                            self.setBuyer2()
                            self.setSendItema()
                            self.PopMsgWithJustOK(msg: "Submit successfully.")
                        }else{
                            self.PopMsgWithJustOK(msg: "Error happened when submit, please try it again later.")
                        }
                    }else{
                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                    }
                }else{
                    //                            self.spinner?.stopAnimating()
                    self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                }
        }
    }
    
    override func gotoBuyer1Sign() {
    self.gotoBuyerSign(true)
    }
    override func gotoBuyer2Sign() {
    self.gotoBuyerSign(false)
    }
    override func gotoSellerSign() {
        let tp = toolpdf()
        let (t, sign) =  tp.CheckSellerFinish(self.fileDotsDic, documents: self.documents)
        if !t {
            if let cg0 = sign?.center {
                var cg = cg0
                cg.x = 0
                cg.y = cg.y - self.view.frame.height/2
                if cg.y ?? 0 > 0 {
                    self.pdfView?.pdfView.scrollView.setContentOffset(cg, animated: false)
                }
            }
        }else{
            self.PopMsgWithJustOK(msg: "You have signed all fields.")
        }
    }
    
    func gotoBuyerSign(isbuyer: Bool) {
        let tp = toolpdf()
        let (t, sign) =  tp.CheckBuyerFinish(self.fileDotsDic, documents: self.documents, isbuyer1: isbuyer)
        if !t {
            if let cg0 = sign?.center {
                var cg = cg0
                cg.x = 0
                cg.y = cg.y - self.view.frame.height/2
                if cg.y ?? 0 > 0 {
                    self.pdfView?.pdfView.scrollView.setContentOffset(cg, animated: false)
                }
            }
        }else{
            self.PopMsgWithJustOK(msg: "You have signed all fields.")
        }
    }
    
//    {"idcontract":"String","buyer1email":"String","buyer2email":"String","idcity":"String","idcia":"String","emailcc":"String","buyer1name":"String","buyer2name":"String","emailbody":"String","emailsubject":"String"}
}


