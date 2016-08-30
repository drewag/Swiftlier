//
//  PlaceholderTextView.swift
//  empower-retirement
//
//  Created by Andrew J Wagner on 1/19/15.
//  Copyright (c) 2015 Drewag, LLC. All rights reserved.
//

import UIKit

@IBDesignable public class PlaceholderTextView: UITextView {
    private var placeholderTextView = UITextView()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sharedSetup()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.sharedSetup()
    }

    convenience init() {
        self.init(frame: CGRectZero, textContainer: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidChangeNotification, object: self)
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
    
    override public var font: UIFont! {
        didSet {
            self.placeholderTextView.font = font
        }
    }
    
    override public var contentOffset: CGPoint {
        didSet {
            let textView = self.placeholderTextView
            var top = (textView.bounds.height - textView.contentSize.height * textView.zoomScale) / 2.0;
            top = top < 0.0 ? 0.0 : top
            textView.contentOffset = CGPoint(x: 0, y: -top)
        }
    }
    
    override public var textAlignment: NSTextAlignment {
        didSet {
            self.placeholderTextView.textAlignment = textAlignment
        }
    }
    
    override public var text: String! {
        didSet {
            self.placeholderTextView.hidden = !text.isEmpty
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.placeholderTextView.frame = self.bounds
    }
    
    public func textChanged(notification: NSNotification) {
        if self.placeholder.isEmpty {
            return
        }
        self.placeholderTextView.hidden = !self.text.isEmpty
    }
}

private extension PlaceholderTextView {
    func sharedSetup() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textChanged(_:)), name: UITextViewTextDidChangeNotification, object: self)
        
        self.placeholderTextView.userInteractionEnabled = false
        self.addSubview(placeholderTextView)
        self.placeholderTextView.font = self.font
        self.placeholderTextView.textColor = UIColor(white: 0, alpha: 0.3)
        self.placeholderTextView.backgroundColor = UIColor.clearColor()
        self.placeholderTextView.textAlignment = self.textAlignment
    }
}
