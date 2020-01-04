//
//  VoiceStateView.swift
//  VoiceControlSample
//
//  Created by Soojin Ro on 2020/01/03.
//  Copyright © 2020 nsoojin. All rights reserved.
//

import UIKit
import Lottie
import GameplayKit

@IBDesignable
internal class VoiceStateView: UIView {
    private(set) var state: State = .attending
    let dotsContainerView = UIView()
    let animationView = AnimationView(name: "voice")
    
    @discardableResult
    func setState(_ state: State) -> Bool {
        let isNextStateValid = stateMachine.canEnterState(state.classType())
        if isNextStateValid {
            self.state = state
            stateMachine.enter(state.classType())
        }
        
        return isNextStateValid
    }
    
    func amplify(with magnitude: Double) {
        stateMachine.update(deltaTime: magnitude)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dotsContainerView.frame = bounds
        animationView.frame = bounds

        let lottieScale = animationView.bounds.size.width / 100
        let dotWidth = 8.0 * lottieScale
        
        dots.forEach { dot in
            let x = bounds.size.width / 2 + (CGFloat(dot.tag - 2) * 19.0 * lottieScale) - dotWidth / 2
            let y = bounds.size.height / 2  - dotWidth / 2
            dot.frame = CGRect(x: x, y: y, width: dotWidth, height: dotWidth)
            dot.layer.cornerRadius = dot.frame.size.width / 2
        }
    }
    
    override func didMoveToWindow() {
        state = .attending
        stateMachine.enter(AttendingState.self)
    }
    
    private func commonInit() {
        addSubview(dotsContainerView)
        addSubview(animationView)
        
        animationView.contentMode = .scaleAspectFill
        
        dots = (1...3).map(UIView.init(withTag:))
        dots.forEach {
            $0.backgroundColor = colorForDot(withTag: $0.tag)
            $0.layer.allowsEdgeAntialiasing = true
            dotsContainerView.addSubview($0)
        }
    }

    private func colorForDot(withTag tag: Int) -> UIColor? {
        switch tag {
        case 1: return #colorLiteral(red: 0, green: 0.7960784314, blue: 0.6196078431, alpha: 1)
        case 2: return #colorLiteral(red: 0, green: 0.8666666667, blue: 0.3450980392, alpha: 1)
        case 3: return #colorLiteral(red: 0, green: 0.7254901961, blue: 0.9215686275, alpha: 1)
        default:
            return nil
        }
    }
    
    private(set) var dots = [UIView]()
    private lazy var stateMachine: GKStateMachine = {
        return GKStateMachine(states: [
            AttendingState(statusView: self),
            ListeningState(statusView: self),
            DetectingState(statusView: self),
            ProcessingState(statusView: self),
            ReportingState(statusView: self)
        ])
    }()
}

internal extension VoiceStateView {
    enum State {
        case attending, listening, detecting, processing, reporting
        
        func classType() -> AnyClass {
            switch self {
            case .attending:
                return AttendingState.self
            case .listening:
                return ListeningState.self
            case .detecting:
                return DetectingState.self
            case .processing:
                return ProcessingState.self
            case .reporting:
                return ReportingState.self
            }
        }
    }
}

private extension UIView {
    convenience init(withTag tag: Int) {
        self.init()
        self.tag = tag
    }
}
