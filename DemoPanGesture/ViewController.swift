//
//  ViewController.swift
//  DemoPanGesture
//
//  Created by Chu Van Truong on 1/30/19.
//  Copyright © 2019 Chu Van Truong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let viewTop = UIView()
    let viewBottom = UIView()
    var isUpSWipe = false
    lazy var startLocation = CGPoint()
    lazy var stopLocation = CGPoint()
    lazy var distanceBefore: CGFloat = 0.0
    lazy var distanceAfter: CGFloat = 0.0
    lazy var swipeUpEnable = true
    lazy var swipeDownEnable = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let panRecognizer = UIPanGestureRecognizer(target: self, action:  #selector(panedView))
        self.view.addGestureRecognizer(panRecognizer)
        
        viewTop.frame = CGRect(x: 0, y: -UIScreen.main.bounds.height, width: view.frame.width, height: view.frame.height)
        viewTop.backgroundColor = .red
        view.addSubview(viewTop)
        
        viewBottom.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: view.frame.width, height: view.frame.height)
        viewBottom.backgroundColor = .blue
        view.addSubview(viewBottom)
    }

    @objc func panedView(sender:UIPanGestureRecognizer){
        
        if sender.state == UIGestureRecognizer.State.began {
            startLocation = sender.location(in: self.view)
            print(startLocation)
        } else if sender.state == UIGestureRecognizer.State.changed {
            stopLocation = sender.location(in: self.view)
            let dx = stopLocation.x - startLocation.x
            let dy = stopLocation.y - startLocation.y
            distanceAfter = sqrt(dx*dx + dy*dy )
            let delta = distanceAfter - distanceBefore

            if swipeDownEnable, startLocation.y < stopLocation.y {
                swipeUpEnable = false
                viewTop.frame.origin.y += delta
            } else if swipeUpEnable, startLocation.y > stopLocation.y {
                swipeDownEnable = false
                viewBottom.frame.origin.y -= delta
            }
            distanceBefore = distanceAfter
            
        } else if sender.state == UIGestureRecognizer.State.ended {
            distanceBefore = 0.0
            if swipeDownEnable {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                    self.viewTop.frame.origin.y = 0
                }) { (_) in
                    UIView.animate(withDuration: 1, animations: {
                        self.viewTop.alpha = 0
                    }, completion: { (_) in
                        self.viewTop.frame.origin.y = -UIScreen.main.bounds.height
                         self.viewTop.alpha = 1
                    })
                }
            } else if swipeUpEnable {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                    self.viewBottom.frame.origin.y = 0
                }) { (_) in
                    UIView.animate(withDuration: 1, animations: {
                        self.viewBottom.alpha = 0
                    }, completion: { (_) in
                        self.viewBottom.frame.origin.y = UIScreen.main.bounds.height
                        self.viewBottom.alpha = 1
                    })
                }
            }
            
            swipeDownEnable = true
            swipeUpEnable = true
        }
    }
}

