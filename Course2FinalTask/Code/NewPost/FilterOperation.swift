//
//  FilterOperation.swift
//  Course2FinalTask
//
//  Created by Ivan on 07.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

final class FilterOperation: Operation {
    
    //    MARK: - Private Methods
    private let inputImage: UIImage
    private let inputFilter: String
    private(set) var outputImage: UIImage?
    
    //    MARK: - Initializers
    init(image: UIImage, filter: String) {
        self.inputImage = image
        self.inputFilter = filter
    }
    
    //    MARK: - Override Methods
    override func main() {
        
        let context = CIContext()
        guard let coreImage = CIImage(image: inputImage) else { return }
        guard let filter = CIFilter(name: inputFilter) else { return }
        filter.setValue(coreImage, forKey: kCIInputImageKey)
        guard let filteredImage = filter.outputImage else { return }
        guard let cgImage = context.createCGImage(filteredImage, from: filteredImage.extent) else { return }
        outputImage = UIImage(cgImage: cgImage)
    }
}
