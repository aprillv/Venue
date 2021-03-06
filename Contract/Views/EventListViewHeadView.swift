//
//  AddressListViewHeadView.swift
//  Contract
//
//  Created by April on 11/23/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit

class EventListViewHeadView: UIView {
    
    var CiaNmLbl: UILabel!
    
    private var ProjectNmLbl: UILabel!
    private var ConsultantLbl: UILabel!
    private var ClientLbl: UILabel!
    private var StatusLbl: UILabel!
    private var Status2Lbl: UILabel!
    
    private struct constants{
        static let ProjectNM = "Event Name"
        static let Consultant = "Buyer"
        static let Client = "Venue Name"
        static let Status = "Contract Date"
        static let Status2 = "Status"
        static let HeadBackGroudColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = CConstants.BackColor
        
        CiaNmLbl = UILabel()
        self.addSubview(CiaNmLbl)
        CiaNmLbl.font = UIFont.boldSystemFontOfSize(17)
        CiaNmLbl.textAlignment = NSTextAlignment.Left
        
        ProjectNmLbl = UILabel()
        addSubview(ProjectNmLbl)
        ProjectNmLbl.textAlignment = .Left
        ProjectNmLbl.text = constants.ProjectNM
        ProjectNmLbl.font = UIFont.boldSystemFontOfSize(16)
        
        ConsultantLbl = UILabel()
        addSubview(ConsultantLbl)
        ConsultantLbl.text = constants.Consultant
        ConsultantLbl.textAlignment = .Left
        ConsultantLbl.font = UIFont.boldSystemFontOfSize(16)
        
        ClientLbl = UILabel()
        addSubview(ClientLbl)
        ClientLbl.textAlignment = .Left
        ClientLbl.text = constants.Client
        ClientLbl.font = UIFont.boldSystemFontOfSize(16)
        
        StatusLbl = UILabel()
        addSubview(StatusLbl)
        StatusLbl.textAlignment = .Left
        StatusLbl.text = constants.Status
        StatusLbl.font = UIFont.boldSystemFontOfSize(16)
        
        Status2Lbl = UILabel()
        addSubview(Status2Lbl)
        Status2Lbl.textAlignment = .Left
        Status2Lbl.text = constants.Status2
        Status2Lbl.font = UIFont.boldSystemFontOfSize(16)

        
        
        setDisplaySubViews()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setDisplaySubViews()
    }
    
   
    
     
    
    func setDisplaySubViews(){
        
          CiaNmLbl.frame = CGRect(x: 8, y: 0, width: frame.width-16, height: frame.height * 0.5)
        
        
        let space : CGFloat = 10.0
        
        let xheight = frame.height * 0.5
        let xy = CiaNmLbl.frame.height/2.0
        
        let xwidth = frame.width - space * 3 - 16
        ProjectNmLbl.frame  = CGRect(x: 8, y: xy, width: xwidth * 0.32, height: xheight)
        
        
        
        ClientLbl.frame  = CGRect(x: ProjectNmLbl.frame.origin.x + ProjectNmLbl.frame.width + space, y: xy, width: xwidth * 0.22, height: xheight)
        
        ConsultantLbl.frame  = CGRect(x: ClientLbl.frame.origin.x + ClientLbl.frame.width + space, y: xy, width: xwidth * 0.16, height: xheight)
        StatusLbl.frame  = CGRect(x: ConsultantLbl.frame.origin.x + ConsultantLbl.frame.width + space, y: xy, width: xwidth * 0.16, height: xheight)
        Status2Lbl.frame  = CGRect(x: StatusLbl.frame.origin.x + StatusLbl.frame.width + space, y: xy, width: xwidth * 0.14, height: xheight)
    }
    
}
