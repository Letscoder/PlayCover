//
//  Record.swift
//  PlayCover
//
//  Created by Alex on 20.03.2021.
//

import Foundation

import RealmSwift

class RecordMacro: Object {
    @objc dynamic var ts: Double = 0.0
    @objc dynamic var type: Int = 0
    @objc dynamic var key: Int = 0x00
    @objc dynamic var x: Int = 0
    @objc dynamic var y: Int = 0
    @objc dynamic var pKey = ""
    convenience init(ts: Double, type: Int, key: Int, x: Int, y: Int) {
        self.init()
        self.ts = ts
        self.type = type
        self.key = key
        self.x = x
        self.y = y
        self.pKey = primaryKeyValue()
    }
    
    override static func primaryKey() -> String? {
            return "pKey"
    }
    
    func primaryKeyValue() -> String {
            return "\(ts)"
    }
}
