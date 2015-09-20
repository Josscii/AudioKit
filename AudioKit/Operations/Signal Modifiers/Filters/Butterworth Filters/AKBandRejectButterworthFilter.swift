//
//  AKBandRejectButterworthFilter.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

/** A band-reject Butterworth filter.

These filters are Butterworth second-order IIR filters. They offer an almost flat passband and very good precision and stopband attenuation.
*/
@objc class AKBandRejectButterworthFilter : AKParameter {

    // MARK: - Properties

    private var butbr = UnsafeMutablePointer<sp_butbr>.alloc(1)
    private var butbr2 = UnsafeMutablePointer<sp_butbr>.alloc(1)

    private var input = AKParameter()


    /** Center frequency. (in Hertz) [Default Value: 3000] */
    var centerFrequency: AKParameter = akp(3000) {
        didSet {
            centerFrequency.bind(&butbr.memory.freq, right:&butbr2.memory.freq)
            dependencies.append(centerFrequency)
        }
    }

    /** Bandwidth. (in Hertz) [Default Value: 2000] */
    var bandwidth: AKParameter = akp(2000) {
        didSet {
            bandwidth.bind(&butbr.memory.bw, right:&butbr2.memory.bw)
            dependencies.append(bandwidth)
        }
    }


    // MARK: - Initializers

    /** Instantiates the filter with default values

    - parameter input: Input audio signal. 
    */
    init(_ input: AKParameter)
    {
        super.init()
        self.input = input
        setup()
        dependencies = [input]
        bindAll()
    }

    /** Instantiates the filter with all values

    - parameter input: Input audio signal. 
    - parameter centerFrequency: Center frequency. (in Hertz) [Default Value: 3000]
    - parameter bandwidth: Bandwidth. (in Hertz) [Default Value: 2000]
    */
    convenience init(
        _ input:         AKParameter,
        centerFrequency: AKParameter,
        bandwidth:       AKParameter)
    {
        self.init(input)
        self.centerFrequency = centerFrequency
        self.bandwidth       = bandwidth

        bindAll()
    }

    // MARK: - Internals

    /** Bind every property to the internal filter */
    internal func bindAll() {
        centerFrequency.bind(&butbr.memory.freq, right:&butbr2.memory.freq)
        bandwidth      .bind(&butbr.memory.bw, right:&butbr2.memory.bw)
        dependencies.append(centerFrequency)
        dependencies.append(bandwidth)
    }

    /** Internal set up function */
    internal func setup() {
        sp_butbr_create(&butbr)
        sp_butbr_create(&butbr2)
        sp_butbr_init(AKManager.sharedManager.data, butbr)
        sp_butbr_init(AKManager.sharedManager.data, butbr2)
    }

    /** Computation of the next value */
    override func compute() {
        sp_butbr_compute(AKManager.sharedManager.data, butbr, &(input.leftOutput), &leftOutput);
        sp_butbr_compute(AKManager.sharedManager.data, butbr2, &(input.rightOutput), &rightOutput);
    }

    /** Release of memory */
    override func teardown() {
        sp_butbr_destroy(&butbr)
        sp_butbr_destroy(&butbr2)
    }
}
