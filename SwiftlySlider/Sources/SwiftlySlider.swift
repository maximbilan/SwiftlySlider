//
//  SwiftlySlider.swift
//  SwiftlySlider
//
//  Created by Maxim Bilan on 6/6/16.
//  Copyright © 2016 Maxim Bilan. All rights reserved.
//

import UIKit

public protocol SwiftlySliderDelegate : class {
	func swiftlySliderValueChanged(_ value: Int)
}

open class SwiftlySlider: UIView {
	
	// MARK: - Direction
	
	public enum PickerDirection: Int {
		case horizontal
		case vertical
	}
	
	// MARK: - Public properties
	
	open weak var delegate: SwiftlySliderDelegate!
	open var direction: PickerDirection = .horizontal
	open var currentValue: Int {
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
	open var minValue: Int = 0
	open var maxValue: Int = 20
	open var normalValue: Int = 0
	
	// MARK: - Additional public properties
	
	open var labelFontColor: UIColor = UIColor.white
	open var labelBackgroundColor: UIColor = UIColor.black
	open var labelFont = UIFont(name: "Helvetica Neue", size: 12)
	open var bgColor: UIColor = UIColor.white
	open var bgCornerRadius: CGFloat = 30
	open var barColor: UIColor = UIColor.gray
	open var sliderImage: UIImage?
	open var sliderImageOffset: CGPoint = CGPoint.zero
	open var sliderSize: CGSize = CGSize.zero
	open var useNormalIndicator = false
	
	// MARK: - Private properties
	
	fileprivate var value: Int = 0
	fileprivate var image: UIImage!
	fileprivate var currentSelectionY: CGFloat = 0
	fileprivate var currentSelectionX: CGFloat = 0
	
	// MARK: - Initialization
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.backgroundColor = UIColor.clear
		value = minValue
	}
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = UIColor.clear
		value = minValue
	}
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		
		update()
	}
	
	// MARK: - Prerendering
	
	func generateHUEImage(_ size: CGSize) -> UIImage {
		
		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		var barRect = CGRect.null
		if direction == .horizontal {
			let barHeight = size.height * 0.2
			barRect = CGRect(x: 0, y: size.height * 0.5 - barHeight * 0.5, width: size.width, height: barHeight)
		}
		else {
			let barWidth = size.width * 0.2
			barRect = CGRect(x: size.width * 0.5 - barWidth * 0.5, y: 0, width: barWidth, height: size.height)
		}
		
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		
		UIBezierPath(roundedRect: barRect, cornerRadius: bgCornerRadius).addClip()
		
		bgColor.set()
		UIRectFill(rect)
		
		let context = UIGraphicsGetCurrentContext()
		barColor.set()
		
		context!.setFillColor(barColor.cgColor.components!)
		context!.fill(barRect)
		
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return image
	}
	
	// MARK: - Updating
	
	func update() {
		
		let offset = (direction == .horizontal ? self.frame.size.height : self.frame.size.width)
		let halfOffset = offset * 0.5
		var size = self.frame.size
		if direction == .horizontal {
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
	
	override open func draw(_ rect: CGRect) {
		super.draw(rect)
		
		let context = UIGraphicsGetCurrentContext()
		
		if useNormalIndicator {
			var barRect = CGRect.null
			if direction == .horizontal {
				let barHeight = rect.size.height * 0.2
				
				barRect = CGRect(x: 0, y: rect.size.height * 0.5 - barHeight * 0.5, width: rect.size.width, height: barHeight)
			}
			else {
				let barWidth = rect.size.width * 0.2
				barRect = CGRect(x: rect.size.width * 0.5 - barWidth * 0.5, y: 0, width: barWidth, height: rect.size.height)
			}
			
			let offset = (direction == .horizontal ? self.frame.size.height : self.frame.size.width)
			let halfOffset = offset * 0.5
			var size = self.frame.size
			let trianglePath = UIBezierPath()
			if direction == .horizontal {
				size.width -= offset
				let triangleHeight = rect.size.height * 0.3
				let triangleX = ((CGFloat(normalValue - minValue) * (size.width)) / CGFloat(maxValue - minValue)) + halfOffset
				trianglePath.move(to: CGPoint(x: triangleX, y: barRect.origin.y))
				trianglePath.addLine(to: CGPoint(x: triangleX - triangleHeight * 0.5, y: barRect.origin.y - triangleHeight))
				trianglePath.addLine(to: CGPoint(x: triangleX + triangleHeight * 0.5, y: barRect.origin.y - triangleHeight))
				trianglePath.addLine(to: CGPoint(x: triangleX, y: barRect.origin.y))
			}
			else {
				size.height -= offset
				let triangleWidth = rect.size.width * 0.3
				let triangleY = ((CGFloat(normalValue - minValue) * (size.height)) / CGFloat(maxValue - minValue)) + halfOffset
				trianglePath.move(to: CGPoint(x: barRect.origin.x, y: triangleY))
				trianglePath.addLine(to: CGPoint(x: barRect.origin.x - triangleWidth, y: triangleY - triangleWidth * 0.5))
				trianglePath.addLine(to: CGPoint(x: barRect.origin.x - triangleWidth, y: triangleY + triangleWidth * 0.5))
				trianglePath.addLine(to: CGPoint(x: barRect.origin.x, y: triangleY))
			}
			
			context!.setFillColor(barColor.cgColor)
			trianglePath.fill()
		}
		
		let radius = (direction == .horizontal ? self.frame.size.height : self.frame.size.width)
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
		
		let circleRect = (direction == .horizontal ? CGRect(x: circleX, y: 0, width: radius, height: radius) : CGRect(x: 0, y: circleY, width: radius, height: radius))
		let circleColor = labelBackgroundColor
		var imageRect = rect
		
		if image != nil {
			if direction == .horizontal {
				imageRect.size.width -= radius
				imageRect.origin.x += halfRadius
			}
			else {
				imageRect.size.height -= radius
				imageRect.origin.y += halfRadius
			}
			image.draw(in: imageRect)
		}
		
		if let image = sliderImage {
			context!.translateBy(x: 0, y: imageRect.size.height)
			context!.scaleBy(x: 1.0, y: -1.0)
			context!.draw(image.cgImage!, in: (sliderSize != CGSize.zero ? CGRect(x: circleRect.origin.x + sliderImageOffset.x, y: radius * 0.5 - sliderSize.height * 0.5 + sliderImageOffset.y, width: sliderSize.width, height: sliderSize.height) : circleRect))
		}
		else {
			circleColor.set()
			context!.addEllipse(in: circleRect)
			context!.setFillColor(circleColor.cgColor.components!)
			context!.fillPath()
			context!.strokePath()
			
			let textParagraphStyle = NSMutableParagraphStyle()
			textParagraphStyle.alignment = .center
			
			let attributes: NSDictionary = [NSForegroundColorAttributeName: labelFontColor,
			                                NSParagraphStyleAttributeName: textParagraphStyle,
			                                NSFontAttributeName: labelFont!]
			
			let text: NSString = "\(value)" as NSString
			var textRect = circleRect
			textRect.origin.y += (textRect.size.height - (labelFont?.lineHeight)!) * 0.5
			text.draw(in: textRect, withAttributes: attributes as? [String : AnyObject])
		}
	}
	
	// MARK: - Touch events
	
	override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch: AnyObject? = touches.first
		let point = touch!.location(in: self)
		handleTouch(point)
	}
	
	override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch: AnyObject? = touches.first
		let point = touch!.location(in: self)
		handleTouch(point)
	}
	
	override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch: AnyObject? = touches.first
		let point = touch!.location(in: self)
		handleTouch(point)
	}
	
	override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
	}
	
	// MARK: - Touch handling
	
	func handleTouch(_ touchPoint: CGPoint) {
		currentSelectionX = touchPoint.x
		currentSelectionY = touchPoint.y
		
		let offset = (direction == .horizontal ? self.frame.size.height : self.frame.size.width)
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
		
		let percent = (direction == .horizontal ? CGFloat((currentSelectionX - halfOffset) / (self.frame.size.width - offset))
			: CGFloat((currentSelectionY - halfOffset) / (self.frame.size.height - offset)))
		value = minValue + Int(percent * CGFloat(maxValue - minValue))
		
		if delegate != nil {
			delegate.swiftlySliderValueChanged(value)
		}
		
		setNeedsDisplay()
	}
	
}
