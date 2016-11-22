//
//  ContractListCell.swift
//  Venue
//
//  Created by April on 11/3/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit

class ContractListCell: UITableViewCell {
    
    private var EventNmLbl: UILabel!
    private var VenueNmLbl: UILabel!
    private var StartLbl: UILabel!
    private var EndLbl: UILabel!
    private var StatusLbl: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let v = UIView()
        self.contentView.addSubview(v)
        v.backgroundColor = CConstants.BorderColor
        let leadingConstraint = NSLayoutConstraint(item:v,
                                                   attribute: .LeadingMargin,
                                                   relatedBy: .Equal,
                                                   toItem: self.contentView,
                                                   attribute: .LeadingMargin,
                                                   multiplier: 1.0,
                                                   constant: 0);
        let trailingConstraint = NSLayoutConstraint(item:v,
                                                    attribute: .TrailingMargin,
                                                    relatedBy: .Equal,
                                                    toItem: self.contentView,
                                                    attribute: .TrailingMargin,
                                                    multiplier: 1.0,
                                                    constant: 0);
        
        let bottomConstraint = NSLayoutConstraint(item: v,
                                                  attribute: .BottomMargin,
                                                  relatedBy: .Equal,
                                                  toItem: self.contentView,
                                                  attribute: .BottomMargin,
                                                  multiplier: 1.0,
                                                  constant: 0);
        
        let heightContraint = NSLayoutConstraint(item: v,
                                                 attribute: .Height,
                                                 relatedBy: .Equal,
                                                 toItem: nil,
                                                 attribute: .NotAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: 1.0 / (UIScreen.mainScreen().scale));
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([leadingConstraint, trailingConstraint, bottomConstraint, heightContraint])
    }
    
    @IBOutlet weak var cview: UIView!{
        didSet{
            
            EventNmLbl = UILabel()
            cview.addSubview(EventNmLbl)
            
            VenueNmLbl = UILabel()
            //            ConsultantLbl.textAlignment = NSTextAlignment.Left
            cview.addSubview(VenueNmLbl)
            
            StartLbl = UILabel()
            cview.addSubview(StartLbl)
            
            EndLbl = UILabel()
            cview.addSubview(EndLbl)
            
            StatusLbl = UILabel()
            cview.addSubview(StatusLbl)
            
            setDisplaySubViews()
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setDisplaySubViews()
    }
    
    func setDisplaySubViews(){
        
        let space : CGFloat = 10.0
        
        let xheight = frame.height
        let xwidth = frame.width - space * 3 - 16
        EventNmLbl.frame  = CGRect(x: 8, y: 0, width: xwidth * 0.32, height: xheight)
        VenueNmLbl.frame  = CGRect(x: EventNmLbl.frame.origin.x + EventNmLbl.frame.width + space, y: 0, width: xwidth * 0.22, height: xheight)
        StartLbl.frame  = CGRect(x: VenueNmLbl.frame.origin.x + VenueNmLbl.frame.width + space, y: 0, width: xwidth * 0.16, height: xheight)
        EndLbl.frame  = CGRect(x: StartLbl.frame.origin.x + StartLbl.frame.width + space, y: 0, width: xwidth * 0.16, height: xheight)
        StatusLbl.frame  = CGRect(x: EndLbl.frame.origin.x + EndLbl.frame.width + space, y: 0, width: xwidth * 0.14, height: xheight)
        
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        self.setCellBackColor(highlighted)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.setCellBackColor(selected)
    }
    
    private func setCellBackColor(sels: Bool){
        if sels {
            self.backgroundColor = CConstants.SearchBarBackColor
            self.contentView.backgroundColor = CConstants.SearchBarBackColor
        }else{
            self.backgroundColor = UIColor.whiteColor()
            self.contentView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    
    
    var contractInfo: VenueContractListItem? {
        didSet{
            if let item = contractInfo{
                EventNmLbl.text = item.eventname
                StartLbl.text = item.buyer
                VenueNmLbl.text = item.venuename
                EndLbl.text = item.contractdate
                if item.status == "Draft" && item.signtype == "iPad" {
                StatusLbl.text = "iPad Sign"
                }else if item.status == "Draft" && item.signtype == "Email" {
                    StatusLbl.text = "Email Sign"
                }else{
                    StatusLbl.text = item.status
                }
            }
        }
    }
}

