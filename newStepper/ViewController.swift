//
//  ViewController.swift
//  newStepper
//
//  Created by aziz omar boudi  on 6/10/15.
//  Copyright (c) 2015 jogabo. All rights reserved.
//
// coreAnimation layer
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

  // the view underneath the number

  @IBOutlet weak var circleView: UIView!

 

  @IBInspectable var min: Int = 0
  @IBInspectable var max: Int = 20

  // MARK : IBOutlet

  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var labelYConstraint: NSLayoutConstraint!

  var score: Int {
    get {
      if let value = Int(label.text!) { return value }
      return 0
    }
    set {
      label.text = newValue.description
    }
  }

  private func inc(n: Int) {
    score = score + n
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSwipeGestures()

    circleView.layer.cornerRadius = CGRectGetHeight(circleView.bounds) / 2.0
    circleView.layer.borderColor = UIColor.lightGrayColor().CGColor
    circleView.layer.borderWidth = 9.0
//    circleView.layer.shadowRadius = 4
//    circleView.layer.shadowOpacity = 0.5
//    circleView.layer.shadowColor = UIColor.blueColor().CGColor
  }

  private func setupSwipeGestures() {
    let swipeUp = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
    let swipeDown = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))

    swipeUp.direction = .Up
    swipeDown.direction = .Down

    view.addGestureRecognizer(swipeUp)
    view.addGestureRecognizer(swipeDown)


  }

  func handleSwipes(sender:UISwipeGestureRecognizer) {
    var increment: Int
    var offset: CGFloat

    // up or down
    if sender.direction == .Up {
      increment = 1
      offset = 10
      print(offset)
//      label.center = CGPoint(x: label.center.x, y: label.center.y + offset)


    } else {
      increment = -1
      offset = -10
      print(offset)
//      label.center = CGPoint(x: label.center.x, y: label.center.y + offset)


    }

    //let shadowAnimate = CABasicAnimation(keyPath:"shadowOpacity")


    // animate stuff with constraints
    inc(increment)

    UIView.animateWithDuration(0.2, animations: { _ in
      self.labelYConstraint.constant = offset
      self.view.layoutIfNeeded()

      self.circleView.layer.shadowRadius = 4
      self.circleView.layer.shadowOpacity = 0.8
      self.circleView.layer.shadowColor = UIColor.blueColor().CGColor
      self.circleView.layer.shadowOffset = CGSize.zero
      self.label.textColor = UIColor.blueColor()
      }) { _ in

        UIView.animateWithDuration(0.2, animations: { _ in
          self.labelYConstraint.constant = 0
          self.view.layoutIfNeeded()
          self.circleView.layer.shadowRadius = 1
          self.circleView.layer.shadowOpacity = 0.1
          self.circleView.layer.shadowColor = UIColor.clearColor().CGColor
          self.label.textColor = UIColor.blackColor()
        })
    }
  }
}

