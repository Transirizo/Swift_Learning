//
//  main.swift
//  Swifit_Learing
//
//  Created by 陈汉超 on 2023/7/14.
//

import AppKit
import CoreLocation
import Foundation
import SwiftUI

let fibs = [0, 1, 1, 2, 3, 5]
var mutableFibs = [0, 1, 1, 2, 3, 5]

mutableFibs.append(8)
mutableFibs.append(contentsOf: [13, 21])

for fib in mutableFibs {
    print(fib)
}

let squares = mutableFibs.map { fib in fib * fib }

struct Person {
    var name: String
    var age: Int
}

var optionalLisa: Person? = Person(name: "Lisa", age: 18)

if var lisa = optionalLisa {
    lisa.age += 1
}

struct PersonT {
    let first: String
    let last: String
    let yearOfBirth: Int
}

var people = [
    PersonT(first: "Emily", last: "Young", yearOfBirth: 2002),
    PersonT(first: "David", last: "Gray", yearOfBirth: 1991),
    PersonT(first: "Robert", last: "Barnes", yearOfBirth: 1985),
    PersonT(first: "Ava", last: "Barnes", yearOfBirth: 2000),
    PersonT(first: "Joanne", last: "Miller", yearOfBirth: 1994),
    PersonT(first: "Ava", last: "Barnes", yearOfBirth: 1998),
]

people.sort { p1, p2 in
    p1.last.localizedStandardCompare(p2.last) == .orderedAscending
}

people.sort { p1, p2 in
    switch p1.last.localizedStandardCompare(p2.last) {
    case .orderedAscending:
        return true
    case .orderedDescending:
        return false
    case .orderedSame:
        return p1.first.localizedStandardCompare(p2.first) == .orderedAscending
    }
}

struct SortDescriptor<Root> {
    var areInIncreasingOrder: (Root, Root) -> Bool
}

let sortByYear: SortDescriptor<PersonT> = .init { $0.yearOfBirth < $1.yearOfBirth }

extension SortDescriptor {
    init<Value: Comparable>(_ key: @escaping (Root) -> Value) {
        self.areInIncreasingOrder = { key($0) < key($1) }
    }
}

extension SortDescriptor {
    init<Value: Comparable>(_ key: @escaping (Root) -> Value, by compare: @escaping (Value) -> (Value) -> ComparisonResult) {
        self.areInIncreasingOrder = {
            compare(key($0))(key($1)) == .orderedAscending
        }
    }
}

extension SortDescriptor {
    func then(_ other: SortDescriptor<Root>) -> SortDescriptor<Root> {
        SortDescriptor { x, y in
            if areInIncreasingOrder(x, y) { return true }
            if areInIncreasingOrder(y, x) { return false }
            return other.areInIncreasingOrder(x, y)
        }
    }
}

let sortByYearAlt: SortDescriptor<PersonT> = .init { $0.yearOfBirth }
let sortByLast: SortDescriptor<PersonT> = .init({ $0.last }, by: String.localizedStandardCompare)
let sortByFirst: SortDescriptor<PersonT> = .init({ $0.first }, by: String.localizedStandardCompare)
let combined = sortByLast.then(sortByFirst).then(sortByYear)
people.sort(by: combined.areInIncreasingOrder)

print(people)
print(squares)
// print(mutableFibs)
print("Hello, World!")

protocol AlertViewDelegate: AnyObject {
    func buttonTapped(atIndex: Int)
}

class AlertView {
    var buttons: [String]
    weak var delegate: AlertViewDelegate?

    init(buttons: [String] = ["OK", "Cancel"]) {
        self.buttons = buttons
    }

    func fire() {
        delegate?.buttonTapped(atIndex: 1)
    }
}

class ViewController: AlertViewDelegate {
    let alert: AlertView

    init() {
        self.alert = AlertView(buttons: ["OK", "Cancel"])
        alert.delegate = self
    }

    func buttonTapped(atIndex: Int) {
        print("Button tapped:\(atIndex)")
    }
}

@resultBuilder
enum StringBuilder {
    static func buildBlock(_ str: String...) -> String {
        str.joined()
    }

    static func buildExpression(_ s: String) -> String {
        s
    }

    static func buildExpression(_ number: Int) -> String {
        "\(number)"
    }

    static func buildExpression(_ nerver: Never) -> String {
        fatalError()
    }

    static func buildExpression(_ void: ()) -> String {
        ""
    }

    @available(*, unavailable, message: "String Builders only support string and integer values")
    static func buildExpression<A>(_ expression: A) -> String {
        ""
    }

    static func buildIf(_ s: String?) -> String {
        s ?? ""
    }

    static func buildEither(first component: String) -> String {
        component
    }

    static func buildEither(second component: String) -> String {
        component
    }

    static func buildArray(_ components: [String]) -> String {
        components.joined(separator: "")
    }
}

let planets = ["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"]

@StringBuilder func greeting(for planet: String = "Earth") -> String {
    "Hello,"
    "StringBuilder,"
    if let index = planets.firstIndex(of: planet) {
        switch index {
        case 2:
            "World"
        case 1, 3:
            "Neighbor"
        default:
            "planet "
            index + 1
        }
    } else {
        "unknown planet"
    }
    "!"
}

@StringBuilder func greet3(for planet: String?) -> String {
    "Hello,"
    if let p = planet {
        p
    } else {
        for p in planets.dropLast() {
            "\(p) "
        }
        "and \(planets.last!)!"
    }
}

class Robot {
    enum State {
        case stopped, movingForward, turningRight, turningLeft
    }

    var state = State.stopped
}

class ObservableRobot: Robot {
    override var state: State {
        willSet {
            print("Transitioning from \(state) to \(newValue)")
        }
        didSet {
            print("now is \(state)")
        }
    }
}

var robot = Robot()
robot.state = .turningLeft
var obRobot = ObservableRobot()
obRobot.state = .movingForward

@propertyWrapper
class Box<A> {
    var wrappedValue: A
    init(wrappedValue: A) {
        self.wrappedValue = wrappedValue
    }
}

struct Checkbox {
    @Box<Bool> var isOn: Bool = false

    func didTap() {
        isOn.toggle()
    }
}

@propertyWrapper
@dynamicMemberLookup
class Reference<A> {
    private var _get: () -> A
    private var _set: (A) -> ()

    var wrappedValue: A {
        get { _get() }
        set { _set(newValue) }
    }

    init(get: @escaping () -> A, set: @escaping (A) -> ()) {
        self._get = get
        self._set = set
    }

    subscript<B>(dynamicMember keyPath: WritableKeyPath<A, B>) -> Reference<B> {
        Reference<B>(get: { self.wrappedValue[keyPath: keyPath] }) {
            self.wrappedValue[keyPath: keyPath] = $0
        }
    }
}

extension Box {
    var projectedValue: Reference<A> {
        Reference<A>(get: { self.wrappedValue }, set: { self.wrappedValue = $0 })
    }
}

struct PersonW {
    var name: String
}

struct PersonWEditor {
    @Reference var personw: PersonW
}

func makeEditor() -> PersonWEditor {
    @Box var personw = PersonW(name: "Transirizo")
}

print(greeting())
print(greeting(for: "Venus"))
print(greeting(for: "sss"))
print(greeting(for: "Jupiter"))
print(greet3(for: nil))
