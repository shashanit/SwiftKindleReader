g//
//  PageCell.swift
//  Kindle
//
//  Created by Shashwat Singh on 2/12/17.
//  Copyright © 2017 Shashanoid. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {
    
    var book: Book? {
        didSet{
            coverImageView.image = book?.image
            titleLabel.text = book?.title
            authorLabel.text = book?.author
//            print(book?.coverImageUrl)
            
            guard let coverImageUrl = book?.coverImageUrl else {return}
            guard let url = URL(string: coverImageUrl) else {return}
            // sometimes the images don't load so it'll give an empy slot instead of wrong image
            coverImageView.image = nil
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let err = error{
                    print("Failed to retrieve image", err)
                    return
                }
                
                guard let imageData = data else {return}
                
                let image = UIImage(data: imageData)
                
                DispatchQueue.main.async {
                    self.coverImageView.image = image
                }
                
                
                
                
            }.resume()
            
            
        }
    }
    
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let title = UILabel()
//        title.backgroundColor = .blue
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Title of the book"
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 16)
        return title
    }()
    
    let authorLabel: UILabel = {
        
       let author = UILabel()
//        author.backgroundColor = .yellow
        author.text = "Author of the book"
        author.translatesAutoresizingMaskIntoConstraints = false
        author.textColor = .lightGray
        return author
        
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        
        
        addSubview(coverImageView)
        coverImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        coverImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        coverImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        coverImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: coverImageView.rightAnchor, constant: 8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        addSubview(authorLabel)
        authorLabel.leftAnchor.constraint(equalTo: coverImageView.rightAnchor, constant: 8).isActive = true
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).isActive = true
        authorLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
