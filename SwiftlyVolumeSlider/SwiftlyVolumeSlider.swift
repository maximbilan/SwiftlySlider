//
//  SwiftlyVolumeSlider.swift
//  SwiftlyVolumeSlider
//
//  Created by Maxim Bilan on 6/6/16.
//  Copyright © 2016 Maxim Bilan. All rights reserved.
//

import UIKit

public protocol SwiftlyVolumeSliderDelegate : class {
	func valueChanged(value: Int)
}

public class SwiftlyVolumeSlider: UIView {
	
	// MARK: - Direction
	
	public enum PickerDirection: Int {
		case Horizontal
		case Vertical
	}
	
	// MARK: - Public properties
	
	public weak var delegate: SwiftlyVolumeSliderDelegate!
	public var direction: PickerDirection = .Horizontal
	public var currentValue: Int {
		get {
			return value
		}
		set(newValue) {
			if newValue >= maxValue {
				self.value = maxValue
			}
			else if newValue <= minValue {
				self.value = minValue
			}
			else {
				self.value = newValue
			}
			update()
			setNeedsDisplay()
		}
	}
	public var minValue: Int = 0
	public var maxValue: Int = 20
	
	// MARK: - Additional public properties
	
	public var labelFontColor: UIColor = UIColor.whiteColor()
	public var labelBackgroundColor: UIColor = UIColor.blackColor()
	public var labelFont = UIFont(name: "Helvetica Neue", size: 12)
	public var bgColor: UIColor = UIColor.whiteColor()
	public var bgCornerRadius: CGFloat = 30
	public var barColor: UIColor = UIColor.grayColor()
	public var sliderImage: UIImage?
	public var sliderSize: CGSize = CGSizeZero
	
	// MARK: - Private properties
	
	private var value: Int = 0
	private var image: UIImage!
	private var currentSelectionY: CGFloat = 0.0
	private var currentSelectionX: CGFloat = 0.0
	
	// MARK: - Initialization
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.backgroundColor = UIColor.clearColor()
		value = minValue
	}
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = UIColor.clearColor()
		value = minValue
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		
		update()
	}
	
	// MARK: - Prerendering
	
	func generateHUEImage(size: CGSize) -> UIImage {
		
		let rect = CGRectMake(0, 0, size.width, size.height)
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		
//		UIBezierPath(roundedRect: rect, cornerRadius: bgCornerRadius).addClip()
//		
		bgColor.set()
		UIRectFill(rect)
		
		let context = UIGraphicsGetCurrentContext();
		barColor.set()
		
		let offset = (direction == .Horizontal ? size.height * 0.25 : size.width * 0.25)
		let doubleOffset = offset * 2
		
		//CGContextBeginPath(context);
		if direction == .Horizontal {
			//CGContextMoveToPoint(context, CGRectGetMaxX(rect) - doubleOffset, CGRectGetMinY(rect) + offset);
			//CGContextAddLineToPoint(context, CGRectGetMinX(rect) + doubleOffset, CGRectGetMidY(rect));
			//CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - doubleOffset, CGRectGetMaxY(rect) - offset);
//			CGContextAddArc(context, CGRectGetMaxX(rect) - doubleOffset, CGRectGetMidY(rect), size.height * 0.25, CGFloat(M_PI_2), CGFloat(M_PI), 1)
			
			let barHeight = size.height * 0.2
			let rect = CGRectMake(0, size.height * 0.5 - barHeight * 0.5, size.width, barHeight)
			
			CGContextSetFillColor(context, CGColorGetComponents(barColor.CGColor));
			CGContextFillRect(context, rect)
		}
		else {
//			CGContextMoveToPoint(context, CGRectGetMaxX(rect) - offset, CGRectGetMaxY(rect) - doubleOffset);
//			CGContextAddLineToPoint(context, CGRectGetMidX(rect), CGRectGetMinY(rect) + doubleOffset);
//			CGContextAddLineToPoint(context, CGRectGetMinX(rect) + offset, CGRectGetMaxY(rect) - doubleOffset);
//			CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMaxY(rect) - doubleOffset, size.width * 0.25, CGFloat(M_PI), CGFloat(M_PI + M_PI_2), 1)
			
			let barWidth = size.width * 0.2
			let rect = CGRectMake(size.width * 0.5 - barWidth * 0.5, 0, barWidth, size.height)
			
			CGContextSetFillColor(context, CGColorGetComponents(barColor.CGColor));
			CGContextFillRect(context, rect)
		}
//		CGContextClosePath(context);
//		CGContextSetFillColor(context, CGColorGetComponents(barColor.CGColor));
//		CGContextFillPath(context);
//		CGContextStrokePath(context);
		
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
	
	// MARK: - Updating
	
	func update() {
		
		let offset = (direction == .Horizontal ? self.frame.size.height : self.frame.size.width)
		let halfOffset = offset * 0.5
		var size = self.frame.size
		if direction == .Horizontal {
			size.width -= offset
		}
		else {
			size.height -= offset
		}
		
		currentSelectionX = ((CGFloat(value - minValue) * (size.width)) / CGFloat(maxValue - minValue)) + halfOffset
		currentSelectionY = ((CGFloat(value - minValue) * (size.height)) / CGFloat(maxValue - minValue)) + halfOffset
		
		image = generateHUEImage(self.frame.size)
	}
	
	// MARK: - Drawing
	
	override public func drawRect(rect: CGRect) {
		super.drawRect(rect)
		
		let radius = (direction == .Horizontal ? self.frame.size.height : self.frame.size.width)
		let halfRadius = radius * 0.5
		var circleX = currentSelectionX - halfRadius
		var circleY = currentSelectionY - halfRadius
		if circleX >= rect.size.width - radius {
			circleX = rect.size.width - radius
		}
		else if circleX < 0 {
			circleX = 0
		}
		if circleY >= rect.size.height - radius {
			circleY = rect.size.height - radius
		}
		else if circleY < 0 {
			circleY = 0
		}
		
		let circleRect = (direction == .Horizontal ? CGRectMake(circleX, 0, radius, radius) : CGRectMake(0, circleY, radius, radius))
		let circleColor = labelBackgroundColor
		var imageRect = rect
		
		if image != nil {
			if direction == .Horizontal {
				imageRect.size.width -= radius
				imageRect.origin.x += halfRadius
			}
			else {
				imageRect.size.height -= radius
				imageRect.origin.y += halfRadius
			}
			image.drawInRect(imageRect)
		}
		
		let context = UIGraphicsGetCurrentContext();
		if let image = sliderImage {
			CGContextDrawImage(context, (sliderSize != CGSizeZero ? CGRectMake(circleRect.origin.x, radius * 0.5 - sliderSize.height * 0.5, sliderSize.width, sliderSize.height) : circleRect), image.CGImage)
		}
		else {
			circleColor.set()
			CGContextAddEllipseInRect(context, circleRect)
			CGContextSetFillColor(context, CGColorGetComponents(circleColor.CGColor))
			CGContextFillPath(context)
			CGContextStrokePath(context)
		}
		
		let textParagraphStyle = NSMutableParagraphStyle()
		textParagraphStyle.alignment = .Center
		
		let attributes: NSDictionary = [NSForegroundColorAttributeName: labelFontColor,
		                                NSParagraphStyleAttributeName: textParagraphStyle,
		                                NSFontAttributeName: labelFont!]
		
		let text: NSString = "\(value)"
		var textRect = circleRect
		textRect.origin.y += (textRect.size.height - (labelFont?.lineHeight)!) * 0.5
		text.drawInRect(textRect, withAttributes: attributes as? [String : AnyObject])
	}
	
	// MARK: - Touch events
	
	override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let touch: AnyObject? = touches.first
		let point = touch!.locationInView(self)
		handleTouch(point)
	}
	
	override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let touch: AnyObject? = touches.first
		let point = touch!.locationInView(self)
		handleTouch(point)
	}
	
	override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let touch: AnyObject? = touches.first
		let point = touch!.locationInView(self)
		handleTouch(point)
	}
	
	override public func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		
	}
	
	// MARK: - Touch handling
	
	func handleTouch(touchPoint: CGPoint) {
		currentSelectionX = touchPoint.x
		currentSelectionY = touchPoint.y
		
		let offset = (direction == .Horizontal ? self.frame.size.height : self.frame.size.width)
		let halfOffset = offset * 0.5
		if currentSelectionX < halfOffset {
			currentSelectionX = halfOffset
		}
		else if currentSelectionX >= self.frame.size.width - halfOffset {
			currentSelectionX = self.frame.size.width - halfOffset
		}
		if currentSelectionY < halfOffset {
			currentSelectionY = halfOffset
		}
		else if currentSelectionY >= self.frame.size.height - halfOffset {
			currentSelectionY = self.frame.size.height - halfOffset
		}
		
		let percent = (direction == .Horizontal ? CGFloat((currentSelectionX - halfOffset) / (self.frame.size.width - offset))
			: CGFloat((currentSelectionY - halfOffset) / (self.frame.size.height - offset)))
		value = minValue + Int(percent * CGFloat(maxValue - minValue))
		
		if delegate != nil {
			delegate.valueChanged(value)
		}
		
		setNeedsDisplay()
	}
	
}
