//
//  CharacterCell.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 01/11/20.
//

import UIKit

class CharacterCell: UICollectionViewCell {
 
    var cardView = CardView()
    var coverView = UIView()
    
    var item: CharactersListViewModelItem? {
        didSet {
            if self.item == nil { return }
            
            setupViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        
        backgroundColor = .clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .init(width: 0, height: 4)
        layer.shadowRadius = 12
        
        setupCardView()
    }
    
    func setupCardView(){
        
        guard let item = self.item else { return }
        
        cardView.item = item
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(cardView)
        
        let top = cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        let leading = cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        let trailing = cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        let bottom = cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        
        NSLayoutConstraint.activate([top, leading, bottom, trailing])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighligthed: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighligthed: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighligthed: true)
    }
    
    private func animate(isHighligthed: Bool, completion: ((Bool) -> Void)? = nil){
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.transform = .identity
                       },
                       completion:completion)

        
    }
    
    private func setupCoverView() {
        contentView.addSubview(coverView)
        
        contentView.bringSubviewToFront(coverView)
        coverView.backgroundColor = .systemBackground
        coverView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = coverView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        let leading = coverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        let trailing = coverView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        let bottom = coverView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        
        NSLayoutConstraint.activate([top, leading, bottom, trailing])
    }
    
    func hideItems(){
        DispatchQueue.main.async {
            self.setupCoverView()
        }
        
    }
    
    func showItems() {
        coverView.removeFromSuperview()
    }
}
