//
//  RxPickerViewDataSourceProxy.swift
//  RxCocoa
//
//  Created by Sergey Shulga on 05/07/2017.
//  Copyright © 2017 Krunoslav Zaher. All rights reserved.
//

#if os(iOS)

    import UIKit
#if !RX_NO_MODULE
    import RxSwift
#endif

fileprivate let pickerViewDataSourceNotSet = PickerViewDataSourceNotSet()

final fileprivate class PickerViewDataSourceNotSet: NSObject, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
}

/// For more information take a look at `DelegateProxyType`.
public class RxPickerViewDataSourceProxy
    : DelegateProxy<UIPickerView, UIPickerViewDataSource>
    , DelegateProxyType
    , UIPickerViewDataSource {

    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { RxPickerViewDataSourceProxy(parentObject: $0) }
    }

    /// Typed parent object.
    public weak fileprivate(set) var pickerView: UIPickerView?
    private weak var _requiredMethodsDataSource: UIPickerViewDataSource? = pickerViewDataSourceNotSet

    /// Initializes `RxPickerViewDataSourceProxy`
    ///
    /// - parameter parentObject: Parent object for delegate proxy.
    public override init(parentObject: ParentObject) {
        self.pickerView = parentObject
        super.init(parentObject: parentObject)
    }

    // MARK: UIPickerViewDataSource

    /// Required delegate method implementation.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return (_requiredMethodsDataSource ?? pickerViewDataSourceNotSet).numberOfComponents(in: pickerView)
    }

    /// Required delegate method implementation.
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (_requiredMethodsDataSource ?? pickerViewDataSourceNotSet).pickerView(pickerView, numberOfRowsInComponent: component)
    }
    
    // MARK: proxy
    
    /// For more information take a look at `DelegateProxyType`.
    public override class func setCurrentDelegate(_ delegate: UIPickerViewDataSource?, toObject object: UIPickerView) {
        object.dataSource = delegate
    }
    
    /// For more information take a look at `DelegateProxyType`.
    public override class func currentDelegate(for object: UIPickerView) -> UIPickerViewDataSource? {
        return object.dataSource
    }
    
    /// For more information take a look at `DelegateProxyType`.
    public override func setForwardToDelegate(_ forwardToDelegate: UIPickerViewDataSource?, retainDelegate: Bool) {
        _requiredMethodsDataSource = forwardToDelegate ?? pickerViewDataSourceNotSet
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
    }
}

#endif