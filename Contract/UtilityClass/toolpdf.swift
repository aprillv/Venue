//
//  toolpdf.swift
//  Contract
//
//  Created by April on 4/26/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import Foundation

class toolpdf: NSObject {
    
    
    private let LicenseeField = ["p1bottom1",
                "p2bottom1",
                "p3bottom1",
                "p4bottom1",
                "p5bottom1",
                "licenseeSign",
                "p7bottom1",
                "p8bottom1"]
    
    
    private let ConsultatnField = ["p1bottom3",
                                   "p2bottom3",
                                   "p3bottom3",
                                   "p4bottom3",
                                   "p5bottom3",
                                   "sellerSign",
                                   "p7bottom3",
                                   "p8bottom3"]
    
     func isBuyer1Sign(sign : SignatureView) -> Bool{
        return self.LicenseeField.contains(sign.xname)
    }
    
     func isSellerSign(sign : SignatureView) -> Bool{
        return ConsultatnField.contains(sign.xname)
    }
    
    func hasLicenseeSign( fileDotsDic :  [PDFWidgetAnnotationView]?) -> Bool {
        
        
        for c in fileDotsDic! {
            if let a = c as? SignatureView {
                if LicenseeField.contains(a.xname) {
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0){
                        return true
                    }
                    
                    
                }
            }
        }
        return false
    }
    
    func getLicenseeInitial( fileDotsDic :  [PDFWidgetAnnotationView]?) -> SignatureView? {
        
        
        for c in fileDotsDic! {
            if let a = c as? SignatureView {
                if LicenseeField.contains(a.xname) && a.xname != "licenseeSign" {
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0){
                        return a
                    }
                    
                    
                }
            }
        }
        return nil
    }
    
    func getLicenseeSignature( fileDotsDic :  [PDFWidgetAnnotationView]?) -> SignatureView? {
        
        
        for c in fileDotsDic! {
            if let a = c as? SignatureView {
                if a.xname == "licenseeSign" {
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0){
                        return a
                    }else{
                        return nil
                    }
                }
            }
        }
        return nil
    }
    
    func getConsultantInitial( fileDotsDic :  [PDFWidgetAnnotationView]?) -> SignatureView? {
        
        
        for c in fileDotsDic! {
            if let a = c as? SignatureView {
                if ConsultatnField.contains(a.xname) && a.xname != "sellerSign" {
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0){
                        return a
                    }
                    
                    
                }
            }
        }
        return nil
    }
    
    func getConsultantSignature( fileDotsDic :  [PDFWidgetAnnotationView]?) -> SignatureView? {
        
        
        for c in fileDotsDic! {
            if let a = c as? SignatureView {
                if a.xname == "sellerSign" {
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0){
                        return a
                    }else{
                        return nil
                    }
                }
            }
        }
        return nil
    }
    
    
    func hasConsultantSign( fileDotsDic :  [PDFWidgetAnnotationView]?) -> Bool {
        
        
        for c in fileDotsDic! {
            if let a = c as? SignatureView {
                if ConsultatnField.contains(a.xname) {
                    if (a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0){
                        return true
                    }
                    
                    
                }
            }
        }
        return false
    }
    
    
    func CheckLicenseeFinish( fileDotsDic :  [PDFWidgetAnnotationView]?) -> (Bool, SignatureView?) {
        
        
        for c in fileDotsDic! {
            if let a = c as? SignatureView {
                if LicenseeField.contains(a.xname) {
                    if !(a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0){
                        return (false, a)
                    } 
                }
            }
        }
        return (true, nil)
    }
    
    func CheckConsultantFinish( fileDotsDic : [PDFWidgetAnnotationView]?) -> (Bool, SignatureView?) {
        for c in fileDotsDic! {
            if let a = c as? SignatureView {
                print(a.xname)
                if ConsultatnField.contains(a.xname) {
                    if !(a.lineArray != nil && a.lineArray.count > 0 && a.LineWidth != 0.0){
                        return (false, a)
                    }
                    
                    
                }
            }
        }
        return (true, nil)
    }
    
    func clearLicenseeSign(fileDotsDic : [PDFWidgetAnnotationView]?, viewa: UIView) {
        for c in fileDotsDic! {
            if let a = c as? SignatureView {
                if LicenseeField.contains(a.xname) {
                    a.lineArray = nil
                    a.LineWidth = 0
                    a.showornot = true
                    if a.menubtn != nil {
                        a.superview?.addSubview(a.menubtn)
                    }else{
                        a.addSignautre(viewa)
                    }
                }
            }
        }
    }
    
    func clearAllSign(fileDotsDic : [PDFWidgetAnnotationView]?, viewa: UIView) {
        for c in fileDotsDic! {
            if let a = c as? SignatureView {
                a.lineArray = nil
                a.LineWidth = 0
                a.showornot = true
                if a.menubtn != nil {
                    a.superview?.addSubview(a.menubtn)
                }else{
                    a.addSignautre(viewa)
                }
            }
        }
    }
    
    
}
