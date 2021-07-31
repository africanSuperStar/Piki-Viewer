//
//  PhotoCell.swift
//  Mindira
//
//  Created by Cameron de Bruyn on 2021/07/31.
//

import UIKit


class PhotoCell : UICollectionViewCell
{
    static let reuseIdentifier = "photo-cell-reuse-identifier"
    
    let imageView = UIImageView()
    let label     = UILabel()

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("not implemented")
    }
}

extension PhotoCell
{
    func configure()
    {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints     = false
    
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        imageView.contentMode = .scaleAspectFit
        
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray2.cgColor
        
        let height = CGFloat(50)
        let inset = CGFloat(10)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: height),
            
            contentView.heightAnchor.constraint(equalToConstant: height),
            
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
