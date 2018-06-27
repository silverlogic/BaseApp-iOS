//
//  DynamicBinder.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

// MARK: - Typealias
typealias Listener<T> = (T) -> Void
fileprivate typealias GetValueHandler<T> = () -> T
fileprivate typealias BindSingleHandler<T> = (Listener<T>?) -> Void
fileprivate typealias BindAndFireSingleHandler<T> = BindSingleHandler<T>
fileprivate typealias BindMultiHandler<T> = (Listener<T>?, AnyObject) -> Void
fileprivate typealias BindAndFireMultiHandler<T> = BindMultiHandler<T>
fileprivate typealias UnbindMultiHandler = (AnyObject) -> Void


// MARK: - DynamicBinderInterface

/// A struct representing public attributes and methods for `DynamicBinder` class.
struct DynamicBinderInterface<T> {
    
    // MARK: - Public Instance Attributes
    var value: T { return getValueHandler() }
    
    
    // MARK: - Private Instance Attributes
    fileprivate let getValueHandler: GetValueHandler<T>
    fileprivate let bindHandler: BindSingleHandler<T>
    fileprivate let bindAndFireHandler: BindAndFireSingleHandler<T>
    
    
    // MARK: - Public Instance Methods
    
    /// Binds the listener for listening for changes to the value.
    ///
    /// - Parameter listener: A `Listener?` representing the closure that gets invoked when the value changes.
    func bind(_ listener: Listener<T>?) {
        bindHandler(listener)
    }

    /// Binds the listener for listening for changes to the value. It immediately gets fired.
    ///
    /// - Parameter listener: A `Listener?` representing the closure that gets invoked when the value changes.
    func bindAndFire(_ listener: Listener<T>?) {
        bindAndFireHandler(listener)
    }
}


// MARK: - DynamicBinder

/// Generic class for binding values and listening for value changes. This uses a single listener.
class DynamicBinder<T> {
    
    // MARK: - Public Instance Attributes
    private(set) var interface: DynamicBinderInterface<T>!
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    
    // MARK: - Private Instance Attributes
    private var listener: Listener<T>?
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `DynamicBinder`.
    ///
    /// - Parameter value: A `T` representing the value to bind and listen for changes.
    init(_ value: T) {
        self.value = value
        interface = DynamicBinderInterface(getValueHandler: { [weak self] in
            guard let strongSelf = self else { return value }
            return strongSelf.value
        }, bindHandler: { [weak self] (listener) in
            guard let strongSelf = self else { return }
            strongSelf.bind(listener)
        }, bindAndFireHandler: { [weak self] (listener) in
            guard let strongSelf = self else { return }
            strongSelf.bindAndFire(listener)
        })
    }
    
    
    // MARK: - Private Instance Methods

    /// Binds the listener for listening for changes to the value.
    ///
    /// - Parameter listener: A `Listener<T>?` representing the closure that gets invoked when the value
    ///                       changes.
    private func bind(_ listener: Listener<T>?) {
        self.listener = listener
    }
    
    /// Binds the listener for listening for changes to the value. It immediately gets fired.
    ///
    /// - Parameter listener: A `Listener<T>?` representing the closure that gets invoked when the value
    ///                       changes.
    private func bindAndFire(_ listener: Listener<T>?) {
        self.listener = listener
        self.listener?(value)
    }
}


// MARK: - MultiDynamicBinderInterface

/// A struct representing public attributes and methods for `MultiDynamicBinder` class.
struct MultiDynamicBinderInterface<T> {
    
    // MARK: - Public Instance Attributes
    var value: T { return getValueHandler() }
    
    
    // MARK: - Private Instance Attributes
    fileprivate let getValueHandler: GetValueHandler<T>
    fileprivate let bindHandler: BindMultiHandler<T>
    fileprivate let bindAndFireHandler: BindAndFireMultiHandler<T>
    fileprivate let unbindHandler: UnbindMultiHandler
    
    
    // MARK: - Public Instance Methods
    
    /// Binds the listener for listening for changes to the value.
    ///
    /// - Parameters:
    ///   - listener:  A `Listener?` representing the closure that gets invoked when the value changes.
    ///   - observer: An `Any` representing the object that registered the listener.
    func bind(_ listener: Listener<T>?, for observer: AnyObject) {
        bindHandler(listener, observer)
    }
    
    /// Binds the listener for listening for changes to the value. It immediately gets fired.
    ///
    /// - Parameters:
    ///   - listener: A `Listener?` representing the closure that gets invoked when the value changes.
    ///   - observer: An `Any` representing the object that registered the listener.
    func bindAndFire(_ listener: Listener<T>?, for observer: AnyObject) {
        bindAndFireHandler(listener, observer)
    }
    
    /// Removes the listener the observer registered.
    ///
    /// - Parameter observer: An `Any` representing the object that has a listener registered.
    func unbind(for observer: AnyObject) {
        unbindHandler(observer)
    }
}


// MARK: - MultiDynamicBinder

/// Generic class for binding values and listening for value changes from multiple locations.
class MultiDynamicBinder<T> {
    
    // MARK: - Public Instance Attributes
    fileprivate(set) var interface: MultiDynamicBinderInterface<T>!
    var value: T {
        didSet {
            observers.forEach { $0.listener?(value) }
        }
    }
    
    
    // MARK: - Private Instance Attributes
    fileprivate(set) var observers: [Observer<T>]
    
    
    // MARK: - Initializers

    /// Initializes an instance of `MultiDynamicBinder`.
    ///
    /// - Parameter value: A `T` representing the value to bind and listen for changes.
    init(_ value: T) {
        self.value = value
        observers = [Observer]()
        interface = MultiDynamicBinderInterface(getValueHandler: { [weak self] in
            guard let strongSelf = self else { return value }
            return strongSelf.value
        }, bindHandler: { [weak self] (listener, observer) in
            guard let strongSelf = self else { return }
            strongSelf.bind(listener, for: observer)
        }, bindAndFireHandler: { [weak self] (listenet, observer) in
            guard let strongSelf = self else { return }
            strongSelf.bindAndFire(listenet, for: observer)
        }, unbindHandler: { [weak self] (observer) in
            guard let strongSelf = self else { return }
            strongSelf.removeListeners(for: observer)
        })
    }
    
    
    // MARK: - Private Instance Methods
    
    /// Binds the listener for listening for changes to the value.
    ///
    /// - Parameters:
    ///   - listener: A `Listener<T>?` representing the closure that gets invoked when the value changes.
    ///   - observer: An `AnyObject` representing the object that registered the listener.
    fileprivate func bind(_ listener: Listener<T>?, for observer: AnyObject) {
        let observe = Observer(observer: observer, listener: listener)
        observers.append(observe)
    }
    
    /// Binds the listener for listening for changes to the value. It immediately gets fired.
    ///
    /// - Parameters:
    ///   - listener: A `Listener<T>?` representing the closure that gets invoked when the value changes.
    ///   - observer: An `AnyObject` representing the object that registered the listener.
    fileprivate func bindAndFire(_ listener: Listener<T>?, for observer: AnyObject) {
        let observe = Observer(observer: observer, listener: listener)
        observers.append(observe)
        listener?(value)
    }
    
    /// Removes the listener the observer registered.
    ///
    /// - Parameter observer: An `AnyObject` representing the object that has a listener registered.
    fileprivate func removeListeners(for observer: AnyObject) {
        let object1 = observer
        observers = observers.filter { (observe: Observer<T>) -> Bool in
            guard let object2 = observe.observer else { return false }
            return object1 !== object2
        }
    }
}


// MARK: - Observer

/// A struct representing an observer and their registered listener.
struct Observer<T> {
    
    // MARK: - Public Instance Attributes
    weak var observer: AnyObject?
    var listener: Listener<T>?
    
    
    // MARK: - Initializers
    
    /// Initializers an instance of `Observer`.
    init(observer: AnyObject, listener: Listener<T>?) {
        self.observer = observer
        self.listener = listener
    }
}
