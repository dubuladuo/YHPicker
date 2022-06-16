//
//  YHPickerStyle.swift
//  YHPickerDemo
//
//  Created by 刘勇航 on 2022/5/30.
//

import UIKit
///按钮边框样式
enum YHPickerButtonBorderStyle {
    ///无边框（默认）
    case none
    ///有圆角和边框
    case solid
    ///仅有圆角
    case fill
}

let kYHDefaultTextColor: UIColor = UIColor.init(hex: "#333333", alpha: 1) ?? .black
let kYHDefaultWidowWidth: CGFloat = YHGETKeyWindow()?.bounds.size.width ?? 100

class YHPickerLineStyle: NSObject {
    var color: UIColor
    var isHidden: Bool = false
    private var _height: CGFloat = 0.5
    var height: CGFloat {
        set {
            if newValue > 0 && newValue <= 5.0 {
                _height = newValue
            }
        }
        get {
         return _height
        }
    }
    
    init(color: UIColor?) {
        self.color = color ?? UIColor.clear
    }
}

class YHPickerStyle: NSObject {
    var maskStyle: YHPickerMaskStyle            = YHPickerMaskStyle()
    var alertStyle: YHPickerAlertStyle          = YHPickerAlertStyle()
    var titleBarStyle: YHPickerTitleBarStyle    = YHPickerTitleBarStyle()
    var pickerViewStyle: YHPickerViewStyle      = YHPickerViewStyle()
}

//MARK: 背景
///蒙层视图
class YHPickerMaskStyle: NSObject {
    var color: UIColor = UIColor.init(hex: "#000000", alpha: 0.3) ?? UIColor.clear
    var isHidden: Bool = false
}

/// 弹窗视图
class YHPickerAlertStyle: NSObject {
    var color: UIColor?
    ///视图左上角和右上角圆角半径
    var topCornerRadius: CGFloat = 0
    ///顶部边线框
    lazy var shadowLine: YHPickerLineStyle = {
         var shadowColor = UIColor.init(hex: "#c6c6c8", alpha: 1)
        if #available(iOS 13.0, *) {
            shadowColor = UIColor.separator
        }
        return YHPickerLineStyle.init(color:shadowColor)
    }()
    ///弹框底部内边距，默认为底部安全间距
    private var _paddingBottom: CGFloat = YHBOTTOMMARGIN()
    var paddingBottom: CGFloat {
        set {
            if newValue > 0 {
                _paddingBottom = newValue
            }
        }
        get {
            return _paddingBottom
        }
    };
}

//MARK: titleBar
class YHPickerTitleLabelStyle: NSObject {
    var color: UIColor = .clear
    lazy var textColor: UIColor = {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        } else {
            return .init(hex: "#999999", alpha: 1) ?? .clear
        }
    }()
    var textFont: UIFont = UIFont.systemFont(ofSize: 15)
    private var _frame: CGRect
    var frame: CGRect {
        set {
            if newValue != .zero && newValue.size.height > 0 {
                _frame = frame
            }
        }
        get {
            return _frame
        }
    }
    var isHidden: Bool = false
    
    init(frame: CGRect) {
        _frame = frame
    }
}

class YHPickerButtonStyle: NSObject {
    var color: UIColor = .clear
    lazy var textColor: UIColor = {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return kYHDefaultTextColor
        }
    }()
    var textFont: UIFont = UIFont.systemFont(ofSize: 16.0)
    var borderStyle: YHPickerButtonBorderStyle = .none
    var cornerRadius: CGFloat = 6.0
    var borderWidth: CGFloat = 1.0
    var image: UIImage?
    private var _frame: CGRect
    var frame: CGRect {
        set {
            if newValue != CGRect.zero && newValue.size.height > 0 {
                _frame = newValue
            }
        }
        get {
            return _frame
        }
    }
    private var _title: String?
    var title: String? {
        get { 
            if image != nil {
                return nil
            } else {
                return _title
            }
        }
    }
    var isHidden: Bool = false
    
    init(frame: CGRect, title: String) {
        _frame = frame
        _title = title
    }
    
}

class YHPickerTitleBarStyle: NSObject {
    lazy var color: UIColor = {
        var _color : UIColor = .white
        if #available(iOS 13.0, *) {
            _color = .secondarySystemBackground
        }
        return _color
    }()
    lazy var titleLabelStyle: YHPickerTitleLabelStyle = {
        let frame: CGRect = CGRect(x: 5 + 60 + 2, y: 0, width: kYHDefaultWidowWidth - 2 * (5 + 60 + 2), height: 44)
        return YHPickerTitleLabelStyle.init(frame: frame)
    }()
    lazy var cancelBtnStyle: YHPickerButtonStyle = {
        return YHPickerButtonStyle.init(frame: CGRect(x: 0, y: 8, width: 60, height: 28), title: "取消")
    }()
    lazy var doneBtnStyle:YHPickerButtonStyle = {
        let frame = CGRect(x: kYHDefaultWidowWidth - 60 - 5, y: 8, width: 60, height: 28)
        return YHPickerButtonStyle.init(frame: frame, title: "确定");
    }()
    var isHidden: Bool = false
    private var _height: CGFloat = 44;
    var height: CGFloat {
        set {
            if !isHidden {
                if newValue < 44.0 && (!cancelBtnStyle.isHidden || !doneBtnStyle.isHidden || !titleLabelStyle.isHidden) {
                    _height = 44
                } else {
                    _height = newValue
                }
            } else {
                _height = 0
            }
        }
        get {
            return _height
        }
    }
    ///标题栏底部分割线
    lazy var bottomLine: YHPickerLineStyle = {
        let color = yh_colorWithSystem(lightColor: UIColor.init(hex: "#EDEDEE", alpha: 1), darkCOlor: UIColor.init(hex: "#18181C", alpha: 1))
        return YHPickerLineStyle.init(color: color)
    }()
}

//MARK: pickerView
class YHPickerViewRowStyle: NSObject {
    lazy var textColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.label
        } else {
            return kYHDefaultTextColor
        }
    }()
    var textFont: UIFont = UIFont.systemFont(ofSize: 18)
    var color: UIColor?
    private var _height: CGFloat = 35
    var height: CGFloat {
        set {
            if newValue >= 20 {
                _height = newValue
            }
        }
        get {
            return _height
        }
    }
}

class YHPickerDateUnitStyle: NSObject {
    lazy var textColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.label
        } else {
            return kYHDefaultTextColor
        }
    }()
    var textFont: UIFont = UIFont.systemFont(ofSize: 18)
    var offsetX: Float = 0
    var offsetY: Float = 0
}

class YHPickerViewStyle: NSObject {
    lazy var color: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.secondarySystemGroupedBackground
        } else {
            return UIColor.white
        }
    }()
    lazy var separatorLine: YHPickerLineStyle = {
        var color: UIColor? = UIColor.init(hex: "#C6C6C8", alpha: 1)
        if #available(iOS 13.0, *) {
            color = UIColor.opaqueSeparator
        }
        return YHPickerLineStyle.init(color: color)
    }()
    private var _height: CGFloat = 216
    var height: CGFloat {
        set {
            if newValue >= 40 {
                _height = newValue
            }
        }
        get {
            return _height
        }
    }
    var normalRowStyle: YHPickerViewRowStyle = YHPickerViewRowStyle()
    var selectRowStyle: YHPickerViewRowStyle = YHPickerViewRowStyle()
    //清除iOS14之后选择器默认自带的新样式
    //主要表现是1、隐藏中间选择行的背景样式 2、清除默认内边距 3、新增中间选择行的两条分割线 与iOS14之前的样式保持一致
    var clearPickerNewStyle: Bool = true
    //设置语言
    var language: String?
    //设置日期选择器单位
    var dataUnit: YHPickerDateUnitStyle = YHPickerDateUnitStyle()
    
    ///设置选择器中间选中行的样式
    func setupPickerSelectRowStyle(pickerView: UIPickerView, row: Int, component:Int){
        
    }
    ///添加选择器中间行上下两条分割线（iOS14之后系统默认去掉，需要手动添加）
    func addSeparatorLine(pickerView: UIPickerView) {
    }
}

func yh_colorWithSystem(lightColor: UIColor?, darkCOlor:UIColor?) -> UIColor? {
    if #available(iOS 13.0, *) {
        return UIColor.init {traitCollection in
            if traitCollection.userInterfaceStyle == .light {
                return lightColor ?? UIColor.clear
            } else {
                return darkCOlor ?? UIColor.clear
            }
        }
    }
    return lightColor
}

extension UIColor {
    public convenience init?(hex: String, alpha: CGFloat) {
        let r, g, b: CGFloat
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0x00FF0000) >> 16)/255
                    g = CGFloat((hexNumber & 0x0000FF00) >> 8)/255
                    b = CGFloat(hexNumber & 0x000000FF)/255
                    self.init(red: r, green: g, blue: b, alpha: alpha)
                    return
                }
            }
        }
        return nil
    }
}

func YHGETKeyWindow() -> UIWindow?{
    var keyWindow: UIWindow?
    if #available(iOS 13.0, *) {
        let connectedSecenes = UIApplication.shared.connectedScenes
        for scene in connectedSecenes {
            if scene.activationState == UIScene.ActivationState.foregroundActive && type(of: scene) == UIWindowScene.self {
                let windowScene :UIWindowScene = scene as! UIWindowScene
                for window in windowScene.windows {
                    if window.isKeyWindow {
                        keyWindow = window
                        break
                    }
                }
            }
        }
    } else {
        keyWindow = UIApplication.shared.keyWindow
    }
    return keyWindow
}

func YHBOTTOMMARGIN() -> CGFloat {
    var bottomMargin: CGFloat = 0
    if #available(iOS 11.0, *) {
        bottomMargin = YHGETKeyWindow()?.safeAreaInsets.bottom ?? 0
    }
    return bottomMargin
}
