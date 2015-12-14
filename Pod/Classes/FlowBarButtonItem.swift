//
//  FlowBarButtonItem.swift
//  OSKNavigationFlowButton
//
//  Created by Tomoya Hirano on 2015/12/15.
//  Copyright © 2015年 Tomoya Hirano. All rights reserved.
//

import UIKit

class FlowBarButtonItem: UIBarButtonItem {
    private var press:UILongPressGestureRecognizer?
    var flowWindow:FlowWindow?
    var flowButton:FlowButton?
    
    var _view:UIView?{
        return valueForKey("view") as? UIView
    }
    
    func enableFlow(){
        if let p = press {
            _view?.removeGestureRecognizer(p)
        }
        press = UILongPressGestureRecognizer(target: self, action: "longPress:")
        press?.minimumPressDuration = 0.2
        _view?.addGestureRecognizer(press!)
        flowButton = FlowButton(barButtonItem: self)
    }
    
    private override init() {
        super.init()
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func longPress(gesture:UILongPressGestureRecognizer){
        let p = gesture.locationInView(_view?.superview)
        if gesture.state == .Began {
            _view?.hidden = true
            FlowWindow.sharedInstance.addFlowButton(flowButton!)
            flowButton?.center = _view!.center
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.flowButton?.center = p
            })
        }else if gesture.state == .Changed {
            flowButton?.pan(gesture)
        }else if gesture.state == .Ended {
            flowButton?.pan(gesture)
        }
    }
}

class FlowWindow:UIWindow {
    
    static let sharedInstance = FlowWindow(frame: UIScreen.mainScreen().bounds)
    internal func addFlowButton(button:FlowButton){
        makeKeyAndVisible()
        addSubview(button)
        button.transform = CGAffineTransformMakeScale(0.1, 0.1)
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
            button.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        windowLevel = UIWindowLevelAlert-1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func returnButton(button:FlowButton){
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
            button.alpha = 0.0
            button.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                button.alpha = 1.0
                button.barButton?._view?.hidden = false
                button.removeFromSuperview()
                if self.subviews.count == 0{
                    self.resignKeyWindow()
                    self.removeFromSuperview()
                    self.hidden = true
                }
        }
    }
    
    //FlowButtonは押せるようにする
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if let v = super.hitTest(point, withEvent: event) as? FlowButton {
            return v
        }
        return nil
    }
}

class FlowButton:UIView {
    private var canMove = false
    private var myWindow = FlowWindow.sharedInstance
    private var barButton:FlowBarButtonItem?
    private var barButtonZone:CGRect?
    internal var dismissOnButton = false
    
    private var baseView = UIView(frame: CGRectMake(0, 0, 64, 64))
    private var imageView = UIImageView(frame: CGRectMake(0, 0, 21, 21))
    private var coverView = UIView(frame: CGRectMake(0, 0, 64, 64))
    init(barButtonItem:FlowBarButtonItem){
        super.init(frame: CGRectMake(0, 0, 64, 64))
        baseView.backgroundColor = UIColor(hue:0.63, saturation:0.25, brightness:0.21, alpha:1)
        baseView.layer.cornerRadius = 32
        baseView.layer.masksToBounds = true
        baseView.userInteractionEnabled = false
        baseView.layer.masksToBounds = false
        baseView.layer.borderColor = UIColor.whiteColor().CGColor
        baseView.layer.borderWidth = 2.0
        baseView.layer.shadowOffset = CGSizeZero
        baseView.layer.shadowOpacity = 0.5
        baseView.layer.shadowColor = UIColor.blackColor().CGColor
        baseView.layer.shadowRadius = 5.0
        addSubview(baseView)
        
        imageView.contentMode = UIViewContentMode.Center
        imageView.center = CGPointMake(bounds.width/2, bounds.height/2)
        imageView.userInteractionEnabled = false
        baseView.addSubview(imageView)
        
        coverView.backgroundColor = UIColor.blackColor()
        coverView.alpha = 0.0
        coverView.userInteractionEnabled = false
        baseView.addSubview(coverView)
        
        barButton = barButtonItem
        barButtonZone = barButtonItem._view?.frame
        imageView.image = barButtonItem.image?.imageWithRenderingMode(.AlwaysTemplate)
        backgroundColor = UIColor.clearColor()
        imageView.tintColor = tintColor
        
        let pan = UIPanGestureRecognizer(target: self, action: "pan:")
        addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: "tapGesture:")
        addGestureRecognizer(tap)
    }
    
    private func onBar()->Bool{
        let zone = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 64)
        return CGRectContainsPoint(zone, center)
    }
    
    private func onBarButton()->Bool{
        let offset:CGFloat = 40.0
        var zone = barButtonZone!
        zone.size.width += offset
        zone.size.width += offset
        zone.origin.x -= offset/2
        zone.origin.y += offset/2
        return CGRectContainsPoint(zone, center)
    }
    
    private func onContain()->Bool{
        return dismissOnButton ? onBarButton() : onBar()
    }
    
    func tapGesture(gesture:UITapGestureRecognizer){
        let app = UIApplication.sharedApplication()
        app.sendAction(self.barButton!.action, to: self.barButton!.target,
            from: self, forEvent: nil)
    }
    
    func pan(gesture:UILongPressGestureRecognizer){
        if gesture.state == .Began {
            canMove = true
            let scale:CGFloat = 1.2
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.7, options: [.AllowAnimatedContent,.AllowUserInteraction], animations: { () -> Void in
                self.transform = CGAffineTransformMakeScale(scale,scale)
                self.baseView.layer.shadowRadius = 20.0
                }, completion: { (_) -> Void in
            })
        }else if gesture.state == .Changed{
            let p = gesture.locationInView(superview)
            center = p
            let scale:CGFloat = onContain() ? 1.5 : 1.2
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.7, options: [.AllowAnimatedContent,.AllowUserInteraction], animations: { () -> Void in
                self.transform = CGAffineTransformMakeScale(scale,scale)
                }, completion: { (_) -> Void in
            })
        }else if gesture.state == .Ended {
            canMove = false
            if onContain() {
                myWindow.returnButton(self)
            }else{
                fitSide()
            }
        }else{
            fitSide()
        }
    }
    
    private func fitSide(){
        let padding:CGFloat = 44.0
        let superWidth = myWindow.bounds.width
        let superHeight = myWindow.bounds.height
        let posX = center.x < superWidth/2 ? padding : superWidth-padding
        var posY = center.y
        posY = posY<padding ? padding : posY
        posY = posY>superHeight-padding ? superHeight-padding : posY
        let pos = CGPointMake(posX, posY)
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.AllowAnimatedContent,.AllowUserInteraction], animations: { () -> Void in
            self.center = pos
            self.transform = CGAffineTransformIdentity
            self.baseView.layer.shadowRadius = 5.0
            }, completion: { (_) -> Void in
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
