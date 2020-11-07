//
//  PresentingCardAnimation.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 03/11/20.
//

import Foundation
import UIKit

final class PresentingCardAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    let fromFrame: CGRect
    let cell: CharacterCell
    
    private let presentAnimationDuration: TimeInterval
    private let sprintAnimator: UIViewPropertyAnimator
    private var transitionDriver: PresentCardTransitionDriver?
    
    init(fromFrame: CGRect, cell: CharacterCell){
        self.fromFrame = fromFrame
        self.cell = cell
        self.sprintAnimator = PresentingCardAnimation.createBaseSpringAnimator(fromFrame: fromFrame, cell: cell)
        self.presentAnimationDuration = sprintAnimator.duration
        super.init()
    }
    
    private static func createBaseSpringAnimator(fromFrame: CGRect, cell: CharacterCell) -> UIViewPropertyAnimator {
        let positionY = fromFrame.minY
        let distanceToBounce = abs(positionY)
        let extentToBounce = positionY < 0 ? fromFrame.height : UIScreen.main.bounds.height
        let dampFactoryInterval: CGFloat = 0.3
        let damping: CGFloat = 1.0 - dampFactoryInterval * (distanceToBounce / extentToBounce)
        
        let baselineDuration: TimeInterval = 0.5
        let maxDuration: TimeInterval = 0.9
        let duration: TimeInterval = baselineDuration + (maxDuration - baselineDuration) * TimeInterval(max(0, distanceToBounce)/UIScreen.main.bounds.height)
        
        let springTiming = UISpringTimingParameters(dampingRatio: damping, initialVelocity: .init(dx: 0, dy: 0))
        return UIViewPropertyAnimator(duration: duration, timingParameters: springTiming)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presentAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionDriver = PresentCardTransitionDriver(fromFrame: fromFrame, cell: cell, transtionContext: transitionContext, baseAnimator: sprintAnimator)
        
        interruptibleAnimator(using: transitionContext).startAnimation()
    }
    
    
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return transitionDriver!.animator
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        transitionDriver = nil
    }
    
}

final class PresentCardTransitionDriver {
    
    let animator : UIViewPropertyAnimator
    
    init(fromFrame: CGRect, cell: CharacterCell, transtionContext: UIViewControllerContextTransitioning, baseAnimator: UIViewPropertyAnimator){
        let context = transtionContext
        let container = context.containerView
        let screens: (list: UINavigationController, detail: CharacterDetailsVC) = (
            context.viewController(forKey: .from) as! UINavigationController,
            context.viewController(forKey: .to) as! CharacterDetailsVC
        )
        
        let detailView = context.view(forKey: .to)!
        let initialFrame = fromFrame
        
        let animatedContainerView = UIView()
        animatedContainerView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(animatedContainerView)
        
        do {
            let animatedContainerConstraints = [
                animatedContainerView.widthAnchor.constraint(equalToConstant: container.bounds.width),
                animatedContainerView.heightAnchor.constraint(equalToConstant: container.bounds.height),
            ]
            
            NSLayoutConstraint.activate(animatedContainerConstraints)
        }
        
        let animatedContainerVerticalConstraints: NSLayoutConstraint = {
            animatedContainerView.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: (fromFrame.height/2 + fromFrame.minY) - container.bounds.height/2)
        }()
        
        let animatedContainerHorizontalConstraints: NSLayoutConstraint = {
            
            let isOnLeft = fromFrame.origin.x < container.bounds.width / 2
            let horizontalDelta: CGFloat = isOnLeft ? (fromFrame.width/2 - 8) * -1 : (fromFrame.width/2) - 8
            
            return animatedContainerView.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: horizontalDelta)
        }()
        
        animatedContainerVerticalConstraints.isActive = true
        animatedContainerHorizontalConstraints.isActive = true
        
        animatedContainerView.addSubview(detailView)
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        do {
            let verticalAnchor: NSLayoutConstraint = detailView.centerYAnchor.constraint(equalTo: animatedContainerView.centerYAnchor)
            let horizontalAnchor: NSLayoutConstraint = detailView.centerXAnchor.constraint(equalTo: animatedContainerView.centerXAnchor)
            
            let cardConstraints = [
                verticalAnchor,
                horizontalAnchor
            ]
            NSLayoutConstraint.activate(cardConstraints)
        }
        
        let cardWidthConstraint = detailView.widthAnchor.constraint(equalToConstant: initialFrame.width)
        let cardHeightConstraint = detailView.heightAnchor.constraint(equalToConstant: initialFrame.height)
        NSLayoutConstraint.activate([cardWidthConstraint, cardHeightConstraint])
        
        detailView.layer.cornerRadius = 15
        
        cell.contentView.isHidden = true
    
        container.layoutIfNeeded()
        
        func animateContainerBouncingUp() {
            animatedContainerVerticalConstraints.constant = 0
            animatedContainerHorizontalConstraints.constant = 0
            container.layoutIfNeeded()
        }
        
        func animatedCardDetailViewSizing() {
            cardWidthConstraint.constant = animatedContainerView.bounds.width
            cardHeightConstraint.constant = animatedContainerView.bounds.height
            detailView.layer.cornerRadius = 0
            container.layoutIfNeeded()
        }
        
        func finishingAnimations() {
            animatedContainerView.removeConstraints(animatedContainerView.constraints)
            animatedContainerView.removeFromSuperview()
            
            container.addSubview(detailView)
            
            detailView.removeConstraints([cardWidthConstraint, cardHeightConstraint])
            
            detailView.edges(to: container, top: -1)
            
            screens.detail.scrollView.isScrollEnabled = true
            
            let suceess = !context.transitionWasCancelled
            context.completeTransition(suceess)
        }
        
        baseAnimator.addAnimations {
            animateContainerBouncingUp()
            
            let cardExpanding = UIViewPropertyAnimator(duration: baseAnimator.duration * 0.6, curve: .linear) {
                animatedCardDetailViewSizing()
            }
            cardExpanding.startAnimation()
        }
        
        baseAnimator.addCompletion { (_) in
            finishingAnimations()
        }
        
        
        self.animator = baseAnimator
        
    }
    
}
