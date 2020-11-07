//
//  CardView.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 01/11/20.
//

import UIKit

class CardView: UIView {

    let imageView = UIImageView()
    let nameLabel = UILabel()
    
    var item: CharactersListViewModelItem? {
        didSet {
            setupViews()
        }
    }
    
    init(){
        super.init(frame: .zero)
    }
    
    init(item: CharactersListViewModelItem?) {
        self.item = item
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    private func setupViews(){
        
        backgroundColor = UIColor(named: "cardBackground")
        
        setupNameLabel()
        setupImageView()
    }
    
    private func setupImageView(){
        addSubview(imageView)
        
        imageView.loadImageFrom(url: item?.imageUrl ?? "")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = imageView.topAnchor.constraint(equalTo: topAnchor)
        let leading = imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        let bottom = imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -8)
        
        NSLayoutConstraint.activate([bottom, leading, trailing, top])
    }
    
    private func setupNameLabel(){
        addSubview(nameLabel)
        
        nameLabel.text = item?.name
        nameLabel.textColor = UIColor(named: "cardText")
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 2
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let bottom = nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        let leading = nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        let trailing = nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        let height = nameLabel.heightAnchor.constraint(equalToConstant: 50)
        
        NSLayoutConstraint.activate([bottom, leading, trailing, height])
    }
    
}
