//
//  Property+Collections.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

public extension Property where T: Collection {
    
    func mapItems<U>(_ mapper: @escaping (T.Element) -> U) -> Property<Array<U>> {
        return map { $0.map(mapper) }
    }
    
    func compactMapItems<U>(_ mapper: @escaping (T.Element) -> U?) -> Property<Array<U>> {
        return map { $0.compactMap(mapper) }
    }
    
    func flatMapItems<U>(_ mapper: @escaping (T.Element) -> Array<U>) -> Property<Array<U>> {
        return map { $0.flatMap(mapper) }
    }
    
    func combineFlatMapItems<U>(_ mapper: @escaping (T.Element) -> Property<U>) -> Property<Array<U>> {
        let combiner: (T) -> Property<Array<U>> = { items in
            let properties = items.map(mapper)
            return Property<U>.combine(properties)
        }
        
        let mirrored = MirroredProperty(mirroring: combiner(value))
        observeNext {
            mirrored.takeValue(from: combiner($0))
        }
        return mirrored
    }
    
    func combineFlatMapItems<U>(_ mapper: @escaping (T.Element) -> Property<Array<U>>) -> Property<Array<U>> {
        let combiner: (T) -> Property<Array<U>> = { items in
            let properties = items.map(mapper)
            let combined = Property<Array<U>>.combine(properties)
            return combined.map { $0.flatMap { $0 } }
        }
        
        let mirrored = MirroredProperty(mirroring: combiner(value))
        observeNext {
            mirrored.takeValue(from: combiner($0))
        }
        return mirrored
    }
    
    func filterItems(_ f: @escaping (T.Element) -> Bool) -> Property<Array<T.Element>> {
        return map { $0.filter(f) }
    }
    
    func partition(by goesInFirst: @escaping (T.Element) -> Bool) -> (Property<Array<T.Element>>, Property<Array<T.Element>>) {
        let m1 = MutableProperty<Array<T.Element>>([])
        let m2 = MutableProperty<Array<T.Element>>([])
        
        observe { items in
            var a1 = Array<T.Element>()
            var a2 = Array<T.Element>()
            for i in items {
                if goesInFirst(i) {
                    a1.append(i)
                } else {
                    a2.append(i)
                }
            }
            m1.value = a1
            m2.value = a2
        }
        
        return (m1, m2)
    }
    
}

public extension Property where T: RandomAccessCollection {
    
    func item(at index: Property<T.Index>) -> Property<T.Element> {
        let m = MutableProperty<T.Element>(self.value[index.value])
        combine(index).observeNext { coll, ind in
            m.value = coll[ind]
        }
        return m
    }
    
}

public extension Property where T: Collection, T.Element: Comparable {
    
    func sorted() -> Property<Array<T.Element>> { return sorted(<) }
    
    func sorted(_ sorter: @escaping (T.Element, T.Element) -> Bool) -> Property<Array<T.Element>> {
        return map { $0.sorted(by: sorter) }
    }
    
}

public extension Property where T: Collection, T.Element: Hashable {
    
    func uniquedItems() -> Property<Array<T.Element>> {
        return map { $0.unique() }
    }
    
}

public extension Property {
    
    func includingPrevious() -> Property<(T, T)> {
        var initial = value
        return map { newValue in
            let oldValue = initial
            initial = newValue
            return (oldValue, newValue)
        }
    }
    
    func includingPrevious(initial: T) -> Property<(T, T)> {
        var previous = initial
        return map { newValue in
            let oldValue = previous
            previous = newValue
            return (oldValue, newValue)
        }
    }
    
}
