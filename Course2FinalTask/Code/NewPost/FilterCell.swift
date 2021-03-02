//
//  FilterCell.swift
//  Course2FinalTask
//
//  Created by Ivan on 07.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    //    MARK: - Private Properties
    private let queue = OperationQueue()
    
    private let filterName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    private let filteredImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    //    MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Public Methods
    func createCell(name: String, image: UIImage) {
        filterName.text = name
        
        let operation = FilterOperation(image: image, filter: name)
        operation.completionBlock = {
            DispatchQueue.main.async {
                self.filteredImage.image = operation.outputImage
            }
        }
        
        queue.addOperation(operation)
    }
    
    //    MARK: - Private Methods
    private func createUI() {
        addSubview(filterName)
        addSubview(filteredImage)
        
        let constraints = [filterName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
                           filterName.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                           
                           filteredImage.bottomAnchor.constraint(equalTo: filterName.topAnchor, constant: -8),
                           filteredImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                           filteredImage.widthAnchor.constraint(equalToConstant: 50),
                           filteredImage.heightAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(constraints)
    }
}
