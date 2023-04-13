//
//  WSFloatingControl.swift
//  WSFloatingOptionsControl
//
//  Created by WebsoftProfession on 10/02/23.
//

import UIKit


public protocol WSFloatingButtonDelegate {
    func floatingButtonDidToggle(isOpened: Bool)
    func floatingOptionDidTapped(option: WSFloatingOption)
    func viewsForFloatingButtonOptions() -> [WSFloatingOption]
}


public class WSFloatingControl: UIView {
    
    private var optionView: WSFloatingOptionView?
    private var imgView: UIImageView!
    private var isShowOption = false
    
    public var increaseRadiusSpeedBy: Double = 0.0
    public var delegate: WSFloatingButtonDelegate?
    public var radiousColor: UIColor = UIColor.init(red: 245.0/255, green: 114.0/255, blue: 51.0/255, alpha:1.0)
    public var image: String = ""
    public var edgeInset = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    public override func draw(_ rect: CGRect) {
        // Drawing code
        
        self.clipsToBounds = true
        self.layer.cornerRadius = rect.width / 2
        if imgView == nil {
            
            if image.isEmpty {
                if #available(iOS 13.0, *) {
                    imgView = UIImageView.init(image: UIImage.init(systemName:  "plus"))
                } else {
                    // Fallback on earlier versions
                }
            }
            else{
                imgView = UIImageView.init(image: UIImage.init(named: image))
            }
            imgView.contentMode = .scaleAspectFit
            imgView.tintColor = .white
            imgView.frame = rect.inset(by: edgeInset)
            self.addSubview(imgView)
        }
        
        if self.optionView == nil {
            self.optionView = WSFloatingOptionView.init(frame: CGRect.init(x: 0, y: 0, width: rect.width * 4, height: rect.height * 2))
            self.optionView?.backgroundColor = .clear
            self.optionView?.center = CGPoint.init(x: self.center.x, y: self.center.y - rect.height)
            self.optionView?.radiousColor = self.radiousColor
            self.optionView?.delegate = self.delegate
            self.optionView?.radiusSpeedBy = self.increaseRadiusSpeedBy
            self.optionView?.options = self.delegate?.viewsForFloatingButtonOptions() ?? []
            self.superview?.addSubview(self.optionView!)
            self.superview?.bringSubviewToFront(self)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.optionView!.isRunning {
            return
        }
        
        if !isShowOption {
            self.optionView?.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.imgView.transform = CGAffineTransform.init(rotationAngle: .pi/4)
            }, completion: { _ in
                self.isShowOption = true
                self.delegate?.floatingButtonDidToggle(isOpened: self.isShowOption)
            })
            for i in 0..<self.optionView!.options.count {
                
                let view = self.optionView!.options[i]
                
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    
                })
                view.isHidden = false
                if let path = self.optionView?.paths[i] {
                    let animation = CAKeyframeAnimation(keyPath: "position")
                    animation.path = path.path.cgPath
                    animation.fillMode = .forwards
                    animation.isRemovedOnCompletion = false
                    animation.repeatCount = 0
                    animation.duration = 0.5 // However long you want
                    animation.speed = 2  // However fast you want
                    animation.calculationMode = .paced
                    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                    view.layer.add(animation, forKey: "moveAlongPath")
                }
                CATransaction.commit()
            }
            self.optionView?.drawBackground(isDraw: true)
            
        }
        else{
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.imgView.transform = .identity
            }, completion: { _ in
                self.isShowOption = false
                self.delegate?.floatingButtonDidToggle(isOpened: self.isShowOption)
            })
            
            for i in 0..<self.optionView!.options.count {
                let view = self.optionView!.options[i]
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    self.optionView?.isHidden = true
                })
                
                if let path = self.optionView?.paths[i] {
                    let animation = CAKeyframeAnimation(keyPath: "position")
                    animation.path = path.path.reversing().cgPath
                    animation.fillMode = .forwards
                    animation.isRemovedOnCompletion = false
                    animation.repeatCount = 0
                    animation.duration = 0.5 // However long you want
                    animation.speed = 2  // However fast you want
                    animation.calculationMode = .paced
                    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                    view.layer.add(animation, forKey: "moveAlongPathReverse")
                }
                CATransaction.commit()
            }
            self.optionView?.drawBackground(isDraw: false)
            
            
        }
        
    }
    
    func handleOptionTap(option: WSFloatingOption){
        self.delegate?.floatingOptionDidTapped(option: option)
    }
}
