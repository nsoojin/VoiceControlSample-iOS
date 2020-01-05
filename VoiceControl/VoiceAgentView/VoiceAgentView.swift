//
//  VoiceAgentView.swift
//  VoiceControlSample
//
//  Created by Soojin Ro on 2020/01/03.
//  Copyright © 2020 nsoojin. All rights reserved.
//

import UIKit

final internal class VoiceAgentView: UIView {
    @IBOutlet internal weak var stateView: VoiceStateView?
    
    var transcription: String? {
        get {
            transcriptionLabel?.text
        }
        set {
            transcriptionLabel?.attributedText = newValue.map(attributedTranscription(from:))
            setNeedsUpdateConstraints()
        }
    }
    
    override func updateConstraints() {
        if transcription.isEmpty == true {
            topAnchorConstraint?.isActive = true
            topPaddingConstraint?.isActive = false
        } else {
            topAnchorConstraint?.isActive = false
            topPaddingConstraint?.isActive = true
        }
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.applyShadow()
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    private func attributedTranscription(from originalString: String) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.minimumLineHeight = 34
        let font = UIFont.systemFont(ofSize: 25)
        
        let attributes = [NSAttributedString.Key.paragraphStyle : style,
                          NSAttributedString.Key.font : font]
        
        return NSAttributedString(string: originalString, attributes: attributes)
    }
    
    @IBOutlet private weak var transcriptionLabel: UILabel?
    @IBOutlet private weak var topPaddingConstraint: NSLayoutConstraint?
    @IBOutlet private weak var topAnchorConstraint: NSLayoutConstraint?
}
