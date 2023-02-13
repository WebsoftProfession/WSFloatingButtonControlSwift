//
//  WSFloatingOptionView.swift
//  WSFloatingOptionsControl
//
//  Created by WebsoftProfession on 10/02/23.
//

import UIKit

struct ShadowPath {
    var alphaValue: Double
    var path: UIBezierPath
}

struct PositionPath {
    var position: CGRect
    var path: UIBezierPath
}


class WSFloatingOptionView: WSFloatingControl {
    
    private var outlineAreaPath: UIBezierPath!
    var options = [WSFloatingOption]()
    var paths = [PositionPath]()
    private var backgroundPaths = [ShadowPath]()
    
    private var shouldDrawBackground = false
    private var isReverse = false
    private var timer: Timer?
    
    private var activeArcRadius = 0.0
    
//    var radiousColor: UIColor = .black
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        if !shouldDrawBackground || isReverse {
            outlineAreaPath = UIBezierPath()
        }
        
        if shouldDrawBackground {
            if isReverse {
                backgroundPaths.removeLast()
                for path in backgroundPaths {
//                    UIColor.init(red: 245.0/255, green: 114.0/255, blue: 51.0/255, alpha:path.alphaValue == 0 ? 0.005 : path.alphaValue).setStroke()
                    radiousColor.withAlphaComponent(path.alphaValue == 0 ? 0.005 : path.alphaValue).setStroke()
                    path.path.stroke()
                }
                return
            }
            
            let outlineAreaPath1 = UIBezierPath.init()
            outlineAreaPath1.addArc(withCenter: CGPoint.init(x: rect.midX, y: rect.maxY), radius: activeArcRadius, startAngle: self.calculateRadious(withValue: 0), endAngle: self.calculateRadious(withValue: -50), clockwise: false)
            
            
            var alphaRatio =  activeArcRadius / (rect.width / (isReverse ? 1.5 : 1.9))
            alphaRatio = 0.9-alphaRatio
            UIColor.init(red: 0, green: 0, blue: 0, alpha:alphaRatio == 0 ? 0.05 : alphaRatio).setStroke()
            outlineAreaPath1.lineWidth = isReverse ? activeArcRadius : 1
            
            backgroundPaths.append(ShadowPath.init(alphaValue: alphaRatio, path: outlineAreaPath1))
            
            for path in backgroundPaths {
                radiousColor.withAlphaComponent(path.alphaValue == 0 ? 0.005 : path.alphaValue).setStroke()
                path.path.stroke()
            }
            return
        }
        
        
        paths = [PositionPath]()
        
        
        var prevValue = 0.0
        
        self.subviews.forEach({$0.removeFromSuperview()})
        
        for view in self.options {
            view.edgeInset = .init(top: 0, left: 15, bottom: 15, right: 15)
//            view.frame = CGRect.init(x: 0, y: self.frame.midY, width: 60, height: 70)
            view.isHidden = true
            self.addSubview(view)
        }
        
        for i in 0..<options.count {
            
            var rightNumberOfOptions = options.count / 2
            let arcPath = UIBezierPath()
            if options.count % 2 != 0 {
                rightNumberOfOptions += 1
            }
            
            
            if i < rightNumberOfOptions {
                let endPoint = (50.0 / CGFloat(options.count)) * CGFloat(i+1)
                let centerPoint = CGPoint.init(x: rect.midX, y: rect.maxY)
                let centerValue = CGFloat((prevValue + endPoint)/2 * -1)
                arcPath.addArc(withCenter: centerPoint, radius: rect.width / 2.5, startAngle: self.calculateRadious(withValue: 0), endAngle: self.calculateRadious(withValue: centerValue), clockwise: false)
                prevValue = endPoint
            }
            else{
                let endPoint = (50.0 / CGFloat(options.count)) * CGFloat(i+1)
                let centerPoint = CGPoint.init(x: rect.midX, y: rect.maxY)
                var centerValue = CGFloat((prevValue + endPoint)/2)
                centerValue = 50 + 50 - centerValue
                arcPath.addArc(withCenter: centerPoint, radius: rect.width / 2.5, startAngle: self.calculateRadious(withValue: 50), endAngle: self.calculateRadious(withValue: centerValue), clockwise: true)
                prevValue = endPoint
            }
            
//            arcPath.lineWidth = 5 - CGFloat(i*2)
            UIColor.clear.setStroke()
            
            arcPath.stroke()
            
            let positionRect = CGRect.init(x: arcPath.currentPoint.x - CGFloat(options[i].width / 2), y: arcPath.currentPoint.y - CGFloat(options[i].width / 2), width: CGFloat(options[i].width), height: CGFloat(options[i].width))
            
            paths.append(PositionPath.init(position: positionRect, path: arcPath))
            
        }
    }
    
    func calculateRadious(withValue value: CGFloat) -> CGFloat {
        let pieValue: CGFloat = .pi
        let redious = (value * 2 * pieValue) / 100
        return redious
    }
    
    func getMidPointOfArc(withStartValue startValue: Float, andEndValue endValue: Float, andCenter centerPoint: CGPoint, andRadious radious: CGFloat) -> CGPoint {
        let new = UIBezierPath()
        let midValue = fabsf((endValue - startValue) / 2) + startValue
        new.addArc(withCenter: centerPoint, radius: radious, startAngle: calculateRadious(withValue: CGFloat(startValue)), endAngle: calculateRadious(withValue: CGFloat(midValue)), clockwise: false)
        var endPoint = CGPoint.zero
        endPoint = new.cgPath.currentPoint
        return endPoint
    }
    
    func drawBackground(isDraw: Bool){
        self.isReverse = !isDraw
        
        if isReverse {
            activeArcRadius = activeArcRadius / 1.5
        }
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(runAnimation), userInfo: nil, repeats: true)
    }
    
    @objc private func runAnimation(){
        
        self.shouldDrawBackground = true
        
        var value = self.frame.width/2
        
        if isReverse {
            value = 0
            if backgroundPaths.count != 0  {
                activeArcRadius -= 1
                self.setNeedsDisplay()
            }
            else{
                timer?.invalidate()
                activeArcRadius = 0
                self.shouldDrawBackground = false
            }
        }
        else{
            if activeArcRadius < value {
                activeArcRadius += 1
                self.setNeedsDisplay()
            }
            else{
                timer?.invalidate()
                self.shouldDrawBackground = false
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
  
        if paths.count == options.count {
            for i in 0..<paths.count {
                if paths[i].position.contains(location) {
//                    self.delegate?.floatingOptionDidTapped(option: options[i])
                    UIView.animate(withDuration: 0.1,
                        animations: {
                        self.options[i].transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        },
                        completion: { _ in
                            UIView.animate(withDuration: 0.1) {
                                self.options[i].transform = CGAffineTransform.identity
                                self.delegate?.floatingOptionDidTapped(option: self.options[i])
                            }
                        })
                    
                }
            }
        }
    }
    
}
