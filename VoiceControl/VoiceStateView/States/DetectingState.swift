//
//  DetectingState.swift
//  VoiceControlSample
//
//  Created by Soojin Ro on 2020/01/03.
//  Copyright © 2020 nsoojin. All rights reserved.
//

import UIKit
import GameplayKit

internal final class DetectingState: VoiceState {
    private(set) var magnitude: CGFloat = 0.5 //A scale of 0 to 1
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        animateDetection()
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        removeAnimation()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is ProcessingState.Type:
            return true
        default:
            return false
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        magnitude = CGFloat(seconds)
    }
    
    private func animateDetection() {
        stateView.dots.forEach { dot in
            let delay = Double(dot.tag - 1) * 0.05
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.amplify(dot)
            }
        }
    }
    
    private func removeAnimation() {
        stateView.dots.forEach { $0.layer.removeAnimation(forKey: DetectingState.animationKey) }
    }
    
    private func amplify(_ dot: UIView) {
        let noise = random(min: 0, max: 0.3)
        let animation = CASpringAnimation(keyPath: "bounds.size.height")
        animation.beginTime = CACurrentMediaTime()
        animation.toValue = dot.bounds.size.height * (regularized(magnitude) + noise)
        animation.initialVelocity = -15
        animation.damping = 7
        animation.stiffness = 750
        animation.autoreverses = true
        animation.delegate = self
        animation.isRemovedOnCompletion = true
        dot.layer.add(animation, forKey: DetectingState.animationKey)
    }
    
    private static let animationKey: String = "DetectionAnimationKey"
}

extension DetectingState: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            let dotsToAnimate = stateView.dots.filter { $0.layer.animation(forKey: DetectingState.animationKey) == nil }
            dotsToAnimate.forEach { amplify($0) }
        }
    }
}

private extension DetectingState {
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return (CGFloat(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    //regularize to have distributed values from 1.5 to 2.5
    func regularized(_ magnitude: CGFloat) -> CGFloat {
        var regularized = magnitude
        
        if regularized < 0 {
            regularized = 0
        } else if regularized > 1 {
            regularized = 1
        }
        
        return 1.5 + regularized
    }
}
