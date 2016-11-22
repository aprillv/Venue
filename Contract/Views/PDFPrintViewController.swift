
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


class PDFPrintViewController: PDFBaseViewController, UIScrollViewDelegate, PDFViewDelegate, SaveAndEmailViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, GoToFileDelegate, EmailContractToBuyerViewControllerDelegate, DoOperationDelegate{
    
    @IBOutlet var operationItem: UIBarButtonItem!
    @IBAction func DoOperation(sender: UIBarButtonItem) {
        if sender.image == nil {
            return;
        }
        if self.ContractData?.status == CConstants.ApprovedStatus {
            self.performSegueWithIdentifier(constants.segueToEmailContract, sender: nil)
        }else {
            self.performSegueWithIdentifier(CConstants.SegueToOperationsPopover, sender: nil)
        }
        
    }
    func pageChanged(no: Int) {
        
    }
    var idContract : String?
    var pdfPath : String?
    private struct constants{
        
        static let saveToSeverURL = "bavenue_save_sign.json"
        static let submitToSeverURL = "bavenue_submitFromIPad.json"
        static let uploadToServerURL = "bavenuecontract_upload.json"
        static let emailToLicenseeServerURL = "bavenue_SendContractToLicensee.json"
        static let changeLicenseeToIPadServerURL = "bavenue_changetoIpadSign.json"
        
        static let segueToEmailContract = "showEmail"
        static let segueToSendEmailAfterApproved = "showSendEmail"
        static let segueToEmailContractToBuyer = "EmailContractToBuyer"
        
       
        
        static let nextConsultant = "Next - Consultant"
        static let nextLicensee = "Next - Licensee"
        
        
        //        static let ExhibitAHTMLHead = "<p style=\"text-align:center;font:10pt Helvetica,sans-serif;margin:30px 0 0 0;\"><strong>EXHIBIT A</strong></p><p style=\"text-align:center;font:10pt Helvetica,sans-serif;margin:0;\"><strong>VENUE/EVENT INFORMATION</strong></p><div style=\"font:10pt Helvetica,sans-serif;margin:15px 30px 0;\"><p>"
        //        static let ExhibitAHTMLRear = "</p></div>"
        //
        //        static let ExhibitBHTMLHead = "<p style=\"text-align:center;font:10pt Helvetica,sans-serif;margin:30px 0 0 0;\"><strong>EXHIBIT A</strong></p><p style=\"text-align:center;font:10pt Helvetica,sans-serif;margin:0;\"><strong>VENUE/EVENT INFORMATION</strong></p><div style=\"font:10pt Helvetica,sans-serif;margin:15px 30px 0;\"><p>"
        //        static let ExhibitBHTMLRear = "</p></div>"
        
        
    }
    
    var ContractData : ContractDetail?{
        didSet{
            updateField()
            
        }
    }
    
    private func setShowSignature(si: SignatureView, signs signsx: String, toshow : Bool) {
        
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
        
        if toshow {
            si.LineWidth = 5.0
        }else{
            si.LineWidth = 0.0
        }
        
        
        
    }
    
    func updateField() {
        if let data = ContractData
            ,let dots = self.dotsss{
            showSkipToNext()
            for c in dots {
                //                print(c.xname, c.frame)
                if let si = c as? SignatureView {
                    if data.initial_licensee != "" {
                        switch si.xname {
                        case "p1bottom1":
                            self.setShowSignature(si, signs: data.initial_licensee!, toshow: data.initial_licenseeyn1?.boolValue ?? false)
                        case "p2bottom1":
                            self.setShowSignature(si, signs: data.initial_licensee!, toshow: data.initial_licenseeyn2?.boolValue ?? false)
                        case "p3bottom1":
                            self.setShowSignature(si, signs: data.initial_licensee!, toshow: data.initial_licenseeyn3?.boolValue ?? false)
                        case "p4bottom1":
                            self.setShowSignature(si, signs: data.initial_licensee!, toshow: data.initial_licenseeyn4?.boolValue ?? false)
                        case "p5bottom1":
                            self.setShowSignature(si, signs: data.initial_licensee!, toshow: data.initial_licenseeyn5?.boolValue ?? false)
                        case "p7bottom1":
                            self.setShowSignature(si, signs: data.initial_licensee!, toshow: data.initial_licenseeyn7?.boolValue ?? false)
                        case "p8bottom1":
                            self.setShowSignature(si, signs: data.initial_licensee!, toshow: data.initial_licenseeyn8?.boolValue ?? false)
                        default:
                            break
                        }
                    }
                    if data.signature_licensee != "" {
                        if si.xname == "licenseeSign" {
                            self.setShowSignature(si, signs: data.signature_licensee!, toshow: data.signature_licenseeyn6?.boolValue ?? false)
                        }
                    }
                    if data.initial_consultant != "" {
                        switch si.xname {
                        case "p1bottom3":
                            self.setShowSignature(si, signs: data.initial_consultant!, toshow: data.initial_consultantyn1?.boolValue ?? false)
                        case "p2bottom3":
                            self.setShowSignature(si, signs: data.initial_consultant!, toshow: data.initial_consultantyn2?.boolValue ?? false)
                        case "p3bottom3":
                            self.setShowSignature(si, signs: data.initial_consultant!, toshow: data.initial_consultantyn3?.boolValue ?? false)
                        case "p4bottom3":
                            self.setShowSignature(si, signs: data.initial_consultant!, toshow: data.initial_consultantyn4?.boolValue ?? false)
                        case "p5bottom3":
                            self.setShowSignature(si, signs: data.initial_consultant!, toshow: data.initial_consultantyn5?.boolValue ?? false)
                        case "p7bottom3":
                            self.setShowSignature(si, signs: data.initial_consultant!, toshow: data.initial_consultantyn7?.boolValue ?? false)
                        case "p8bottom3":
                            self.setShowSignature(si, signs: data.initial_consultant!, toshow: data.initial_consultantyn8?.boolValue ?? false)
                        default:
                            break
                            
                        }
                    }
                    if data.signature_consultant != "" {
                        if si.xname == "sellerSign" {
                            self.setShowSignature(si, signs: data.signature_consultant!, toshow: data.signature_licenseeyn6?.boolValue ?? false)
                        }
                    }
                    
                    if data.status == "Draft" && data.signtype == "iPad" {
                        //                        if data.licenseeSignFinishedYn!.boolValue {
                        //                            if si.xname == "sellerSign" || si.xname.hasSuffix("bottom3") {
                        //                                si.pdfViewsssss = self.pdfView
                        //                                si.addSignautre(pdfView!.pdfView!.scrollView)
                        //                            }
                        //                        }else{
                        //                            if si.xname == "licenseeSign" || si.xname.hasSuffix("bottom1") {
                        //                                si.pdfViewsssss = self.pdfView
                        //                                si.addSignautre(pdfView!.pdfView!.scrollView)
                        //                            }
                        //                        }
                        if si.xname == "licenseeSign" || si.xname.hasSuffix("bottom1")
                            || si.xname == "sellerSign" || si.xname.hasSuffix("bottom3") {
                            si.pdfViewsssss = self.pdfView
                            si.addSignautre(pdfView!.pdfView!.scrollView)
                        }
                    }else if data.status == "Draft" && data.signtype == "iPad" {
                        if si.xname == "sellerSign" || si.xname.hasSuffix("bottom3") {
                            si.pdfViewsssss = self.pdfView
                            si.addSignautre(pdfView!.pdfView!.scrollView)
                        }
                    }
                    
                }else{
                    switch c.xname {
                        //                    case "By":
                    //                        c.value = data.By
                    case "Date_2":
                        c.value = data.Date_2
                    case "LICENSEE":
                        c.value = data.licensee
                    case "Date_3":
                        c.value = data.Date_3
                        //                    case "By_2":
                    //                        c.value = data.By_2
                    case "Date_4":
                        c.value = data.Date_4
                    case "licensor":
                        c.value = data.licensor
                    case "licensor":
                        c.value = data.licensor
                    case "licensee":
                        c.value = data.licensee
                    case "effectiveDate":
                        c.value = data.effectiveDate
                    case "venueName":
                        c.value = data.venueName
                    case "venueAddress":
                        c.value = data.venueAddress
                    case "eventName":
                        c.value = data.eventName
                    case "eventDateEnd":
                        c.value = data.eventDateEnd
                    case "licenseFeeS":
                        c.value = data.licenseFeeS
                    case "licenseFeeN":
                        c.value = data.licenseFeeN
                    case "depositFeeS":
                        c.value = data.depositFeeS
                    case "depositFeeN":
                        c.value = data.depositFeeN
                    case "eventDateStart":
                        c.value = data.eventDateStart
                    case "contractDateStart":
                        c.value = data.contractDateStart
                    case "contractDateEnd":
                        c.value = data.contractDateEnd
                    case "firstPaymentDate":
                        c.value = data.firstPaymentDate
                    case "lastPaymentDate":
                        c.value = data.lastPaymentDate
                    case "paymentSpanS":
                        c.value = data.paymentSpanS
                    case "paymentSpanN":
                        c.value = data.paymentSpanN
                    case "cancellationDayS":
                        c.value = data.cancellationDayS
                    case "cancellationDayN":
                        c.value = data.cancellationDayN
                    case "insuranceS":
                        c.value = data.insuranceS
                    case "insuranceN":
                        c.value = data.insuranceN
                    case "ticketAmount":
                        c.value = data.ticketAmount
                        //                    case "exhibita":
                        //                        c.value = data.exhibita
                        //                    case "exhibitb":
                    //                        c.value = data.exhibitb
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func getSignature(){
        //        print(["idcontract1" : self.contractInfo!.idnumber!])
        let userInfo = NSUserDefaults.standardUserDefaults()
        let email = userInfo.valueForKey(CConstants.UserInfoEmail) as? String ?? ""
        let password = userInfo.valueForKey(CConstants.UserInfoPwd) as? String ?? ""
        
        Alamofire.request(.POST,
            CConstants.ServerURL + CConstants.ContractDetailServiceURL,
            parameters: ["email" :email, "password" : password, "idcontract" : self.idContract ?? ""]).responseJSON{ (response) -> Void in
                //                hud.hide(true)
                if response.result.isSuccess {
                    // print(response.result.value)
                    if let rtnValue = response.result.value as? [String: AnyObject]{
                        //                       print(rtnValue)
                        self.ContractData = ContractDetail(dicInfo: rtnValue)
                    }else{
                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                    }
                }else{
                    self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                }
        }
        
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
            if xt == constants.nextLicensee{
                self.gotoBuyerSign()
            }else{
                self.gotoSellerSign()
            }
        }
    }
    
    var isDownload : Bool?
    @IBOutlet var view2: UIView!
    
    var page2 : Bool?
    
    var filesArray : [String]?
    var filesPageCountArray : [Int]?
    var fileDotsDic : [String : [PDFWidgetAnnotationView]]?
    
    private func getFileName() -> String{
        return "contract1pdf_" + self.pdfInfo0!.idcity! + "_" + self.pdfInfo0!.idcia!
    }
    
    override func loadPDFView(){
        var filesNames = [String]()
        let document : PDFDocumentApp
        
        self.documents = [PDFDocumentApp]()
        if let path = self.pdfPath {
            filesNames.append(CConstants.PdfFileNameContract)
            filesNames.append(path)
//            let document2 = PDFDocumentApp.init(path: path)
//            self.documents?.append(document2)
            
//            document.pdfName = CConstants.PdfFileNameContract
        }else{
            filesNames.append(CConstants.PdfFileNameContractFull)
//            self.document =
//            self.documents?.append( PDFDocumentApp.init(resource: CConstants.PdfFileNameContract))
            
        }
        document = PDFDocumentApp.init(resource: CConstants.PdfFileNameContract)
        document.pdfName = CConstants.PdfFileNameContract
        let margins = getMargins()
        
        
        self.documents?.append(document)
        let document2 = PDFDocumentApp.init(path: self.pdfPath)!
        self.documents?.append(document2)
        var h = CGFloat(0)
        if let additionViews = PDFDocumentApp.init(resource: "Venue License Agreement (Form)_exhibita.pdf").forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y, pageMargin: 6) as? [PDFWidgetAnnotationView]{
            let s = additionViews[0]
            h = CGFloat(s.pagenomargin)
//            print(s.pagenomargin)
        }
        
        if let additionViews = document.forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y, pageMargin: 0) as? [PDFWidgetAnnotationView]{
            
            var p4 : PDFWidgetAnnotationView?
            var p5 : PDFWidgetAnnotationView?
            for s in additionViews {
                if s.xname == "p4bottom1" {
                    p4 = s
                }else if s.xname == "p5bottom3" {
                    p5 = s
                }
            }
            
            pdfView = PDFViewApp(frame: view2.bounds, dataOrPathArray: filesNames, additionViews: additionViews)
            pdfView?.delegate = self
            
//            print(pdfView?.pdfWidgetAnnotationViews)
            
            pdfView?.setWidgetAnnotationViews(additionViews)
//            print(pdfView?.pdfWidgetAnnotationViews)
            print(p4!.pagenomargin, p5!.pagenomargin)
            let sign = SignatureView(frame: CGRect(x: p4!.frame.origin.x, y: (p5!.frame.origin.y - p4!.frame.origin.y)*2 + p5!.frame.origin.y, width: 53, height: 22.6))
            sign.xname = "p7bottom1"
            sign.pagenomargin = h
            sign.pageno = "1"
            sign.pdfViewsssss = self.pdfView
            
            let sign2 = SignatureView(frame: CGRect(x: p5!.frame.origin.x, y: (p5!.frame.origin.y - p4!.frame.origin.y)*2 + p5!.frame.origin.y, width: 53, height: 22.6))
            sign2.xname = "p7bottom3"
            sign2.pageno = "1"
            sign2.pagenomargin = h
            sign2.pdfViewsssss = self.pdfView
            
            let texts = PDFFormTextField(frame: CGRect(x: 90, y: (p5!.frame.origin.y - p4!.frame.origin.y)*2 + p5!.frame.origin.y + 60, width: 153, height: 12))
            texts.value = "053346/000001"
            texts.xname = "tx"
            texts.pagenomargin = h
            texts.pageno = "1"
            let texts1 = PDFFormTextField(frame: CGRect(x: 90, y: (p5!.frame.origin.y - p4!.frame.origin.y)*2 + p5!.frame.origin.y + 72, width: 153, height: 12))
            texts1.pagenomargin = h
            texts1.value = "146 - 2212130v2"
            texts1.pageno = "1"
            texts1.xname = "tx"
            
            let sign3 = SignatureView(frame: CGRect(x: p4!.frame.origin.x, y: (p5!.frame.origin.y - p4!.frame.origin.y)*3 + p5!.frame.origin.y, width: 53, height: 22.6))
            sign3.xname = "p8bottom1"
            sign3.pageno = "2"
            sign3.pagenomargin = h
            sign3.pdfViewsssss = self.pdfView
            
            let sign4 = SignatureView(frame: CGRect(x: p5!.frame.origin.x, y: (p5!.frame.origin.y - p4!.frame.origin.y)*3 + p5!.frame.origin.y, width: 53, height: 22.6))
            sign4.xname = "p8bottom3"
            sign4.pageno = "2"
            sign4.pagenomargin = h
            sign4.pdfViewsssss = self.pdfView
            
            let texts3 = PDFFormTextField(frame: CGRect(x: 90, y: (p5!.frame.origin.y - p4!.frame.origin.y)*3 + p5!.frame.origin.y + 60, width: 153, height: 12))
            texts3.value = "053346/000001"
            texts3.xname = "tx"
            texts3.pagenomargin = h
            texts3.pageno = "2"
            let texts4 = PDFFormTextField(frame: CGRect(x: 90, y: (p5!.frame.origin.y - p4!.frame.origin.y)*3 + p5!.frame.origin.y + 72, width: 153, height: 12))
            texts4.pagenomargin = h
            texts4.value = "146 - 2212130v2"
            texts4.xname = "tx"
            texts4.pageno = "2"
            
            document2.addedviewss =  [sign, sign2, sign3, sign4, texts, texts1, texts3, texts4]
        
            self.pdfView?.addedCCCCAnnotationViews = [sign, sign2, sign3, sign4, texts, texts1, texts3, texts4]
            self.pdfView?.addMoreDots([sign, sign2, sign3, sign4, texts, texts1, texts3, texts4])
            
//            print(pdfView?.pdfWidgetAnnotationViews)
            
            var s = additionViews
            s.append(sign)
            s.append(sign2)
            s.append(sign3)
            s.append(sign4)
            s.append(texts)
            self.dotsss = s
            
            updateField()
            
            view2.addSubview(pdfView!)
        }
        
        
        
    }
    
    var dotsss : [PDFWidgetAnnotationView]?
    
    private func showSkipToNext(){
        if let list = self.navigationItem.leftBarButtonItems {
            if list.count >= 3 {
                let b1 = list[1]
                let b2 = list[2]
                //                sendItem.title = ""
                if self.ContractData?.status == "Draft" && self.ContractData?.signtype == "iPad" {
                    b2.title = constants.nextConsultant
                    b1.title = constants.nextLicensee
                    
                    seller2Item.title = "IPad Sign"
                } else if self.ContractData?.status == "Draft" && self.ContractData?.signtype == "Email" {
                    b2.title = ""
                    b1.title = ""
                    
                    seller2Item.title = "Waiting for Email Sign"
                }else{
                    b2.title = ""
                    b1.title = ""
                    seller2Item.title = "Finished"
                    operationItem.image = UIImage(named: "email" )
                }
            }
            
        }
        
    }
    
    
    
    
    
    
    @IBAction func  SellerSign(sender: UIBarButtonItem) {
        //        BuyerSign(sender)
        if sender.title != "" && (sender.title ?? "").hasPrefix("Re") {
            //            self.saveToServer1(2)
        }
        
    }
    //
    //    @IBOutlet var buyer1Date: UIBarButtonItem!
    //    @IBOutlet var buyer2Date: UIBarButtonItem!
    //    @IBOutlet var buyer1Item: UIBarButtonItem!
    //    @IBOutlet var buyer2Item: UIBarButtonItem!
    @IBOutlet var seller2Item: UIBarButtonItem!
    
    
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
        var msg : String
        if self.ContractData?.status == CConstants.DraftStatus {
            if (self.ContractData?.licenseeSignFinishedYn?.boolValue ?? false) {
                msg = "This operation will just clear Consultant's sign. Are you sure you want to Start Over?"
            }else{
                msg = "This operation will clear both Licensee and Consultant's sign. Are you sure you want to Start Over?"
            }
            
            let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: msg, preferredStyle: .Alert)
            
            //Create and add the OK action
            let oKAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
                //Do some stufrf
                let tlpdf = toolpdf()
                
                if (self.ContractData?.licenseeSignFinishedYn?.boolValue ?? false) {
                    tlpdf.clearLicenseeSign(self.dotsss, viewa: self.pdfView!.pdfView!.scrollView)
                }else{
                    tlpdf.clearAllSign(self.dotsss, viewa: self.pdfView!.pdfView!.scrollView)
                }
            }
            alert.addAction(oKAction)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            
            //Present the AlertController
            self.presentViewController(alert, animated: true, completion: nil)
            
            
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
    
    
    override func saveToServer() {
        saveToServerStep(1)
    }
    func saveToServerStep(xtype: Int32) {
        
        let tl = toolpdf()
        let licenseeInitial : [[String]]? = tl.getLicenseeInitial(self.dotsss)?.lineArray as? [[String]]
        let licenseeSignature : [[String]]? = tl.getLicenseeSignature(self.dotsss)?.lineArray as? [[String]]
        let consultantInitial : [[String]]? = tl.getConsultantInitial(self.dotsss)?.lineArray as? [[String]]
        let consultantSignature : [[String]]? = tl.getConsultantSignature(self.dotsss)?.lineArray as? [[String]]
        
        var initial_licenseeyn1	= "0"
        var initial_licenseeyn2	= "0"
        var initial_licenseeyn3	= "0"
        var initial_licenseeyn4	= "0"
        var initial_licenseeyn5	= "0"
        var signature_licenseeyn6 = "0"
        var initial_licenseeyn7	= "0"
        var initial_licenseeyn8	= "0"
        
        
        var initial_consultantyn1	= "0"
        var initial_consultantyn2	= "0"
        var initial_consultantyn3	= "0"
        var initial_consultantyn4	= "0"
        var initial_consultantyn5	= "0"
        var signature_consultantyn6	= "0"
        var initial_consultantyn7	= "0"
        var initial_consultantyn8	= "0"
        
        
        for si in self.dotsss! {
            if let a = si as? SignatureView {
                switch si.xname {
                case "p1bottom1":
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0) {
                        initial_licenseeyn1 = "1"
                    }
                case "p2bottom1":
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0) {
                        initial_licenseeyn2 = "1"
                    }
                case "p3bottom1":
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0) {
                        initial_licenseeyn3 = "1"
                    }
                case "p4bottom1":
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0) {
                        initial_licenseeyn4 = "1"
                    }
                case "p5bottom1":
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0) {
                        initial_licenseeyn5 = "1"
                    }
                case "licenseeSign":
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0) {
                        signature_licenseeyn6 = "1"
                    }
                case "p7bottom1":
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0) {
                        initial_licenseeyn7 = "1"
                    }
                case "p8bottom1":
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0) {
                        initial_licenseeyn8 = "1"
                    }
                case "p1bottom3":
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0) {
                        initial_consultantyn1 = "1"
                    }
                case "p2bottom3":
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0) {
                        initial_consultantyn2 = "1"
                    }
                case "p3bottom3":
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0) {
                        initial_consultantyn3 = "1"
                    }
                case "p4bottom3":
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0) {
                        initial_consultantyn4 = "1"
                    }
                case "p5bottom3":
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0) {
                        initial_consultantyn5 = "1"
                    }
                case "sellerSign":
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0) {
                        signature_consultantyn6 = "1"
                    }
                case "p7bottom3":
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0) {
                        initial_consultantyn7 = "1"
                    }
                case "p8bottom3":
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0) {
                        initial_consultantyn8 = "1"
                    }
                default:
                    break
                }
            }
        }
        
        var param = [String :String]()
        let userInfo = NSUserDefaults.standardUserDefaults()
        param["email"] = userInfo.valueForKey(CConstants.UserInfoEmail) as? String ?? ""
        param["password"] = userInfo.valueForKey(CConstants.UserInfoPwd) as? String ?? ""
        param["idcontract1"] = self.ContractData?.idcontract ?? ""
        param["initial_licensee"] = getStr(licenseeInitial)
        param["signature_licensee"] = getStr(licenseeSignature)
        param["initial_consultant"] = getStr(consultantInitial)
        param["signature_consultant"] = getStr(consultantSignature)
        param["initial_licenseeyn1"] = initial_licenseeyn1
        param["initial_licenseeyn2"] = initial_licenseeyn2
        param["initial_licenseeyn3"] = initial_licenseeyn3
        param["initial_licenseeyn4"] = initial_licenseeyn4
        param["initial_licenseeyn5"] = initial_licenseeyn5
        param["signature_licenseeyn6"] = signature_licenseeyn6
        param["initial_licenseeyn7"] = initial_licenseeyn7
        param["initial_licenseeyn8"] = initial_licenseeyn8
        param["initial_consultantyn1"] = initial_consultantyn1
        param["initial_consultantyn2"] = initial_consultantyn2
        param["initial_consultantyn3"] = initial_consultantyn3
        param["initial_consultantyn4"] = initial_consultantyn4
        param["initial_consultantyn5"] = initial_consultantyn5
        param["signature_consultantyn6"] = signature_consultantyn6
        param["initial_consultantyn7"] = initial_consultantyn7
        param["initial_consultantyn8"] = initial_consultantyn8
        
        print(param)
        self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //                hud.mode = .AnnularDeterminate
        self.hud?.labelText = CConstants.SavedMsg
        
        Alamofire.request(.POST,
            CConstants.ServerURL + constants.saveToSeverURL,
            parameters: param).responseJSON{ (response) -> Void in
                //                self.hud?.hide(true)
                print(response.result.value)
                var dismissMsg = true
                if response.result.isSuccess {
                    if (response.result.value as? Bool) ?? false {
                        if xtype == 1 {
                            self.hud?.mode = .Text
                            self.hud?.labelText = CConstants.SavedSuccessMsg
                        }else if xtype == 2 {
                            dismissMsg = false
                            self.doUploadContract()
                        }
                        
                        
                    }else{
                        self.hud?.mode = .Text
                        self.hud?.labelText = CConstants.MsgServerError
                    }
                }else{
                    self.hud?.mode = .Text
                    self.hud?.labelText = CConstants.MsgNetworkError
                }
                if dismissMsg {
                    self.performSelector(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), withObject: nil, afterDelay: 0.5)
                }
                
        }
        
    }
    private func doUploadContract(){
        var param = [String :String]()
        let userInfo = NSUserDefaults.standardUserDefaults()
        //        {"filetype":"String","idcontract":"String","username":"String","code":"String","file":"String"}
        param["email"] = userInfo.valueForKey(CConstants.UserInfoEmail) as? String ?? ""
        param["password"] = userInfo.valueForKey(CConstants.UserInfoPwd) as? String ?? ""
        param["idcontract"] = self.ContractData?.idcontract ?? ""
        param["username"] = userInfo.valueForKey(CConstants.UserInfoDisplayName) as? String ?? ""
        var savedPdfData: NSData?
        
        
        if self.documents != nil && self.documents?.count > 0 {
            print(self.documents!.count)
            savedPdfData = PDFDocumentApp.mergedDataWithDocuments(self.documents!)
        }else{
            if let added = pdfView?.addedAnnotationViews{
                //            print(added)
                savedPdfData = document?.savedStaticPDFData(added)
            }else{
                savedPdfData = document?.savedStaticPDFData()
            }
        }
        
//        savedPdfData = document?.savedStaticPDFData()
        
        //        return
        
        let fileBase64String = savedPdfData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        param["file"] = fileBase64String
//        print("fasfasdfasdfasfdsf")
        //        print(param)
        Alamofire.request(.POST,
            CConstants.ServerURL + constants.uploadToServerURL,
            parameters: param).responseJSON{ (response) -> Void in
                //                self.hud?.hide(true)
                print(response.result.value)
                var dismissMsg = true
                if response.result.isSuccess {
                    if let rtn = (response.result.value as? [String: String]) {
                        if rtn["status"] == "success" {
                            dismissMsg = false
                            self.doSubmitContract()
                        }else{
                            self.hud?.mode = .Text
                            self.hud?.labelText = CConstants.MsgServerError
                        }
                    }else{
                        self.hud?.mode = .Text
                        self.hud?.labelText = CConstants.MsgServerError
                    }
                }else{
                    self.hud?.mode = .Text
                    self.hud?.labelText = CConstants.MsgNetworkError
                }
                if dismissMsg {
                    self.performSelector(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), withObject: nil, afterDelay: 0.5)
                }
                
        }
    }
    
    
    private func doSubmitContract(){
        var param = [String :String]()
        let userInfo = NSUserDefaults.standardUserDefaults()
        param["email"] = userInfo.valueForKey(CConstants.UserInfoEmail) as? String ?? ""
        param["password"] = userInfo.valueForKey(CConstants.UserInfoPwd) as? String ?? ""
        param["idcontract"] = self.ContractData?.idcontract ?? ""
//        print(param)
        Alamofire.request(.POST,
            CConstants.ServerURL + constants.submitToSeverURL,
            parameters: param).responseJSON{ (response) -> Void in
                //                self.hud?.hide(true)
             
                if response.result.isSuccess {
//                    print(response.result.value)
                    if ((response.result.value as? NSNumber)?.intValue ?? 0) > 0 {
                        
                        self.hud?.mode = .Text
                        self.hud?.labelText = "Submitted successfully."
                        self.ContractData?.status = "Approved"
                        self.showSkipToNext()
                        
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
    
    func emailContractToLicensee(){
        if self.ContractData!.status == "Draft" && self.ContractData!.signtype == "iPad" {
            self.performSegueWithIdentifier(constants.segueToEmailContractToBuyer, sender: nil)
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
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: "Do you want to submit this contract?", preferredStyle: .Alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
            self.saveToServerStep(2)
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
            
            
            return false
            return contractInfo!.status != CConstants.ForApproveStatus
        default:
            return true
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            if identifier == constants.segueToSendEmailAfterApproved {
                if let con = segue.destinationViewController as? EmailAfterApprovedViewController {
                    con.contractInfo = self.ContractData
                }
            }else if identifier == constants.segueToEmailContractToBuyer {
                if let con = segue.destinationViewController as? EmailContractToBuyerViewController {
                    con.contractInfo = self.ContractData
                    con.delegate = self
                }
                
            
            }else if identifier == "showSkipFile" {
                self.dismissViewControllerAnimated(true, completion: nil)
                if let controller = segue.destinationViewController as? GoToFileViewController {
                    controller.delegate = self
                    controller.printList = ["Venue Licensee Agreemnet", "Exhibit A", "Exhibit B"]
                }
            }else if identifier == "showAttachPhoto" {
                if let controller = segue.destinationViewController as? BigPictureViewController{
                    controller.imageUrl = NSURL(string: CConstants.ServerURL + "bacontract_photoCheck.json?ContractID=" + (self.contractInfo?.idnumber ?? ""))
                    //                    controller.contractPdfInfo = self.contractPdfInfo
                    
                    //                    print(CConstants.ServerURL + "bacontract_photoCheck.json?ContractID=" + (self.contractInfo?.idnumber ?? ""))
                }
                
            }else if identifier == constants.segueToEmailContract {
                if let controller = segue.destinationViewController as? SaveAndEmailViewController {
                    if let contrat = self.ContractData {
                        controller.delegate = self
                        controller.xtitle = "Send Email"
                        controller.xtitle2 = "Venue Event # \(contrat.idvenueevent ?? "") ~ \(contrat.eventName ?? "" )"
                        var emailList : [String] = [String]()
                        if let email1 = contrat.licenseeEmail {
                            emailList.append(email1)
                        }
                        if let email1 = contrat.consultantemail {
                            emailList.append(email1)
                        }
//                        emailList.append("phalycak@kirbytitle.com")
//                        emailList.append("heatherb@kirbytitle.com")
                        
                        controller.xemailList = emailList
                        let userInfo = NSUserDefaults.standardUserDefaults()
                        let email = userInfo.valueForKey(CConstants.UserInfoEmail) as? String
                        
                        controller.xemailcc = email ?? ""
                        controller.xdes = "This is the contract of your venue event."
                    }
                }
            }else{
                if let identifier = segue.identifier {
                    switch identifier {
                    case CConstants.SegueToOperationsPopover:
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        if let tvc = segue.destinationViewController as? SendOperationViewController {
                            if let ppc = tvc.popoverPresentationController {
                                tvc.contractInfo = self.ContractData
                                if self.ContractData?.status == CConstants.DraftStatus {
                                    if self.ContractData!.signtype == "iPad" {
                                        let tl = toolpdf()
                                        if self.ContractData!.licenseeSignFinishedYn!.boolValue {
                                            tvc.showSave = true
                                            tvc.showStartOver = true
                                            tvc.showSubmit = true
                                            tvc.enableSave = tl.hasConsultantSign(self.dotsss)
                                            tvc.enableStartOver = tvc.enableSave
                                            tvc.enableSubmit = tl.CheckConsultantFinish(self.dotsss).0
                                            tvc.showEmailToLicensee = false
                                        }else{
                                            tvc.showSave = true
                                            tvc.showStartOver = true
                                            tvc.showSubmit = true
                                            
                                            tvc.enableSave = tl.hasLicenseeSign(self.dotsss) || tl.hasConsultantSign(self.dotsss)
                                            tvc.enableStartOver = tvc.enableSave
                                            tvc.enableSubmit = tl.CheckLicenseeFinish(self.dotsss).0 && tl.CheckConsultantFinish(self.dotsss).0
                                            //                                        print(tvc.enableSubmit, tl.CheckLicenseeFinish(self.dotsss).0, tl.CheckConsultantFinish(self.dotsss).0)
                                            tvc.showEmailToLicensee = true
                                        }
                                    }else if self.ContractData!.signtype == "Email"{
                                        let tl = toolpdf()
                                        if !self.ContractData!.licenseeSignFinishedYn!.boolValue {
                                            
                                            tvc.showSave = false
                                            tvc.showStartOver = false
                                            tvc.showSubmit = false
                                            
                                            
                                            tvc.showChangeToIPad = true
                                        }
                                    
                                    }
                                    
                                    
                                    
                                }
                                
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
        
        let a = ["idcontract":(ContractData?.idcontract ?? "")
            ,"EmailTo":email
            ,"EmailCc":emailcc
            ,"Subject":"\((ContractData?.eventName ?? ""))'s Contract"
            ,"Body":msg
            
            ,"consultantemail": userInfo.stringForKey(CConstants.UserInfoEmail) ?? ""
            , "consultantname": userInfo.stringForKey(CConstants.UserInfoName) ?? ""]
    
//        let a = ["idcontract":(ContractData?.idcontract ?? "")
//            ,"EmailTo" : "april@buildersaccess.com"
//            ,"EmailCc" : "april@buildersaccess.com"
//            ,"Subject" : "\((ContractData?.eventName ?? ""))'s Contract"
//            ,"Body" : msg
//            
//            ,"consultantemail" : userInfo.stringForKey(CConstants.UserInfoEmail) ?? ""
//            , "consultantname" : userInfo.stringForKey(CConstants.UserInfoName) ?? ""]
        
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
                print(a)
    
        Alamofire.request(.POST,
            CConstants.ServerURL + "bavenue_SendFinishedContract.json",
            parameters:a).responseJSON{ (response) -> Void in
                //                self.emailData = nil
                                 print(response.result.value)
                //                print(rtnValue)
                if response.result.isSuccess {
                    if let rtnValue = response.result.value as? Bool{
//                        print
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
            // ["Venue Licensee Agreemnet", "Exhibit A", "Exhibit B"]
            if filenm == "Exhibit A" {
                pageCnt += 6
            }else if filenm == "Exhibit B" {
                pageCnt += 7
            }
        }
        
        let t = 8
        
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
    
    
    
    override func gotoSellerSign() {
        let tp = toolpdf()
        let (t, sign) =  tp.CheckConsultantFinish(self.dotsss)
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
    
    func gotoBuyerSign() {
        let tp = toolpdf()
        let (t, sign) =  tp.CheckLicenseeFinish(self.dotsss)
        //        print(sign?.xname)
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
    
    
    func GoToSendEmailToLicensee(msg msg: String) {
//        let param = ["idcontract":"\(self.ContractData?.idcontract ?? "")"
//            ,"consultantemail":"\(self.ContractData?.consultantemail ?? "")"
//            , "consultantname":"\(self.ContractData?.licensor ?? "")"
//            ,"licenseeemail":"april@buildersaccess.com"
//            ,"licenseeename":"April for Test"
//            ,"emailcc":""
//            ,"emailbody":"\(msg)"
//            ,"emailsubject":"Sign contract online"]
        
                let param = ["idcontract":"\(self.ContractData?.idcontract ?? "")"
                    ,"consultantemail":"\(self.ContractData?.consultantemail ?? "")"
                    , "consultantname":"\(self.ContractData?.licensor ?? "")"
                    ,"licenseeemail":"\(self.ContractData?.licenseeEmail ?? "")"
                    ,"licenseeename":"\(self.ContractData?.licensee ?? "")"
                    ,"emailcc":""
                    ,"emailbody":"\(msg)"
                    ,"emailsubject":"Sign contract online"]
        print(param)
        //    return
        self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //                hud.mode = .AnnularDeterminate
        self.hud?.labelText = CConstants.EmailContractToLicensee
        Alamofire.request(.POST,
            CConstants.ServerURL + constants.emailToLicenseeServerURL,
            parameters: param).responseJSON{ (response) -> Void in
                
                //                print(param)
                if response.result.isSuccess {
                    //                    print(response.result.value)
                    
                    if let a = response.result.value as? Bool {
                        if a {
                            self.ContractData?.signtype = "Email"
                            self.ContractData?.emailsignverifycode = "aaa"
                            self.showSkipToNext()
                            self.hud?.mode = .CustomView
                            let image = UIImage(named: CConstants.SuccessImageNm)
                            self.hud?.customView = UIImageView(image: image)
                            
                            self.hud?.labelText = CConstants.SendEmailSuccessfullMsg
                            self.performSelector(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), withObject: nil, afterDelay: 0.5)
                        }else{
                            self.hud?.hide(true)
                            self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                        }
                    }else{
                        self.hud?.hide(true)
                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                    }
                }else{
                    self.hud?.hide(true)
                    self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                }
        }
    }
    
    func changeLicenseeToIpad() {
        let userInfo = NSUserDefaults.standardUserDefaults()
        let email = userInfo.valueForKey(CConstants.UserInfoEmail) as? String ?? ""
        let password = userInfo.valueForKey(CConstants.UserInfoPwd) as? String ?? ""
        
        let param = ["email" : email
            ,"password" : password
            , "idcontract": self.ContractData?.idcontract ?? ""
            ]
        
        //        let param = ["idcontract":"\(self.ContractData?.idcontract ?? "")"
        //            ,"consultantemail":"\(self.ContractData?.consultantemail ?? "")"
        //            , "consultantname":"\(self.ContractData?.licensor ?? "")"
        //            ,"licenseeemail":"\(self.ContractData?.licenseeEmail ?? "")"
        //            ,"licenseeename":"\(self.ContractData?.licensee ?? "")"
        //            ,"emailcc":""
        //            ,"emailbody":"\(msg)"
        //            ,"emailsubject":"Sign contract online"]
        print(param)
        //    return
        self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //                hud.mode = .AnnularDeterminate
        self.hud?.labelText = CConstants.SubmitMsg
        Alamofire.request(.POST,
            CConstants.ServerURL + constants.changeLicenseeToIPadServerURL,
            parameters: param).responseJSON{ (response) -> Void in
                
                //                print(param)
                if response.result.isSuccess {
                    //                    print(response.result.value)
                    
                    if let a = response.result.value as? Bool {
                        if a {
                            self.ContractData?.signtype = "iPad"
                            self.ContractData?.emailsignverifycode = "aaa"
                            self.showSkipToNext()
                            
                            self.hud?.mode = .CustomView
                            let image = UIImage(named: CConstants.SuccessImageNm)
                            self.hud?.customView = UIImageView(image: image)
                            
                            self.hud?.labelText = CConstants.SubmitedMsg
                            self.performSelector(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), withObject: nil, afterDelay: 0.5)
                        }else{
                            self.hud?.hide(true)
                            self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                        }
                    }else{
                        self.hud?.hide(true)
                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                    }
                }else{
                    self.hud?.hide(true)
                    self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                }
        }
    }
    
}












//    {"idcontract":"String","buyer1email":"String","buyer2email":"String","idcity":"String","idcia":"String","emailcc":"String","buyer1name":"String","buyer2name":"String","emailbody":"String","emailsubject":"String"}



