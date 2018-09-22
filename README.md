# SwiftlySlider

[![Version](https://img.shields.io/cocoapods/v/SwiftlySlider.svg?style=flat)](http://cocoadocs.org/docsets/SwiftlySlider)
[![License](https://img.shields.io/cocoapods/l/SwiftlySlider.svg?style=flat)](http://cocoadocs.org/docsets/SwiftlySlider)
[![Platform](https://img.shields.io/cocoapods/p/SwiftlySlider.svg?style=flat)](http://cocoadocs.org/docsets/SwiftlySlider)
[![CocoaPods](https://img.shields.io/cocoapods/dt/SwiftlySlider.svg)](https://cocoapods.org/pods/SwiftlySlider)
[![CocoaPods](https://img.shields.io/cocoapods/dm/SwiftlySlider.svg)](https://cocoapods.org/pods/SwiftlySlider)

A simple iOS slider control.

![alt tag](https://raw.github.com/maximbilan/SwiftlySlider/master/img/1.png)

## Installation
<b>CocoaPods</b>:
<pre>
pod 'SwiftlySlider'
</pre>
<b>Manual</b>:
<pre>
Just copy the <i>SwiftlySlider.swift</i> into your project.
</pre>

## Using

You can create from <i>Storyboard</i> or <i>XIB</i>. Or create manually:
<pre>
let slider = SwiftlySlider()
</pre>

For handling changing of values you should implement a protocol <i>SwiftlySliderDelegate</i>:

<pre>
slider.delegate = self

func swiftlySliderValueChanged(value: Int) {
}
</pre>

Direction:
<pre>
picker.direction = SwiftlySlider.PickerDirection.Horizontal // Vertical, Horizontal
</pre>

Also you can change the current value, the maximum value or the minimum value, for example:
<pre>
picker.currentValue = 0
picker.maxValue     = 30
picker.minValue     = 1
</pre>

Slider settings:

<pre>
sliderImage       // Custom an image of the slider
sliderImageOffset // A offset of the custom slider position
sliderSize        // A size of the custom slider position
</pre>

Example:

<pre>
slider.sliderImage = UIImage(named: "CustomSlider")
slider.sliderImageOffset = CGPoint(x: 0, y: -1)
slider.sliderSize = CGSize(width: 30, height: 15)
</pre>

Normal indicator:

<pre>
useNormalIndicator  // Use a normal indicator
normalValue         // A normal value
</pre>

Color settings:
<pre>
labelFontColor        // A font color of the moving label
labelBackgroundColor  // A background color of the moving label
labelFont             // A font of the moving label
bgColor               // A background color
</pre>

You can easily found the example in this repository.

## License

SwiftlySlider is available under the MIT license. See the LICENSE file for more info.
