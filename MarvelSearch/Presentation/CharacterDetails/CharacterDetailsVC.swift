//
//  CharacterDetailsVC.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 01/11/20.
//

import UIKit

class CharacterDetailsVC: UIViewController {

    var cardView: CardView
    let textView = UITextView()
    let scrollView = UIScrollView()
    let closeButton = UIButton()
    let containerView = UIView()
    
    var safeArea: UILayoutGuide!
    
    var viewModel: CharacterDetailsViewModel!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    init(viewModel: CharacterDetailsViewModel){
        self.viewModel = viewModel
        self.cardView = CardView(item: viewModel.item.value)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupRx()
        
        viewModel.getCharacterDetails()
    }
    
    func setupViews() {
        safeArea = view.layoutMarginsGuide
        
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        setupContainerView()
        setupCardView()
        setupTextView()
        setupCloseButton()
    }
    
    func setupScrollView(){
        view.addSubview(scrollView)
        
        scrollView.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = scrollView.topAnchor.constraint(equalTo: view.topAnchor)
        let leading = scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
    }
    
    func setupContainerView(){
        scrollView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = containerView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        let leading = containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        let trailing = containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        let bottom = containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        let height = containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        
        NSLayoutConstraint.activate([top, leading, trailing, bottom, height])
    }
    
    func setupCardView(){
        containerView.addSubview(cardView)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = cardView.topAnchor.constraint(equalTo: view.topAnchor)
        let leading = cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let height = cardView.heightAnchor.constraint(equalToConstant: 300)
        
        NSLayoutConstraint.activate([top, leading, trailing, height])
    }
    
    func setupTextView(){
        containerView.addSubview(textView)
        
        textView.text = ""
        textView.textColor = .systemGray
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textView.contentInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemBackground
        
        let top = textView.topAnchor.constraint(equalTo: cardView.bottomAnchor)
        let leading = textView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = textView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
        
        textView.layoutIfNeeded()
    }
    
    func setupCloseButton() {
        view.insertSubview(closeButton, at: 0)
        view.bringSubviewToFront(closeButton)
        
        closeButton.setTitle("", for: .normal)
        closeButton.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.addTarget(self, action: #selector(didTapCloseButton(_:)), for: .touchUpInside)
        closeButton.tintColor = .systemGray2
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let top = closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24)
        let trailing = closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        let width = closeButton.widthAnchor.constraint(equalToConstant: 30)
        let height = closeButton.heightAnchor.constraint(equalToConstant: 30)
        
        NSLayoutConstraint.activate([top, trailing, width, height])
    }
    
    func setupRx(){
        viewModel.description.bind { [unowned self] (description) in
            DispatchQueue.main.async {
                if description.isEmpty {
                    self.textView.text = "No description available"
                }else{
                    self.textView.text = description
                }
            }
        }
        
        viewModel.error.bind { (error) in
            DispatchQueue.main.async {
                self.textView.text = error
            }
        }
    }

}

//MARK: Actions
extension CharacterDetailsVC {
    @objc
    func didTapCloseButton(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}
