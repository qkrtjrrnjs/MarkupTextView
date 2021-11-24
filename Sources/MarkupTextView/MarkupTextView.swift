//
//  MarkupTextView.swift
//  MarkupTextView
//
//  Created by Chris Park on 11/22/21.
//

import UIKit

public enum Drag {
    case always
    case never
    case whenEditing
}

open class MarkupTextView: UITextView {
    
    private var heightConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    private var hasDragged = false
    private var x = 0.0
    private var y = 0.0
    
    override open var text: String! {
        didSet { setNeedsDisplay() }
    }
    
    open var drag: Drag = .always
    
    open var borderColor: UIColor = .systemBlue
    
    open var borderWidth: CGFloat = 1.0
    
    open var maxWidth: CGFloat = UIScreen.main.bounds.size.width

    open var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    open var placeholder: String = "Text" {
        didSet { setNeedsDisplay() }
    }
    
    open var placeholderColor: UIColor = .black {
        didSet { setNeedsDisplay() }
    }
    
    open var attributedPlaceholder: NSAttributedString? {
        didSet { setNeedsDisplay() }
    }
    
    // Initialize
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentMode = .redraw
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidBeginEditing), name: UITextView.textDidBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing), name: UITextView.textDidEndEditingNotification, object: self)
        if drag != .never {
            addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragging)))
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let contentText = text.isEmpty && !self.isFirstResponder ? placeholder : text!
        let textSize = getSize(of: contentText)
        let size = sizeThatFits(CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
        var height = size.height
        var width = textSize.width
        
        width = maxWidth > 0 ? min(width, maxWidth) : width
        height = maxHeight > 0 ? min(height, maxHeight) : height
        
        if heightConstraint == nil {
            heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
            addConstraint(heightConstraint!)
        }
        
        if widthConstraint == nil {
            widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width)
            addConstraint(widthConstraint!)
        }
        
        if height != heightConstraint!.constant {
            heightConstraint!.constant = height
        }
        
        if width != widthConstraint!.constant {
            widthConstraint!.constant = width
        }
        
        if hasDragged {
            center = CGPoint(x: x, y: y)
        }
    }
    
    // Show placeholder if needed from: https://github.com/KennethTsang/GrowingTextView
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if text.isEmpty && !self.isFirstResponder {
            let xValue = textContainerInset.left + textContainer.lineFragmentPadding
            let yValue = textContainerInset.top
            let width = rect.size.width - xValue - textContainerInset.right
            let height = rect.size.height - yValue - textContainerInset.bottom
            let placeholderRect = CGRect(x: xValue, y: yValue, width: width, height: height)
            
            if let attributedPlaceholder = attributedPlaceholder {
                // Prefer to use attributedPlaceholder
                attributedPlaceholder.draw(in: placeholderRect)
            } else {
                // Otherwise user placeholder and inherit `text` attributes
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = textAlignment
                var attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: placeholderColor,
                    .paragraphStyle: paragraphStyle
                ]
                if let font = font {
                    attributes[.font] = font
                }
                
                placeholder.draw(in: placeholderRect, withAttributes: attributes)
            }
        }
    }
    
    private func getSize(of text: String) -> CGSize {
        let dummyTextView = UITextView(frame: .zero)
        dummyTextView.font = font
        dummyTextView.text = text
        dummyTextView.sizeToFit()
        return dummyTextView.bounds.size
    }
    
    private func translate(_ translation: CGPoint) {
        guard let superview = superview else { return }
        let destinationX = center.x + translation.x
        let destinationY = center.y + translation.y
        let minX = frame.width / 2
        let minY = frame.height / 2
        let maxX = superview.frame.width - minX
        let maxY = superview.frame.height - minY
        x = min(maxX, max(minX, destinationX))
        y = min(maxY ,max(minY, destinationY))
        center = CGPoint(x: x, y: y)
    }
    
    @objc func dragging(_ gesture: UIPanGestureRecognizer) {
        if drag == .always || (drag == .whenEditing && self.isFirstResponder) {
            translate(gesture.translation(in: self))
            gesture.setTranslation(.zero, in: self)
            hasDragged = true
        }
    }
    
    @objc func textDidBeginEditing(notification: Notification) {
        if let sender = notification.object as? MarkupTextView, sender == self {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
        }
    }

    @objc func textDidEndEditing(notification: Notification) {
        if let sender = notification.object as? MarkupTextView, sender == self {
            layer.borderWidth = 0.0
            setNeedsLayout()
        }
    }
    
    @objc func textDidChange(notification: Notification) {
        if let sender = notification.object as? MarkupTextView, sender == self {
            setNeedsLayout()
        }
    }
}
