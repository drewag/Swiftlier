//
//  PlaceholderTextView.swift
//  empower-retirement
//
//  Created by Andrew J Wagner on 1/19/15.
//  Copyright (c) 2015 Drewag, LLC. All rights reserved.
//

#if os(iOS)
import UIKit

@IBDesignable open class PlaceholderTextView: UITextView {
    fileprivate var placeholderTextView = UITextView()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sharedSetup()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.sharedSetup()
    }

    convenience init() {
        self.init(frame: CGRect(), textContainer: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UITextViewTextDidChange, object: self)
    }
    
    @IBInspectable public var placeholder: String {
        set {
            self.placeholderTextView.text = newValue
            self.setNeedsLayout()
        }
        get {
            return self.placeholderTextView.text
        }
    }
    
    override open var font: UIFont! {
        didSet {
            self.placeholderTextView.font = font
        }
    }
    
    override open var contentOffset: CGPoint {
        didSet {
            let textView = self.placeholderTextView
            var top = (textView.bounds.height - textView.contentSize.height * textView.zoomScale) / 2.0;
            top = top < 0.0 ? 0.0 : top
            textView.contentOffset = CGPoint(x: 0, y: -top)
        }
    }
    
    override open var textAlignment: NSTextAlignment {
        didSet {
            self.placeholderTextView.textAlignment = textAlignment
        }
    }
    
    override open var text: String! {
        didSet {
            self.placeholderTextView.isHidden = !text.isEmpty
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.placeholderTextView.frame = self.bounds
    }
    
    open func textChanged(_ notification: NSNotification) {
        if self.placeholder.isEmpty {
            return
        }
        self.placeholderTextView.isHidden = !self.text.isEmpty
    }
}

private extension PlaceholderTextView {
    func sharedSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(_:)), name: .UITextViewTextDidChange, object: self)
        
        self.placeholderTextView.isUserInteractionEnabled = false
        self.addSubview(placeholderTextView)
        self.placeholderTextView.font = self.font
        self.placeholderTextView.textColor = UIColor(white: 0, alpha: 0.3)
        self.placeholderTextView.backgroundColor = UIColor.clear
        self.placeholderTextView.textAlignment = self.textAlignment
    }
}
#endif
