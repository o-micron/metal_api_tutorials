import Foundation
import simd

// Structure of arrays [SOA]        vs          Array of structures [AOS]
struct Person {
    var age: Int
    var member: Bool
}

var PeopleAOS: [Person] = []

struct PeopleSOA {
    var ages: [Int]
    var members: [Bool]
}

//  Int Bool Int Bool Int Bool .....
//  Int Int Int .... Bool Bool Bool ....


struct MyVector {
    var x: Float
    var y: Float
    var z: Float
    var w: Float = 0.0
}

func add_all(_ input: inout [(MyVector, MyVector)]) -> [MyVector] {
    var output: [MyVector] = Array(repeating: MyVector(x: 0, y: 0, z: 0), count: input.count)
    for i in 0 ..< input.count {
        var a = input[i].0
        var b = input[i].1
        withUnsafeMutablePointer(to: &a) {
            let theX = UnsafeMutableRawPointer($0).load(as: simd_float3.self)
            withUnsafeMutablePointer(to: &b) {
                let theY = UnsafeMutableRawPointer($0).load(as: simd_float3.self)
                let out = theX + theY
                output[i].x = out.x
                output[i].y = out.y
                output[i].z = out.z
            }
        }
    }
    return output
}

// ---------------------------------------------------------------------------------------------------------
// let's fill input array with sample data
// ---------------------------------------------------------------------------------------------------------
var input: [(MyVector, MyVector)] = []
for i in 0 ... 100 {
    // cast from Int to Float ..
    let fi = Float(i)
    input.append((MyVector(x: fi*3, y: fi*3+1, z: fi*3+2),
                  MyVector(x: fi*3, y: fi*3+1, z: fi*3+2)))
}
// ---------------------------------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------------------------------
// compute
// ---------------------------------------------------------------------------------------------------------
let startTime = CFAbsoluteTimeGetCurrent()
var output = add_all(&input)
let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
// ---------------------------------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------------------------------
// let's print the result
// ---------------------------------------------------------------------------------------------------------
for i in 0 ..< output.count {
    print("output[\(i)] = [\(input[i].0.x), \(input[i].0.y), \(input[i].0.z)]", terminator: "")
    print(" + ", terminator: "")
    print("[\(input[i].1.x), \(input[i].1.y), \(input[i].1.z)]", terminator: "")
    print(" = ", terminator: "")
    print("[\(output[i].x), \(output[i].y), \(output[i].z)]")
}
// ---------------------------------------------------------------------------------------------------------

print("\n\n\tfunction call to add_all() only took \(timeElapsed) seconds.")
