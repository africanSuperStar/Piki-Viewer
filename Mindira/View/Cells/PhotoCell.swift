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
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth  = 3
        imageView.layer.borderColor  = UIColor.black.cgColor
        
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        
        layer.shouldRasterize = true
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        
        layer.shadowColor   = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset  = .zero
        layer.shadowRadius  = 20
        
        layer.cornerRadius    = 20
        layer.backgroundColor = UIColor.white.cgColor
        
        let horizontalInset = CGFloat(20)
        let inset = CGFloat(10)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalInset),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalInset),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
    }
}
