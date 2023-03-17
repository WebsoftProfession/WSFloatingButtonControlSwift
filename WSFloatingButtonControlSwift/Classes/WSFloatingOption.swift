//
//  WSFloatingOption.swift
//  WSFloatingOptionsControl
//
//  Created by WebsoftProfession on 10/02/23.
//

import UIKit

public class WSFloatingOption: UIView {

    public let id = UUID()
    public var title: String = ""
    public var image: String = ""
    var width: Int = 60
    var edgeInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 10, right: 10)
    var font: UIFont
    var titleColor: UIColor
    
    private var imgView: UIImageView?
    private var lblTitle: UILabel?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    public override func draw(_ rect: CGRect) {
        // Drawing code
        
        
        if imgView == nil {
            imgView = UIImageView.init(image: UIImage.init(named: image))
            imgView?.frame = rect.inset(by: edgeInset)
            imgView?.contentMode = .scaleAspectFit
            
            
            lblTitle = UILabel.init()
            lblTitle?.textAlignment = .center
            lblTitle?.frame = CGRect.init(x: 0, y: 0, width: width, height: width)
            lblTitle?.textColor = .black
            lblTitle?.text = title
            lblTitle?.font = font
            lblTitle?.center = CGPoint.init(x: imgView?.frame.midX ?? 0, y: imgView?.frame.maxY ?? 0)
            
            self.addSubview(imgView!)
            self.addSubview(lblTitle!)
            self.imgView?.isUserInteractionEnabled = true
        }
        
    }
    
    public init(width: Int, title:String, image:String, font:UIFont = UIFont.systemFont(ofSize: 12), titleColor: UIColor = .black) {
        self.font = font
        self.title = title
        self.image = image
        self.width = width
        self.titleColor = titleColor
        super.init(frame: CGRect.init(x: 0, y: 0, width: width, height: width))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func optionTapped(sender: UIButton) {
        UIView.animate(withDuration: 0.1,
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.transform = CGAffineTransform.identity
                }
            })
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

}
