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
    
    let label = UILabel()

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
        label.translatesAutoresizingMaskIntoConstraints = false
    
        contentView.addSubview(label)
        
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray2.cgColor
        
        let inset = CGFloat(10)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
