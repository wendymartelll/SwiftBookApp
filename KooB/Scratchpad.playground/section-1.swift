// Playground - noun: a place where people can play

import UIKit

var name = String?()

name = "Tony"

if let string = name {
    println(string)
} else {
    println("The string does not have a value")
}

if name == nil {
    println("Name is nil")
}

class Vehicle {
    let numberOfWheels: Int = 4
}

class Car: Vehicle {
    let name = String?()
    
    init(name: String) {
        self.name = name
    }
    
    func getName() -> String {
        return name!
    }
}

var car: Car?

car = Car(name: "Ferrari")

if let car = car {
    println(car.numberOfWheels)
} else {
    println("No car to display")
}

if let name = car?.getName() {
    println(name)
} else {
    "Car doesn't have a name"
}

var carArray = [Car]()

carArray.append(car!)
carArray.append(Car(name: "Maserati"))

for car in carArray {
    println(car.name!)
}