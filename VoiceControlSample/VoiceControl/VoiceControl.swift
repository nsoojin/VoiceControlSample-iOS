//
//  VoiceControl.swift
//  VoiceControlSample
//
//  Created by Soojin Ro on 2020/01/03.
//  Copyright © 2020 nsoojin. All rights reserved.
//

import UIKit

@IBDesignable
public final class VoiceControl: UIControl {
    
    public override var inputAccessoryView: UIView? {
        return clovaAgentView
    }
    
    public override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        if isFirstResponder {
            return false
        }
        
        clovaAgentView = UIView.makeFromNib(class: VoiceAgentView.self, owner: nil)
        
        let didBecomeFirstResponder = super.becomeFirstResponder()
        if didBecomeFirstResponder {
            imageView.alpha = 0.3
            clovaAgentView?.transcription = nil
            startSpeechRecognizer()
        }
        
        return didBecomeFirstResponder
    }
    
    @discardableResult
    public override func resignFirstResponder() -> Bool {
        imageView.alpha = 1.0
        clovaAgentView = nil
        stopSpeechRecognizer()
        return super.resignFirstResponder()
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitTest = super.hitTest(point, with: event)
        
        if hitTest == nil, isFirstResponder {
            resignFirstResponder()
        }
        
        return hitTest
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    public override func prepareForInterfaceBuilder() {
        commonInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
        circleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        layer.mask = circleLayer
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 72, height: 72)
    }
    
    private func commonInit() {
        backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.0862745098, blue: 0.09019607843, alpha: 0.98)
        
        let designTimeBundle = Bundle(for: VoiceControl.self)
        imageView.image = UIImage(named: "ic-mic", in: designTimeBundle, compatibleWith: traitCollection)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        addTarget(self, action: #selector(triggerVoiceControl), for: .touchUpInside)
    }

    @objc private func triggerVoiceControl() {
        if isFirstResponder {
            resignFirstResponder()
        } else {
            becomeFirstResponder()
        }
    }
    
    private func startSpeechRecognizer() {
        jarvis = MockJarvis()
        jarvis?.delegate = self
        jarvis?.start()
    }
    
    private func stopSpeechRecognizer() {
        jarvis = nil
    }
    
    private func hasRecognizedText() -> Bool {
        if let transcription = clovaAgentView?.transcription {
            return transcription != listeningStateDescription
        }
        
        return false
    }
    
    private var clovaAgentView: VoiceAgentView?
    private var jarvis: Jarvis?
    private let imageView = UIImageView()
    private let circleLayer = CAShapeLayer()
    private let listeningStateDescription = "듣고 있어요"
}

extension VoiceControl: JarvisDelegate {
    func jarvis(_ jarvis: Jarvis, didChangeState state: JarvisState) {
        switch state {
        case .preparing:
            print("attending")
            clovaAgentView?.stateView?.setState(.attending)
        case .detecting:
            print("detecting")
            clovaAgentView?.transcription = listeningStateDescription
            clovaAgentView?.stateView?.setState(.detecting)
        case .loading:
            print("processing")
            clovaAgentView?.transcription = nil
            clovaAgentView?.stateView?.setState(.processing)
        case .speaking(let transcript):
            print("reporting")
            clovaAgentView?.stateView?.setState(.reporting)
            clovaAgentView?.transcription = transcript
        }
    }
    
    func jarvis(_ jarvis: Jarvis, didRecognizeText text: String) {
        print("listening")
        clovaAgentView?.stateView?.setState(.listening)
        
        if clovaAgentView?.stateView?.state == .listening {
            clovaAgentView?.transcription = text
        }
    }
    
    func jarvis(_ jarvis: Jarvis, didChangeAmplitude value: CGFloat) {
        clovaAgentView?.stateView?.amplify(with: Double(value))
    }
    
    func jarvis(_ jarvis: Jarvis, didFailWithError error: Error) {
        resignFirstResponder()
    }
    
    func jarvisDidEndRecognizing(_ jarvis: Jarvis) {
        clovaAgentView?.transcription = nil
        clovaAgentView?.stateView?.setState(.attending)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.resignFirstResponder()
        }
    }
}
