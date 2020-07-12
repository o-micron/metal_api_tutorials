import PlaygroundSupport
import MetalKit

func add_two_arrays_regular(ELEMENTS_COUNT: Int) -> Double {
    struct MyVector {
        var x: Float
        var y: Float
        var z: Float
    }

    var left_hand_side: [MyVector] = []
    var right_hand_side: [MyVector] = []
    var results: [MyVector] = []

    for i in 0 ..< ELEMENTS_COUNT {
        left_hand_side.append(MyVector(x: Float(i*3), y: Float(i*3+1), z: Float(i*3+2)))
        right_hand_side.append(MyVector(x: Float(i*3), y: Float(i*3+1), z: Float(i*3+2)))
    }

    let startTime = CFAbsoluteTimeGetCurrent()
    for i in 0 ..< ELEMENTS_COUNT {
        results.append(MyVector(x: left_hand_side[i].x + right_hand_side[i].x,
                                y: left_hand_side[i].y + right_hand_side[i].y,
                                z: left_hand_side[i].z + right_hand_side[i].z))
    }
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    
//    for i in 0 ..< ELEMENTS_COUNT {
//        print("regular results[\(i)] [\(left_hand_side[i].x), \(left_hand_side[i].y), \(left_hand_side[i].z)] + [\(right_hand_side[i].x), \(right_hand_side[i].y), \(right_hand_side[i].z)] = [\(results[i].x), \(results[i].y), \(results[i].z)]")
//    }
    
    return timeElapsed
}

func add_two_arrays_simd_matrix3x3(ELEMENTS_COUNT: Int) -> Double {
    var left_hand_side: [matrix_float3x3] = []
    var right_hand_side: [matrix_float3x3] = []
    var results: [matrix_float3x3] = []
    
    for i in 0 ..< ELEMENTS_COUNT/3 {
        left_hand_side.append(matrix_float3x3(rows: [SIMD3<Float>(Float(i*9), Float(i*9+1), Float(i*9+2)),
                                                     SIMD3<Float>(Float(i*9+3), Float(i*9+4), Float(i*9+5)),
                                                     SIMD3<Float>(Float(i*9+6), Float(i*9+7), Float(i*9+8))]))
        right_hand_side.append(matrix_float3x3(rows: [SIMD3<Float>(Float(i*9), Float(i*9+1), Float(i*9+2)),
                                                      SIMD3<Float>(Float(i*9+3), Float(i*9+4), Float(i*9+5)),
                                                      SIMD3<Float>(Float(i*9+6), Float(i*9+7), Float(i*9+8))]))
    }
    
    let startTime = CFAbsoluteTimeGetCurrent()
    for i in 0 ..< ELEMENTS_COUNT/3 {
        results.append(left_hand_side[i] + right_hand_side[i])
    }
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    
//    for i in 0 ..< ELEMENTS_COUNT/3 {
//        print("simd matrix3x3 results[\(i)] = [\(results[i].columns.0.x), \(results[i].columns.1.x), \(results[i].columns.2.x), \(results[i].columns.0.y), \(results[i].columns.1.y), \(results[i].columns.2.y), \(results[i].columns.0.z), \(results[i].columns.1.z), \(results[i].columns.2.z)]")
//    }
    
    return timeElapsed
}

func add_two_arrays_simd_vector3(ELEMENTS_COUNT: Int) -> Double {
    var left_hand_side: [SIMD3<Float>] = []
    var right_hand_side: [SIMD3<Float>] = []
    var results: [SIMD3<Float>] = []
    
    for i in 0 ..< ELEMENTS_COUNT {
        left_hand_side.append(SIMD3<Float>(Float(i*3), Float(i*3+1), Float(i*3+2)))
        right_hand_side.append(SIMD3<Float>(Float(i*3), Float(i*3+1), Float(i*3+2)))
    }
    
    let startTime = CFAbsoluteTimeGetCurrent()
    for i in 0 ..< ELEMENTS_COUNT {
        results.append(left_hand_side[i] + right_hand_side[i])
    }
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    
//    for i in 0 ..< ELEMENTS_COUNT {
//        print("simd vector3 results[\(i)] [\(left_hand_side[i].x), \(left_hand_side[i].y), \(left_hand_side[i].z)] + [\(right_hand_side[i].x), \(right_hand_side[i].y), \(right_hand_side[i].z)] = [\(results[i].x), \(results[i].y), \(results[i].z)]")
//    }
    
    return timeElapsed
}

var average_time_spent_simd_vector3: Double = 0.0
for _ in 0 ..< 5 {
    average_time_spent_simd_vector3 += add_two_arrays_simd_vector3(ELEMENTS_COUNT: 999)
}

var average_time_spent_simd_matrix3x3: Double = 0.0
for _ in 0 ..< 5 {
    average_time_spent_simd_matrix3x3 += add_two_arrays_simd_matrix3x3(ELEMENTS_COUNT: 999)
}

var average_time_spent_regular: Double = 0.0
for _ in 0 ..< 5 {
    average_time_spent_regular += add_two_arrays_regular(ELEMENTS_COUNT: 999)
}

print("simd vector3 add took (on average of 5 cycles): \(average_time_spent_simd_vector3/5.0) seconds.")
print("simd matrix3x3 add took (on average of 5 cycles): \(average_time_spent_simd_matrix3x3/5.0) seconds.")
print("regular add took (on average of 5 cycles): \(average_time_spent_regular/5.0) seconds.")

//  the results on my machine:
//  --------------------------
//  regular add took (on average of 5 cycles):          11.474584794044494 seconds.
//  simd vector3 add took (on average of 5 cycles):     6.997281813621521 seconds.
//  simd matrix3x3 add took (on average of 5 cycles):   1.7726606369018554 seconds.

//  conclusion:
//  -----------
//  We have gone from 11 seconds to 6 seconds to 1 second only! (nearly 2x faster using vector3) and (nearly 11x faster using mat3)
//  The data is the same, the function that we do (we add 2 numbers) is the same, I only changed the structure of the problem.
//  I am pretty sure that we actually should get more performance gains than 2X and 11X still, this is just a very basic example
//  This is a Macbook air 2017, Dual Core i5 CPU ... I expect better results on newer and more powerful CPUs.
//  We got better resulting from batching the data in Matrix3x3 instead of Vector3
//  Depending on how wide the registers are, we can squeze even more performance out of the CPU, absolutely for free.

//  note:
//  -----
//  We still use the CPU, we haven't even used the GPU yet.
//  the CPU has a few wide registers and special instructions which can execute multiple instructions in batches
//  this is what SIMD is all about.
//  Also worth to mention that this is an intel x86 CPU. SIMD extensions are mainly provided by the Intel in this case.
//  In case we have an ARM CPU we're going to be probably be using the Neon simd extensions, which are similar in functionality.
//  In swift we have the accelerate framework or simd.h header which are using multiple backends behind the curtains,
//  depending on the available CPU, the framwork or the library will switch to use the available simd extension if any.
//  So Apple simplified access to these instructions by creating a nice interface that handles the difference in CPUs and therefore SIMD extensions.
