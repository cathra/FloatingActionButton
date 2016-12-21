//
//  ViewController.swift
//  FloatingActionButton
//  Adapted by Martin Jacon Rehder on 2016/04/17
//
//  Original by
//
//  Created by Takuma Yoshida on 08/25/2015.
//  Copyright (c) 2015 Takuma Yoshida. All rights reserved.
//

import UIKit
import SnapKit
import FloatingActionButton

open class CustomCell : FloatingCell {
    var name: String = "sample"
    
    init(icon: UIImage, name: String) {
        self.name = name
        super.init(icon: icon)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func setupView(_ view: UIView) {
        super.setupView(view)
        let label = UILabel()
        label.text = name
        label.textColor = UIColor.white
        label.font = UIFont(name: "Helvetica-Neue", size: 12)
        addSubview(label)
        label.snp_makeConstraints { make in
            make.left.equalTo(self).offset(-80)
            make.width.equalTo(75)
            make.top.height.equalTo(self)
        }
    }
}

open class CustomDrawingActionButton: FloatingActionButton {
    
    override open func createPlusLayer(_ frame: CGRect) -> CAShapeLayer {
        
        let plusLayer = CAShapeLayer()
        plusLayer.lineCap = kCALineCapRound
        plusLayer.strokeColor = UIColor.white.cgColor
        plusLayer.lineWidth = 3.0
        
        let w = frame.width
        let h = frame.height
        
        let points = [
            (CGPoint(x: w * 0.25, y: h * 0.35), CGPoint(x: w * 0.75, y: h * 0.35)),
            (CGPoint(x: w * 0.25, y: h * 0.5), CGPoint(x: w * 0.75, y: h * 0.5)),
            (CGPoint(x: w * 0.25, y: h * 0.65), CGPoint(x: w * 0.75, y: h * 0.65))
        ]
        
        let path = UIBezierPath()
        for (start, end) in points {
            path.move(to: start)
            path.addLine(to: end)
        }
        
        plusLayer.path = path.cgPath
        
        return plusLayer
    }
}

class ViewController: UIViewController, FloatingActionButtonDataSource, FloatingActionButtonDelegate {
    
    var cells: [FloatingCell] = []
    var floatingActionButton: FloatingActionButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let createButton: (CGRect, FloatingActionButtonAnimateStyle) -> FloatingActionButton = { (frame, style) in
            let floatingActionButton = CustomDrawingActionButton(frame: frame)
            floatingActionButton.animateStyle = style
            floatingActionButton.childControlsColor = UIColor.white;
            floatingActionButton.childControlsTintColor = UIColor.darkGray;
            floatingActionButton.childControlsTintColor = UIColor.black
            floatingActionButton.dataSource = self
            floatingActionButton.delegate = self
            return floatingActionButton
        }

        let cellFactory: (String) -> FloatingCell = { (iconName) in
            let cell = FloatingCell(icon: UIImage(named: iconName)!)
            return cell
        }
        let customCellFactory: (String) -> FloatingCell = { (iconName) in
            let cell = CustomCell(icon: UIImage(named: iconName)!, name: iconName)
            return cell
        }
        cells.append(cellFactory("ic_cloud"))
        cells.append(customCellFactory("ic_system"))
        cells.append(cellFactory("ic_place"))
        
        let floatingFrame = CGRect(x: self.view.frame.width - 56 - 16, y: self.view.frame.height - 56 - 16, width: 56, height: 56)
        let bottomRightButton = createButton(floatingFrame, .up)
        
        let image = UIImage(named: "ic_art")
        bottomRightButton.image = image
        
        let floatingFrame2 = CGRect(x: 16, y: 16, width: 56, height: 56)
        let topLeftButton = createButton(floatingFrame2, .down)

        self.view.addSubview(bottomRightButton)
        self.view.addSubview(topLeftButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfCells(_ floatingActionButton: FloatingActionButton) -> Int {
        return cells.count
    }
    
    func cellForIndex(_ index: Int) -> FloatingCell {
        return cells[index]
    }
  
    func floatingActionButton(_ floatingActionButton: FloatingActionButton, didSelectItemAtIndex index: Int) {
        print("did Tapped! \(index)")
        floatingActionButton.close()
    }
}
