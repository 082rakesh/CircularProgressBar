//
//  CircularProgressBar.swift
//  CircularProgressBar
//
//  Created by r.f.kumar.mishra on 27/02/19.
//  Copyright © 2019 r.f.kumar.mishra. All rights reserved.
//

import UIKit


@IBDesignable class RMCircularProgressBar: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        label.text = "0"
    }
    
    //MARK: Public
    
    @IBInspectable var lineWidth:CGFloat = 10 {
        didSet{
            foregroundLayer.lineWidth = lineWidth
            backgroundLayer.lineWidth = lineWidth - (0.20 * lineWidth)
        }
    }
    
    @IBInspectable var labelSize: CGFloat = 10 {
        didSet {
            label.font = UIFont.systemFont(ofSize: labelSize)
            configLabel()
        }
    }
    
    @IBInspectable var safePercent: Int = 100 {
        didSet{
            setForegroundLayerColorForSafePercent()
        }
    }
    
    @IBInspectable var innerRingColor: UIColor = .darkGray{
        didSet {
            self.backgroundLayer.strokeColor = innerRingColor.cgColor
        }
    }
    
    @IBInspectable var outerRingColor: UIColor = .red {
        didSet {
            self.foregroundLayer.strokeColor = outerRingColor.cgColor
            self.foregroundLayer.fillColor = outerRingColor.cgColor
        }
    }
    
    @IBInspectable var backgroundRingColor: UIColor = .white {
        didSet {
            self.backgroundLayer.fillColor = backgroundRingColor.cgColor
        }
    }
    
    // MARK: Private methods and variables
    private var value: CGFloat = 0.0
    private var label = UILabel()
    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private var radius: CGFloat {
        get{
            if self.frame.width < self.frame.height { return (self.frame.width - lineWidth)/2 }
            else { return (self.frame.height - lineWidth)/2 }
        }
    }
    
    private var pathCenter: CGPoint{ get{ return self.convert(self.center, from:self.superview) } }
    private func makeBar(){
        self.layer.sublayers = nil
        drawBackgroundLayer()
        drawForegroundLayer()
    }
    
    private func drawBackgroundLayer(){
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        self.backgroundLayer.path = path.cgPath
        self.backgroundLayer.strokeColor = innerRingColor.cgColor
        self.backgroundLayer.lineWidth = lineWidth - (lineWidth * 20/100)
        self.backgroundLayer.fillColor = backgroundRingColor.cgColor
        self.layer.addSublayer(backgroundLayer)
        
    }
    
    private func drawForegroundLayer(){
        
        let startAngle = (-CGFloat.pi/2)
        let endAngle = 2 * CGFloat.pi + startAngle
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        foregroundLayer.lineCap = CAShapeLayerLineCap.round
        foregroundLayer.path = path.cgPath
        foregroundLayer.lineWidth = lineWidth
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.strokeColor = outerRingColor.cgColor
        foregroundLayer.strokeEnd = 0
        
        self.layer.addSublayer(foregroundLayer)
        
    }
    
    private func makeLabel(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = text
        label.font = UIFont.systemFont(ofSize: labelSize)
        label.sizeToFit()
        label.center = pathCenter
        return label
    }
    
    private func configLabel(){
        label.sizeToFit()
        label.center = pathCenter
    }
    
    private func setForegroundLayerColorForSafePercent(){
        self.foregroundLayer.strokeColor = outerRingColor.cgColor
    }
    
    private func setupView() {
        makeBar()
        self.addSubview(label)
    }
    
    //Layout Sublayers
    
    private var layoutDone = false
    override func layoutSublayers(of layer: CALayer) {
        if !layoutDone {
            let tempText = label.text
            setupView()
            label.text = tempText
            layoutDone = true
        }
    }
}
extension RMCircularProgressBar {
    
    public func setProgress(to progressConstant: CGFloat, withAnimation: Bool) {
        
        var progress: CGFloat {
            get {
                if progressConstant >= 1.0 { return 1.0 }
                else { return progressConstant }
            }
        }
        
        foregroundLayer.strokeEnd = CGFloat(progress)
        
        if withAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = self.value
            animation.toValue = progress
            animation.duration = 2
            foregroundLayer.add(animation, forKey: "foregroundAnimation")
            label.text = "\(Int(progress * 100))"
            self.setForegroundLayerColorForSafePercent()
            self.configLabel()
        }
        
        self.value = progress
    }
    
}
