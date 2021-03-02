//
//  ProfileCell.swift
//  Course2FinalTask
//
//  Created by Ivan on 27.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileCell: UICollectionViewCell {
    
    //    MARK: - IB Outlets
    @IBOutlet weak var postsImage: UIImageView!
    
    //    MARK: - Public Methods
    func setupCell(post: Post) {
        let url = URL(string: post.image)!
        postsImage.kf.setImage(with: url)
    }
}
