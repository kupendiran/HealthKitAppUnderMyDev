
import Foundation
import UIKit


//MARK: - UILabel
@IBDesignable class CustomUILabel: UILabel {
    
    //Se the corner radius
    override func draw(_ rect: CGRect) {
        labelSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        labelSetup()         //to show the corner radius in interface builder
    }
    
    //Label setup
    func labelSetup() {
        layer.cornerRadius = frame.size.height/2
        layer.masksToBounds = true
    }
}
//MARK: - UIButton
@IBDesignable class CustomUIButton: UIButton {
    
    //Se the corner radius
    override func draw(_ rect: CGRect) {
        buttonSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        buttonSetup()         //to show the corner radius in interface builder
    }
    
    //Button setup
    func buttonSetup() {
        layer.cornerRadius = frame.size.height/2
        layer.masksToBounds = true
    }
}

//MARK: - UIView Corner Radius
@IBDesignable class CustomUIView: UIView {
    
    override func draw(_ rect: CGRect) {
        viewSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        viewSetup()         //to show the corner radius in interface builder
    }
    //view setup
    func viewSetup() {
        layer.cornerRadius = frame.size.height/2
        layer.masksToBounds = true
    }
}


@IBDesignable class ShadowView: UIView {
    @IBInspectable var shadow : Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadiusWithShadow : CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    func addShadow(shadowColor: CGColor = UIColor.darkGray.cgColor,
                   shadowOffset: CGSize = CGSize(width: -1.0, height: 1.0),
                   shadowOpacity: Float = 0.3,
                   shadowRadius: CGFloat = 2.0) {
        layer.masksToBounds = false
        layer.shadowOffset = shadowOffset
        layer.shadowColor = shadowColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}

@IBDesignable class ShadowButton: UIButton {
    @IBInspectable var shadow : Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadiusWithShadow : CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    func addShadow(shadowColor: CGColor = UIColor.darkGray.cgColor,
                   shadowOffset: CGSize = CGSize(width: -1.0, height: 1.0),
                   shadowOpacity: Float = 0.3,
                   shadowRadius: CGFloat = 2.0) {
        layer.masksToBounds = false
        layer.shadowOffset = shadowOffset
        layer.shadowColor = shadowColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}


//
//MARK: - Sparkl background view
//
@IBDesignable class CustomBackgroundUIView : UIView {
    
    //Se the corner radius
    override func awakeFromNib() {
        super.awakeFromNib()            //Initialize the NIB
        backgroundViewSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        backgroundViewSetup()         //to show the corner radius in interface builder
    }
    
    //Button setup
    func backgroundViewSetup() {
        let shapeLayer = CAShapeLayer(layer:layer)
        
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:layer.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:layer.bounds.size.width, y:layer.bounds.size.height - (layer.bounds.size.height*0.15)))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:layer.bounds.size.height - (layer.bounds.size.height*0.15)), controlPoint: CGPoint(x:layer.bounds.size.width/2, y:layer.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        
        shapeLayer.path = arrowPath.cgPath
        shapeLayer.frame = layer.bounds
        shapeLayer.masksToBounds = true
        layer.mask = shapeLayer
    }
}

//
//MARK: - UITextField
//
extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    //Adding done button for UItextfield
    @IBInspectable var addDoneAccessory: Bool{
        get{
            return self.addDoneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {        //add button
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {     //remove keyboard
        self.resignFirstResponder()
    }
}

//
//MARK: - UIView
//
extension UIView {
    
    //Corner Radius
    @IBInspectable var cornerRadius : CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    //Border Width
    @IBInspectable var borderWidth : CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    //Border Color
    @IBInspectable var borderColor : UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    // The color of the shadow. Defaults to opaque black. Colors created from patterns are currently NOT supported. Animatable.
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            layer.masksToBounds = false
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    //The opacity of the shadow. Defaults to 0. Specifying a value outside the [0,1] range will give undefined results. Animatable.
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            layer.masksToBounds = false
            self.layer.shadowOpacity = newValue
        }
    }
    
    //The shadow offset. Defaults to (0, -3). Animatable.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            layer.masksToBounds = false
            self.layer.shadowOffset = newValue
        }
    }
    
    //The blur radius used to create the shadow. Defaults to 3. Animatable.
    @IBInspectable var shadowRadius: Double {
        get {
            return Double(self.layer.shadowRadius)
        }
        set {
            layer.masksToBounds = false
            self.layer.shadowRadius = CGFloat(newValue)
        }
    }
}


//Kupe code
private var startGradientColorAssociatedKey : UIColor = .black
private var endGradientColorAssociatedKey : UIColor = .black
private var observationGradientView: NSKeyValueObservation?

extension UIView {
    
    @IBInspectable var startGradientColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &startGradientColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &startGradientColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    @IBInspectable var endGradientColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &endGradientColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &endGradientColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @IBInspectable var isTopToBottomGradient: Bool {
        get {
            return self.isTopToBottomGradient
        }
        set {
            DispatchQueue.main.async {
                if newValue {
                    self.setGradientBackgroundVertical(colorLeft: self.startGradientColor, colorRight: self.endGradientColor)
                } else {
                    self.setGradientBackground(colorLeft: self.startGradientColor, colorRight: self.endGradientColor)
                }
            }
        }
    }
    
    func setGradientBackground(colorLeft: UIColor, colorRight: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorLeft.cgColor, colorRight.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)//0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)//0.5)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        observationGradientView = self.observe(\.bounds, options: .new) { [weak gradientLayer] view, change in
            if let value =  change.newValue {
                gradientLayer?.frame = value
            }
        }
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func setGradientBackgroundVertical(colorLeft: UIColor, colorRight: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorLeft.cgColor, colorRight.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        observationGradientView = self.observe(\.bounds, options: .new) { [weak gradientLayer] view, change in
            if let value =  change.newValue {
                gradientLayer?.frame = value
            }
        }
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}


//MARK: This is the CLASS file to add gradiant for UIView. (Note: You must add "Gradient" name as UIView) Start,,,,,
@IBDesignable public class Gradient: UIView {
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }

}
//MARK: This is the CLASS file to add gradiant for UIView. (Note: You must add "Gradient" name as UIView) End,,,,,
