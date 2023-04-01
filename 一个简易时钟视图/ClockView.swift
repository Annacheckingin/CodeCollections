//
//  ClockViewController.swift
//  ChatDemo
//
//  Created by 李正国 on 2023/3/31.
//

import UIKit




class ClockView:UIView{
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
       
        startAnimate()
        
    }
    
    
    func startAnimate(){
        
        
        _ = _timer
        
    }
    
    deinit {
        _timer.invalidate()
    }
    
    private lazy var _timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {[weak self] t in
        guard let `self` = self else {t.invalidate(); return}
        let totalHours  = 12 * 5
        let singleArc =   CGFloat.pi * 2 / CGFloat(totalHours)
        self.hourPointer.transform = CATransform3DRotate(self.hourPointer.transform, singleArc, 0, 0, 1)
    }
    
    override func draw(_ rect: CGRect) {
        
        drawHours()
        drawMinute()
       
    }
    
  
    func drawHours(){
        let totalHours  = 12
        let singleArc =   CGFloat.pi * 2 / CGFloat(totalHours)
        let length = min(bounds.size.width, bounds.size.height) / 2
        let offset :CGFloat = 8
        for i in 0..<totalHours {
         drawLine(start: center, length: length,offset:offset, arc: CGFloat(i) * singleArc)
        }
        
        
    }
    
    
    func drawMinute(){
        let totalMinute  = 60
        let singleArc =  CGFloat.pi * 2 / CGFloat(totalMinute)
        let length = min(bounds.size.width, bounds.size.height) / 2
        let offset : CGFloat = 4
        for i in 0..<totalMinute {
         drawLine(start: center, length: length,offset:offset, arc: CGFloat(i) * singleArc)
        }
    }
    
    
    
    override func layoutSubviews() {
        _ = _adjustLayer
        super.layoutSubviews()
    }
    
    private lazy var _adjustLayer = {
        let width : CGFloat = 3
        let  height = min(bounds.size.width, bounds.size.height) / 2 * 0.75
        var origin = CGPoint.init(x: center.x - width / 2, y: center.y - height)
        let rect = CGRect.init(origin: origin, size: .init(width: width, height: height))
        hourPointer.frame = rect
        hourPointer.backgroundColor = UIColor.black.cgColor
    }()
    
    lazy var hourPointer : CALayer = {
        let  width : CGFloat = 3
        let  height = min(bounds.size.width, bounds.size.height) / 2 * 0.75
        let retavl = pointerLayer(size: .init(width: width, height: height))
        layer.addSublayer(retavl)
//        retavl.anchorPoint = .init(x: retavl.anchorPoint.x - width / 2, y: retavl.anchorPoint.y + height / 2)
        retavl.anchorPoint = .init(x: 0.5, y: 1)
        return retavl
    }()
    
   
    
    
    func drawMinutePointer(){
        
        
        
        
    }
    
    
    
    
    @inlinable
    func drawLine(start:CGPoint,length:CGFloat,offset:CGFloat = 0,arc:CGFloat,color:UIColor = .black,width:CGFloat = 1){
        
        
        let path = UIBezierPath.init()
        color.setFill()
        
        guard offset == 0 else {
            
            
            var newPoint = start
            
            newPoint.x = start.x + (length - offset) * cos(arc)
           
            newPoint.y = start.y + (length - offset) * sin(arc)
            
            path.move(to: newPoint)
            
            var nextPoint = start
            
            nextPoint.x = start.x + length * cos(arc)
           
            nextPoint.y = start.y + length * sin(arc)
            
            path.addLine(to: nextPoint)
            
            
            path.stroke()
            
            return
        }
        
        path.move(to: start)
        
        path.lineWidth = width
        
        var nextPoint = start
        
        nextPoint.x = start.x + length * cos(arc)
       
        nextPoint.y = start.y + length * sin(arc)
        
        path.addLine(to: nextPoint)
        
        
        path.stroke()
        
    }
    
    
    
    
    
    func pointerLayer(size:CGSize)->CALayer{
        
        var retval = CAShapeLayer.init()
        
        
        let path = UIBezierPath.init()
        
        path.move(to: .zero)
    
        
        let rtP = CGPoint(x: size.width, y: 0)
        
        let rbP = CGPoint.init(x: size.width, y: size.height)
        
        let lbP = CGPoint.init(x: 0, y: size.height)
        
       
        path.addLine(to: rtP)

        path.addLine(to: rbP)
        
        path.addLine(to: lbP)
        
        path.close()
        
        retval.path = path.cgPath
        
        return retval
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
