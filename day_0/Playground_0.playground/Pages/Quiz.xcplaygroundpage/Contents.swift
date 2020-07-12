// ---------------------------------------------------------------------------------------------------------
//  A QUICK PROBLEM FOR YOU TO TINKER WITH BEFORE FIRST TUTORIAL
//  --------------------------------------------------------------------------------------------------------
//  The function "add_all" is too slow, can you make it do the same thing but faster ?
// ---------------------------------------------------------------------------------------------------------

import Foundation

struct MyVector {
    var x: Float
    var y: Float
    var z: Float
}

func add_all(_ input: [(MyVector, MyVector)]) -> [MyVector] {
    var output: [MyVector] = []
    for i in 0 ..< input.count {
        output.append(MyVector(x: input[i].0.x + input[i].1.x,
                               y: input[i].0.y + input[i].1.y,
                               z: input[i].0.z + input[i].1.z))
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
var output = add_all(input)
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
