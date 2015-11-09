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

  // IBActions
  @IBAction func buttonUp(sender: AnyObject) {
    inc(1)
  }


  @IBAction func buttonDown(sender: AnyObject) {
    if score == 0 {
      score = 0
    } else {
      inc(-1)
    }
  }

  // the view underneath the number

  @IBOutlet weak var circleView: UIView!
  @IBOutlet weak var arrowUp: UIButton!
  @IBOutlet weak var arrowDown: UIButton!

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

  }

  @IBInspectable var min: Int = 0
  @IBInspectable var max: Int = 20

  var increment: Int = 1
  var offset: CGFloat = 10


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
  private func dec(n: Int) {
    if score == 0 {
      score = 0}
    else {
      score = score - n
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    label.font = UIFont(name:"Futura-Medium", size: 44.0)
    arrowDown.alpha = 0
    arrowUp.alpha = 0

    setupSwipeGestures()
    setupTapGesture()

    circleView.layer.cornerRadius = CGRectGetHeight(circleView.bounds) / 2.0
    circleView.layer.borderColor = UIColor.lightGrayColor().CGColor
  }

  private func setupSwipeGestures() {
    let swipeUp = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
    let swipeDown = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))

    swipeUp.direction = .Up
    swipeDown.direction = .Down

    circleView.addGestureRecognizer(swipeUp)
    circleView.addGestureRecognizer(swipeDown)


  }

  private func setupTapGesture(){
    let tapped = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
    circleView.addGestureRecognizer(tapped)
  }

  // start animation of circle view when view is tapped

  func handleTap(sender: UITapGestureRecognizer) {
    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: [.AllowUserInteraction , .CurveEaseInOut ], animations: {
//    UIView.animateWithDuration(0.5, delay: 0.0, options: [  .AllowUserInteraction , .CurveEaseInOut  ] , animations: {
      self.circleView.transform = CGAffineTransformMakeScale(1.2, 1.2)
      self.circleView.layer.backgroundColor = UIColor(red: 167/255.0, green: 246/255.0, blue: 67/255.0, alpha: 1).CGColor
      self.arrowDown.alpha = 1
      self.arrowUp.alpha = 1
      },completion:nil)

//    UIView.animateWithDuration(0.7, delay: 0.7, options: [  .AllowUserInteraction , .CurveEaseInOut ] , animations: {
//      self.circleView.transform = CGAffineTransformMakeScale(1, 1)
//      },completion:nil)

  }

  func handleSwipes(sender:UISwipeGestureRecognizer) {


    // up or down
    if sender.direction == .Down && score == 0  {
      increment = 0
      offset = -10

    } else if sender.direction == .Up  {

      increment = 1
      offset = 10
      print("offset up :\(offset)")
      //label.center = CGPoint(x: label.center.x , y: label.center.y + offset)

    } else if  sender.direction == .Down  {
      increment = -1
      offset = -10
      print("offset down :\(offset)")
      //label.center = CGPoint(x: label.center.x, y: label.center.y + offset)

    }

    //let shadowAnimate = CABasicAnimation(keyPath:"shadowOpacity")
    // animate stuff with constraints
    inc(increment)

    UIView.animateWithDuration(0.2, animations: { _ in
      self.labelYConstraint.constant = self.offset
      self.view.layoutIfNeeded()

      //self.circleView.layer.shadowRadius = 4
      self.circleView.layer.shadowOpacity = 1
      //self.circleView.layer.shadowColor = UIColor(red: 167/255.0, green: 246/255.0, blue: 67/255.0, alpha: 1).CGColor
      self.circleView.layer.backgroundColor = UIColor(red: 167/255.0, green: 246/255.0, blue: 67/255.0, alpha: 1).CGColor
      self.circleView.layer.shadowOffset = CGSize.zero
      //self.label.textColor = UIColor.blueColor()
      }) { _ in

        UIView.animateWithDuration(0.2, animations: { _ in
          self.labelYConstraint.constant = 0
          self.view.layoutIfNeeded()
          self.circleView.layer.shadowRadius = 1
          self.circleView.layer.shadowOpacity = 0.1
          self.circleView.layer.shadowColor = UIColor.clearColor().CGColor
          //self.circleView.layer.backgroundColor = UIColor(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 0.3).CGColor

          //self.label.textColor = UIColor.blackColor()
        })
    }
  }
}

