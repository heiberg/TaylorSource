//
//  Created by Daniel Thorpe on 16/04/2015.
//  Copyright (c) 2015 Daniel Thorpe. All rights reserved.
//

import UIKit
import XCTest

import YapDatabase
import YapDatabaseExtensions
import TaylorSource

class MapperTests: XCTestCase {

    var db: YapDatabase!
    var mapper: Mapper<Event>!

    func test__initially__the_endIndex__is__zero() {
        db = YapDB.testDatabase()
        mapper = Mapper(database: db, configuration: events())
        XCTAssertEqual(mapper.startIndex, 0)
        XCTAssertEqual(mapper.endIndex, 0)
    }

    func test__when_database_has_one_item__initially__the_endIndex_is_1() {
        db = YapDB.testDatabase()
        db.newConnection().write(Event.create(.Red))
        mapper = Mapper(database: db, configuration: events())
        XCTAssertEqual(mapper.startIndex, 0)
        XCTAssertEqual(mapper.endIndex, 1)
    }

    func test__when_database_has_one_item__lookup_items_by_indexPath__the_first_indexPath__is_the_item() {
        db = YapDB.testDatabase()
        let event = Event.create(.Red)
        db.newConnection().write(event)
        mapper = Mapper(database: db, configuration: events())
        XCTAssertEqual(mapper.itemAtIndexPath(NSIndexPath.first)!, event)
    }

    func test__when_database_has_one_item__reverse_loop_items__the_first_item__is_the_first_indexPath() {
        db = YapDB.testDatabase()
        let event = Event.create(.Red)
        db.newConnection().write(event)
        mapper = Mapper(database: db, configuration: events())
        XCTAssertEqual(mapper.indexPathForKey(keyForPersistable(event), inCollection: Event.collection)!, NSIndexPath.first)
    }

    func test__when_database_has_three_events__can_slice_last_two() {
        let someEvents = createSomeEvents()
        db = YapDB.testDatabase() { db in
            db.newConnection().write(someEvents)
        }
        mapper = Mapper(database: db, configuration: events())
        XCTAssertEqual(Array(someEvents.reverse()[2..<5]), mapper[2..<5])
    }
}
