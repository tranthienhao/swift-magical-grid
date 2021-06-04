//
//  ViewController.swift
//  MagicalGrid
//
//  Created by Tran Thien Hao on 04/06/2021.
//

import UIKit

final class ViewController: UIViewController {
    
    struct Constants {
        static let numberOfColumn = 15
    }
    
    private var boxes = [String: UIView]()
    private var selectedBox: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGrid()
        setupGestureEvent()
    }
    
    var screenSize: CGRect {
        UIScreen.main.bounds
    }
    
    var boxSize: CGFloat {
        screenSize.width / CGFloat(Constants.numberOfColumn)
    }
    
    var numberOfRow: Int {
        Int(screenSize.height / boxSize)
    }

    func setupGrid() {
        for i in 0...numberOfRow {
            for j in 0...Constants.numberOfColumn {
                let box = UIView(
                    frame: CGRect(x: CGFloat(j) * boxSize, y: CGFloat(i) * boxSize, width: boxSize, height: boxSize)
                )
                box.layer.borderWidth = 0.5
                box.layer.borderColor = UIColor.black.cgColor
                box.backgroundColor = UIColor.getRandomColor()
                self.view.addSubview(box)
                
                boxes["\(i)|\(j)"] = box
            }
        }
    }
    
    func setupGestureEvent() {
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panHandler)))
    }
    
    @objc func panHandler(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self.view)
        let i = Int(location.y / boxSize)
        let j = Int(location.x / boxSize)
        
        guard let currentBox = boxes["\(i)|\(j)"] else { return }
        self.view.bringSubviewToFront(currentBox)
        
        if let selectedBox = selectedBox, selectedBox != currentBox {
            zoomOut(view: selectedBox)
        }
        
        zoomIn(view: currentBox)
        self.selectedBox = currentBox
        
        if gesture.state == .ended {
            zoomOut(view: currentBox, delay: 0.25, spring: 0.5, velocity: 0.5)
        }
    }
    
    func zoomIn(view: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            view.layer.transform = CATransform3DMakeScale(3, 3, 3)
        }, completion: nil)
    }
    
    func zoomOut(view: UIView, delay: Double = 0, spring: CGFloat = 1, velocity: CGFloat = 1) {
        UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: spring, initialSpringVelocity: velocity, options: .curveEaseOut, animations: {
            view.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
}

extension UIColor {
    static func getRandomColor() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
