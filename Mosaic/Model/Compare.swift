//
//  Comparable.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 9. 1..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation
//https://medium.com/grand-parade/computing-the-diff-of-two-arrays-in-a-functional-way-in-swift-be82a586a821

public struct ComparableSequence<T1, T2> {
    public let common: [(T1, T2)]
    public let removed: [T1]
    public let inserted: [T2]
    public init(common: [(T1, T2)] = [], removed: [T1] = [], inserted: [T2] = []) {
        self.common = common
        self.removed = removed
        self.inserted = inserted
    }
}


public func compare<T1, T2>(_ first: [T1], _ second: [T2], with compare: (T1,T2) -> Bool) -> ComparableSequence<T1, T2> {
    let combinations = first.flatMap { firstElement in (firstElement, second.first { secondElement in compare(firstElement, secondElement) }) }
    let common = combinations.filter { $0.1 != nil }.flatMap { ($0.0, $0.1!) }
    let removed = combinations.filter { $0.1 == nil }.flatMap { ($0.0) }
    let inserted = second.filter { secondElement in !common.contains { compare($0.0, secondElement) } }
    return ComparableSequence(common: common, removed: removed, inserted: inserted)
}
