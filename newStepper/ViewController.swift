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


  @IBOutlet weak var circleView: UIView!
  @IBOutlet weak var arrowUp: UIButton!
  @IBOutlet weak var arrowDown: UIButton!
  @IBOutlet weak var buttonUp: UIButton! // buttons in the center that disapears
  @IBOutlet weak var buttonDown: UIButton!


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
      if newValue >= Int(min) && newValue <= Int(max){
        label.text = newValue.description
      }
    }
  }

  private func inc(n: Int) {
    score = score + n
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    label.font = UIFont(name:"Futura-Medium", size: 44.0)
    arrowDown.alpha = 0
    arrowUp.alpha = 0
    label.alpha = 0

    let swipeGestures = setupSwipeGestures()
    setupPanGestures(swipeGestures)
    setupTapGesture()


    circleView.layer.cornerRadius = CGRectGetHeight(circleView.bounds) / 2.0
    circleView.layer.borderColor = UIColor.lightGrayColor().CGColor
  }

  private func setupSwipeGestures() -> [UISwipeGestureRecognizer] {
    let swipeUp = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
    let swipeDown = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))

    swipeUp.direction = .Up
    swipeDown.direction = .Down

    circleView.addGestureRecognizer(swipeUp)
    circleView.addGestureRecognizer(swipeDown)

    return [swipeUp, swipeDown]
  }

  private func setupTapGesture(){
    let tapped = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
    circleView.addGestureRecognizer(tapped)
  }

  // Tap outside of the view
  @IBAction func setupOutsideTapGesture(sender: UITapGestureRecognizer) {
    UIView.animateWithDuration(0.1, delay: 0, options: [  .AllowUserInteraction , .CurveEaseInOut ] , animations: {
    self.circleView.transform = CGAffineTransformMakeScale(1, 1)
    self.circleView.layer.backgroundColor = UIColor(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 0.3).CGColor
    self.arrowDown.alpha = 0
    self.arrowUp.alpha = 0


    },completion:nil)

  }


  // add a pan gesture recognizer for multiple goals 
  // swipe gesture as a parameter in order to cancel if it fails

  private func setupPanGestures(swipeGestures: [UISwipeGestureRecognizer]) {
    let panGesture = UIPanGestureRecognizer(target: self, action: Selector("handleThePan:"))
    for swipeGesture in swipeGestures {
       panGesture.requireGestureRecognizerToFail(swipeGesture)
    }
    circleView.addGestureRecognizer(panGesture)
  }


  // speed of the pan gesture
  private struct Constants {
    static let GoalGestureScale :CGFloat = 8
  }

  func handleThePan(sender: UIPanGestureRecognizer) -> Void {
    switch sender.state {
    case .Ended: fallthrough
    case .Changed:
      self.circleView.layer.backgroundColor = UIColor(red: 167/255.0, green: 246/255.0, blue: 67/255.0, alpha: 1).CGColor
      let translation = sender.translationInView(circleView)
      let goalChange = -Int(translation.y / Constants.GoalGestureScale)
      if goalChange != 0 {
        score += goalChange
        sender.setTranslation(CGPointZero, inView: circleView)
      }
    default: break
    }
  }



  // start animation of circle view when view is tapped

  func handleTap(sender: UITapGestureRecognizer) {
    circleView.layer.backgroundColor = UIColor(red: 167/255.0, green: 246/255.0, blue: 67/255.0, alpha: 1).CGColor
    UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: [.AllowUserInteraction , .CurveEaseInOut ], animations: {
      self.circleView.transform = CGAffineTransformMakeScale(1.2, 1.2)
      self.buttonUp.alpha = 0
      self.buttonDown.alpha = 0
      self.buttonUp.center.y = 10
      self.buttonDown.center.y = 85
      },completion:nil)

    UIView.animateWithDuration(0.6, delay: 0, options: [  .AllowUserInteraction , .CurveEaseInOut ] , animations: {
        self.arrowDown.alpha = 1
        self.arrowUp.alpha = 1
        self.label.alpha = 1
      },completion:nil)

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

    } else if  sender.direction == .Down  {
      increment = -1
      offset = -10
      print("offset down :\(offset)")

    }

    // animate stuff with constraints
    inc(increment)

    UIView.animateWithDuration(0.2, animations: { _ in
      self.labelYConstraint.constant = self.offset
      self.view.layoutIfNeeded()
      self.label.alpha = 1
      self.buttonUp.alpha = 0
      self.buttonDown.alpha = 0
      self.circleView.layer.backgroundColor = UIColor(red: 167/255.0, green: 246/255.0, blue: 67/255.0, alpha: 1).CGColor
      }) { _ in

        UIView.animateWithDuration(0.2, animations: { _ in
          self.labelYConstraint.constant = 0
          self.view.layoutIfNeeded()
          self.circleView.layer.shadowColor = UIColor.clearColor().CGColor
        })
    }
  }
}




