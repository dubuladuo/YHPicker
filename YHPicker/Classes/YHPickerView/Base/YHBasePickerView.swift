//
//  YHBasePickerView.swift
//  YHPickerDemo
//
//  Created by 刘勇航 on 2022/5/30.
//

import UIKit

typealias buttonAction = (_ button: UIButton) -> Void

class YHBasePickerView: UIView {
    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    public var cancelButtonAction: buttonAction?
    public var doneButtonAction: buttonAction?
    
    public var pickerHeaderView: UIView?
    public var pickerFooterView: UIView?
    
    
    public var pickerStyle: YHPickerStyle = YHPickerStyle()
    
    public func reloadData() {
        
    }
    
    public func addPickerToView(view: UIView?){
        if let superView = view{
            self.frame = superView.bounds
            self.autoresizingMask = [.flexibleBottomMargin, .flexibleRightMargin, .flexibleWidth, .flexibleHeight]
            if let headerView = pickerHeaderView {
                let rect = headerView.frame
                headerView.frame = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
                headerView.autoresizingMask = .flexibleWidth
                self.addSubview(headerView)
            }
            if let footerView = pickerFooterView {
                let rect = footerView.frame
                footerView.frame = CGRect(x: 0, y: superView.bounds.size.height - rect.size.height, width: rect.size.width, height: rect.size.height)
                footerView.autoresizingMask = .flexibleWidth
                self.addSubview(footerView)
            }
            superView.addSubview(self)
        } else {
            setupUI()
            if let headerView = pickerHeaderView {
                let rect = headerView.frame
                let titleBarHeight: CGFloat = pickerStyle.titleBarStyle.isHidden ? 0 : pickerStyle.titleBarStyle.height
                headerView.frame = CGRect(x: 0, y: titleBarHeight, width: alertView.bounds.size.width, height: rect.size.height)
                headerView.autoresizingMask = .flexibleWidth
                alertView.addSubview(headerView)
            }
            if let footerView = pickerFooterView {
                let rect = footerView.frame
                footerView.frame = CGRect(x: 0, y: alertView.bounds.size.height - pickerStyle.alertStyle.paddingBottom - rect.size.height, width: rect.size.width, height: rect.size.height)
                footerView.autoresizingMask = .flexibleWidth
                alertView.addSubview(footerView)
            }
            self.keyView.addSubview(self)
            var rect = alertView.frame
            rect.origin.y = bounds.self.height
            alertView.frame = rect
            if !pickerStyle.maskStyle.isHidden {
                maskBgView.alpha = 0
            }
            UIView.animate(withDuration: 0.3) {
                if !self.pickerStyle.maskStyle.isHidden {
                    self.maskBgView.alpha = 1
                }
                let alertHeight: CGFloat = self.alertView.bounds.size.height
                var rect = self.alertView.frame
                rect.origin.y = rect.origin.y - alertHeight
                self.alertView.frame = rect
            }
        }
    }
    
    public func addSubViewToTitleBar(view: UIView){
        if !pickerStyle.titleBarStyle.isHidden {
            titleBarView.addSubview(view)
        }
    }
    
    //MARK: 移除视图方法
    public func removePickerFromView(view: UIView?) {
        if let currentView = view {
            currentView.removeFromSuperview()
        } else {
            UIView.animate(withDuration: 0.2) {
                let height: CGFloat = self.alertView.bounds.size.height
                var rect: CGRect = self.alertView.frame
                rect.origin.y = height + rect.origin.y
                self.alertView.frame = rect
                if !self.pickerStyle.maskStyle.isHidden {
                    self.maskBgView.alpha = 0
                }
                
            } completion: { finished in
                self.removeFromSuperview()
            }
        }
    }
    
    public func addSeparatorLine(view:UIView) {
        let systemVersion = Float(UIDevice.current.systemVersion) ?? 14.0
        if systemVersion > 14.0 {
            let topY = view.bounds.size.height / 2 - pickerStyle.pickerViewStyle.selectRowStyle.height/2 - pickerStyle.pickerViewStyle.separatorLine.height
            let bottomY = view.bounds.size.height / 2 + pickerStyle.pickerViewStyle.selectRowStyle.height/2 - pickerStyle.pickerViewStyle.separatorLine.height
            let lineHeight = pickerStyle.pickerViewStyle.separatorLine.height
            let topLine = UIView.init(frame: CGRect(x: 0, y: topY, width: view.bounds.size.width, height: lineHeight))
            topLine.autoresizingMask = [.flexibleBottomMargin, .flexibleRightMargin, .flexibleWidth]
            topLine.backgroundColor = pickerStyle.pickerViewStyle.separatorLine.color
            view.addSubview(topLine)
            
            let bottomLine = UIView.init(frame: CGRect(x: 0, y: bottomY, width: view.bounds.size.width, height: lineHeight))
            bottomLine.autoresizingMask = [.flexibleBottomMargin, .flexibleRightMargin, .flexibleWidth]
            bottomLine.backgroundColor = pickerStyle.pickerViewStyle.separatorLine.color
            view.addSubview(bottomLine)
        }
    }
    
    public func updatePickerSelectRowStyle(pickerView: UIPickerView, row: Int, component: Int) {
        //1、设置分割线颜色
        let systemVersion = Float(UIDevice.current.systemVersion) ?? 14.0
        if systemVersion < 14.0 {
            updateSeparatorLine(view: pickerView)
        }
        //2、设置选择器中间选中行的背景颜色
        if let contentView = pickerView.subviews.first {
            updateSelectRowColor(view: contentView)
            if pickerStyle.pickerViewStyle.clearPickerNewStyle {
                if systemVersion > 14.0 {
                    //隐藏中间选中行的背景样式
                    if let lastView = pickerView.subviews.last {
                        lastView.isHidden = true
                    }
                    //清除iOS14上选择器的默认边距
                    if systemVersion < 15.0 {
                        clearAllSubviewsMargin(view: contentView)
                    }
                }
            }
        }
        //设置选择器中间选中行的字体颜色和大小
        if let selectView = pickerView.view(forRow: row, forComponent: component) {
            if let selectLabel = selectView as? UILabel {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                    selectLabel.textColor = self.pickerStyle.pickerViewStyle.selectRowStyle.textColor
                    selectLabel.font =  self.pickerStyle.pickerViewStyle.selectRowStyle.textFont
                }
            }
        }
    }
    //设置中间的横线
    private func updateSeparatorLine(view: UIView) {
        for subView in view.subviews {
            if subView.frame.size.height <= 1 {
                subView.backgroundColor = pickerStyle.pickerViewStyle.separatorLine.color
                if pickerStyle.pickerViewStyle.separatorLine.height > 0 {
                    var rect = subView.frame
                    rect.size.height = pickerStyle.pickerViewStyle.separatorLine.height
                    subView.frame = rect
                }
            }
        }
    }
    //设置选中的颜色
    private func updateSelectRowColor(view: UIView){
        if let color = pickerStyle.pickerViewStyle.selectRowStyle.color {
            let obj = view.value(forKey: "subviewCache")
            if let columnViews = obj as? [UIView] {
                if let columnObj = columnViews.first {
                    let obj = columnObj.value(forKey: "middleContainerView")
                    if let selectRowView = obj as? UIView {
                        selectRowView.backgroundColor = color
                    }
                }
            }
        }
    }
    
    //遍历子试图，清空iOS14上的内边距
    private func clearAllSubviewsMargin(view: UIView) {
        if NSStringFromClass(view.classForCoder) == "UIPickerColumnView" {
            var rect = view.frame
            rect.origin.x = 0
            if let superView = view.superview {
                rect.size.width = superView.bounds.size.width
            }
            view.frame = rect
        } else if view is UILabel {
            var rect = view.frame
            rect.origin.x = 10
            view.frame = rect
        }
        for subView in view.subviews {
            clearAllSubviewsMargin(view: subView)
        }
    }
    
    private var cancelButtonMargin: CGFloat = 0
    private var doneButtonMargin: CGFloat = 0
    
    private func setupUI() {
        self.frame = keyView.frame
        self.autoresizingMask = [.flexibleBottomMargin, .flexibleRightMargin, .flexibleWidth, .flexibleHeight]
        if !pickerStyle.maskStyle.isHidden {
            self.addSubview(maskBgView)
        }
        
        self.addSubview(alertView)
        
        if !pickerStyle.titleBarStyle.isHidden {
            alertView.addSubview(titleBarView)
            alertView.sendSubviewToBack(titleBarView)
            
            if !pickerStyle.titleBarStyle.titleLabelStyle.isHidden {
                titleBarView.addSubview(titleLabel)
            }
            
            if !pickerStyle.titleBarStyle.cancelBtnStyle.isHidden {
                titleBarView.addSubview(cancelButton)
                if pickerStyle.titleBarStyle.cancelBtnStyle.frame.origin.x < bounds.size.width/2 {
                    cancelButtonMargin = pickerStyle.titleBarStyle.cancelBtnStyle.frame.origin.x
                } else {
                    cancelButtonMargin = bounds.size.width - pickerStyle.titleBarStyle.cancelBtnStyle.frame.origin.x - pickerStyle.titleBarStyle.cancelBtnStyle.frame.size.width
                }
            }
            if !pickerStyle.titleBarStyle.doneBtnStyle.isHidden {
                titleBarView.addSubview(doneButton)
                if pickerStyle.titleBarStyle.doneBtnStyle.frame.origin.x < bounds.size.width/2 {
                    doneButtonMargin = pickerStyle.titleBarStyle.doneBtnStyle.frame.origin.x
                } else {
                    doneButtonMargin = bounds.size.width - pickerStyle.titleBarStyle.doneBtnStyle.frame.origin.x - pickerStyle.titleBarStyle.doneBtnStyle.frame.size.width
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let btn = _cancelButton {
            btn.frame = updateBtnFrame(frame: pickerStyle.titleBarStyle.cancelBtnStyle.frame, margin: cancelButtonMargin)
        }
        if let btn = _doneButton {
            btn.frame = updateBtnFrame(frame: pickerStyle.titleBarStyle.doneBtnStyle.frame, margin: doneButtonMargin)
        }
        if let view = _alertView{
            view.yh_setupCormers(corners: [.topLeft, .topRight], radius: pickerStyle.alertStyle.topCornerRadius)
        }
    }
    
    private func updateBtnFrame(frame:CGRect, margin: CGFloat) -> CGRect {
        var btnFrame = frame
        if #available(iOS 11.0, *) {
            if frame.origin.x < min(bounds.size.width/2, bounds.size.height/2) {
                btnFrame.origin.x = frame.origin.x + safeAreaInsets.left
            } else {
                btnFrame.origin.x = bounds.size.width - frame.size.width - safeAreaInsets.right - margin
            }
        }
        return btnFrame
    }
    
    
    //MARK: action
    
    @objc func didTapMaskView(){
        removePickerFromView(view: nil)
    }
    @objc private func cancelDidClick() {
        removePickerFromView(view: nil)
        if let action = cancelButtonAction {
            action(cancelButton)
        }
    }
    
    @objc private func doneDidClick() {
        if let action = doneButtonAction {
            action(doneButton)
        }
    }
    
    
    
    //MARK: lazy
    private lazy var maskBgView: UIView = {
        let view = UIView.init(frame: keyView.frame)
        view.backgroundColor = pickerStyle.maskStyle.color
        view.autoresizingMask = [.flexibleBottomMargin, .flexibleRightMargin, .flexibleWidth, .flexibleHeight]
        view.isUserInteractionEnabled = true
        let myTap = UITapGestureRecognizer.init(target: self, action: #selector(didTapMaskView))
        view.addGestureRecognizer(myTap)
        return view
    }()
    
    private var _alertView: UIView?
    lazy var alertView: UIView = {
        var accessoryHeight: CGFloat = (pickerHeaderView?.frame.size.height ?? 0.0) + (pickerFooterView?.frame.size.height ?? 0.0)
        var height: CGFloat = pickerStyle.titleBarStyle.height + pickerStyle.pickerViewStyle.height + pickerStyle.alertStyle.paddingBottom + accessoryHeight
        let view = UIView.init(frame: CGRect(x: 0, y: keyView.bounds.size.height - height, width: keyView.bounds.size.width, height: height))
        view.backgroundColor = pickerStyle.alertStyle.color ?? pickerStyle.pickerViewStyle.color
        if pickerStyle.alertStyle.topCornerRadius == 0 && !pickerStyle.alertStyle.shadowLine.isHidden {
            let line: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: pickerStyle.alertStyle.shadowLine.height))
            line.backgroundColor = pickerStyle.alertStyle.shadowLine.color
            line.autoresizingMask = .flexibleWidth
            view.addSubview(line)
        }
        view.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin, .flexibleWidth]
        _alertView = view
        return view
    }()
    
    private lazy var titleBarView: UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: keyView.bounds.size.width, height: pickerStyle.titleBarStyle.height))
        view.backgroundColor = pickerStyle.titleBarStyle.color
        view.autoresizingMask = .flexibleWidth
        if !pickerStyle.titleBarStyle.bottomLine.isHidden {
            if pickerStyle.titleBarStyle.bottomLine.height > view.frame.size.height {
                pickerStyle.titleBarStyle.bottomLine.height = 0.5
            }
            let line: UIView = UIView.init(frame: CGRect(x: 0, y: view.frame.size.height - pickerStyle.titleBarStyle.bottomLine.height, width: view.frame.size.width, height: pickerStyle.titleBarStyle.bottomLine.height))
            line.backgroundColor = pickerStyle.titleBarStyle.bottomLine.color
            line.autoresizingMask = .flexibleWidth
            view.addSubview(line)
        }
        return view
    }()
    
    private var _cancelButton: UIButton?
    private lazy var cancelButton: UIButton = {
        let btn = setupButton(style: pickerStyle.titleBarStyle.cancelBtnStyle)
        btn.addTarget(self, action: #selector(cancelDidClick), for: .touchUpInside)
        _cancelButton = btn
        return btn
    }()
    
    private var _doneButton: UIButton?
    private lazy var doneButton: UIButton = {
        let btn = setupButton(style: pickerStyle.titleBarStyle.doneBtnStyle)
        btn.addTarget(self, action: #selector(doneDidClick), for: .touchUpInside)
        _doneButton = btn
        return btn
    }()
    
    private func setupButton(style:YHPickerButtonStyle) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.frame = style.frame
        btn.autoresizingMask = [.flexibleRightMargin, .flexibleRightMargin]
        btn.backgroundColor = style.color
        btn.titleLabel?.font = style.textFont
        btn.setTitleColor(style.textColor, for: .normal)
        if let image = style.image {
            btn.setImage(image, for: .normal)
        }
        if let title = style.title {
            btn.setTitle(title, for: .normal)
        }
        if style.borderStyle == .solid {
            btn.layer.cornerRadius = style.cornerRadius > 0 ? style.cornerRadius : 6.0
            btn.layer.borderColor = style.textColor.cgColor
            btn.layer.borderWidth = style.borderWidth > 0 ? style.borderWidth : 1.0
            btn.clipsToBounds = true
        } else {
            btn.layer.cornerRadius = style.cornerRadius > 0 ? style.cornerRadius : 6.0
            btn.clipsToBounds = true
        }
        return btn
    }
    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: pickerStyle.titleBarStyle.titleLabelStyle.frame)
        label.backgroundColor = pickerStyle.titleBarStyle.titleLabelStyle.color
        label.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin]
        label.textAlignment = .center
        label.font = pickerStyle.titleBarStyle.titleLabelStyle.textFont
        label.textColor =  pickerStyle.titleBarStyle.titleLabelStyle.textColor
        label.text = title
        return label
    }()
    
    public lazy var keyView :UIView  = YHGETKeyWindow() ?? UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIView {
    func yh_setupCormers(corners: UIRectCorner, radius:CGFloat) {
        let rounded = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        self.layer.mask = shape
    }
}
