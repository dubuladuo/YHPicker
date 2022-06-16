//
//  YHStringPickerView.swift
//  YHPickerDemo
//
//  Created by 刘勇航 on 2022/5/31.
//

import UIKit

typealias stringPickerSelect = (_ model:YHStringPickerModel) -> Void

class YHStringPickerView: YHBasePickerView,UIPickerViewDelegate,UIPickerViewDataSource {

    private var dataList: Array<YHStringPickerModel> {
        didSet{
            selectModel = dataList.first
        }
    }
    private var selectModel: YHStringPickerModel?
    
    var selectResult:stringPickerSelect?
    
    static func showPicker<T>(title: String?, dataSource:[T], selectIndex: Int, selectResult:@escaping stringPickerSelect) {
        let pickerView = YHStringPickerView()
        pickerView.dataList = pickerView.handleData(dataSource: dataSource)
        pickerView.title = title
        pickerView.selectResult = selectResult
        pickerView.selectModel = pickerView.dataList[selectIndex]
        pickerView.show()
    }
    
    
    public func show() {
        addPickerToView(view: nil)
    }
    
    override func addPickerToView(view: UIView?) {
        if let superView = view {
            superView.setNeedsLayout()
            superView.layoutIfNeeded()
            
            self.frame = superView.bounds
            let headerHeight = pickerHeaderView?.bounds.size.height ?? 0
            let footerHeight = pickerFooterView?.bounds.size.height ?? 0
            pickerView.frame = CGRect(x: 0, y: headerHeight, width: superView.bounds.size.width, height: superView.bounds.size.height - headerHeight - footerHeight)
            self.addSubview(pickerView)
        } else {
            alertView.addSubview(pickerView)
        }
        //添加中间选择行的两条分割线
        if pickerStyle.pickerViewStyle.clearPickerNewStyle {
            addSeparatorLine(view: pickerView)
        }
        
        reloadData()
        
        doneButtonAction = {(button) in
            self.removePickerFromView(view: view)
            if let result = self.selectResult {
                if let model = self.selectModel {
                    result(model)
                }
            }
        }
        
        super.addPickerToView(view: view)
    }
    
    override func reloadData() {
        pickerView.reloadAllComponents()
        
    }
    
    private func handleData<T>(dataSource:Array<T>) -> Array<YHStringPickerModel>{
        var list: Array<YHStringPickerModel> = []
        if T.self == String.self {
            for (index, itemStr) in dataSource.enumerated() {
                let model = YHStringPickerModel()
                model.value = itemStr as? String
                model.index = index
                list.append(model)
            }
        } else if T.self == YHStringPickerModel.self {
            for (index, item) in dataSource.enumerated() {
                let model = item as! YHStringPickerModel
                model.index = index
                list.append(model)
            }
        }
        return list
    }
    
    override init(frame: CGRect) {
        dataList = []
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    //MARK: UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let model = dataList[row]
        let label = pickerReusingView(view: view)
        label.text = model.value
        //设置选中样式
        updatePickerSelectRowStyle(pickerView: pickerView, row: row, component: component)
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectModel = dataList[row]
    }
    
    private func pickerReusingView(view: UIView?) -> UILabel {
        if let label = view as? UILabel {
            return label
        }
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = pickerStyle.pickerViewStyle.normalRowStyle.textFont
        label.textColor = pickerStyle.pickerViewStyle.normalRowStyle.textColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }
    
    
    
    //MARK: lazy
    private lazy var pickerView: UIPickerView = {
        let headerViewHeight = pickerHeaderView?.bounds.size.height ?? 0
        let picker = UIPickerView.init(frame: CGRect(x: 0, y: pickerStyle.titleBarStyle.height + headerViewHeight, width: keyView.bounds.size.width, height: pickerStyle.pickerViewStyle.height))
        picker.backgroundColor = pickerStyle.pickerViewStyle.color
        picker.autoresizingMask = [.flexibleBottomMargin, .flexibleRightMargin, .flexibleWidth]
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
}
