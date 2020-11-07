//
//  DismissingCardAnimation.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 03/11/20.
//

import Foundation
import UIKit

final class DismissingCardAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    let fromFrame: CGRect
    let fromFrameWithoutTransformation: CGRect
    let cell: UICollectionViewCell
    
    init(fromFrame: CGRect, fromFrameWithoutTransformation: CGRect, cell: UICollectionViewCell){
        self.fromFrame = fromFrame
        self.fromFrameWithoutTransformation = fromFrameWithoutTransformation
        self.cell = cell
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let context = transitionContext
        let container = context.containerView
        let screens: (detail: CharacterDetailsVC, home: UINavigationController) = (
            context.viewController(forKey: .from)! as! CharacterDetailsVC,
            context.viewController(forKey: .to)! as! UINavigationController
        )
        
        screens.detail.closeButton.isHidden = true
        let detailView = context.view(forKey: .from)!
        
        let animatedContainerView = UIView()
        animatedContainerView.translatesAutoresizingMaskIntoConstraints = false
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        container.removeConstraints(container.constraints)
        
        container.addSubview(animatedContainerView)
        animatedContainerView.addSubview(detailView)
        
        detailView.edges(to: animatedContainerView)
        
        let center = animatedContainerView.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        let top = animatedContainerView.topAnchor.constraint(equalTo: container.topAnchor)
        let width = animatedContainerView.widthAnchor.constraint(equalToConstant: detailView.frame.width)
        let height = animatedContainerView.heightAnchor.constraint(equalToConstant: detailView.frame.height)
        
        NSLayoutConstraint.activate([center, top, width, height])
        
        container.layoutIfNeeded()
        
        func animateCardViewBackToPlace() {
            detailView.transform = CGAffineTransform.identity
            animatedContainerView.layer.cornerRadius = 15
            animatedContainerView.clipsToBounds = true
            
            let isOnLeft = fromFrameWithoutTransformation.minX < detailView.bounds.width / 2
            let horizontalDelta = isOnLeft ? (fromFrame.width/2 - 8) * -1 : (fromFrame.width/2 - 8)
            
            center.constant = horizontalDelta
            top.constant = fromFrameWithoutTransformation.minY
            width.constant = fromFrameWithoutTransformation.width
            height.constant = fromFrameWithoutTransformation.height
            container.layoutIfNeeded()
        }
        
        func finishingAnimations(){
            let success = !context.transitionWasCancelled
            animatedContainerView.removeConstraints(animatedContainerView.constraints)
            animatedContainerView.removeFromSuperview()
            
            if success {
                detailView.removeFromSuperview()
                DispatchQueue.main.async {
                    self.cell.contentView.isHidden = false
                }
                
            }else{
                
                detailView.removeConstraint(forceCardToFillBottom)
                
                container.removeConstraints(container.constraints)
                
                container.addSubview(detailView)
                detailView.edges(to: container)
            }
            context.completeTransition(success)
        }
        
        UIView.animate(withDuration: transitionDuration(using: context), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: []) {
            animateCardViewBackToPlace()
        } completion: { (finished) in
            finishingAnimations()
        }
        
        UIView.animate(withDuration: transitionDuration(using: context) * 0.6) {
            screens.detail.scrollView.contentOffset = .zero
        }

    }
    
    
}
