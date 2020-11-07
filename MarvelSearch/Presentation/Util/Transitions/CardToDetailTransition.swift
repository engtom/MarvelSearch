//
//  CardToDetailTransition.swift
//  MarvelSearch
//
//  Created by Everton Gonçalves on 03/11/20.
//

import Foundation
import UIKit

final class CardToDetailTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    let fromFrame: CGRect
    let fromFrameWithoutTransformation: CGRect
    let cell: CharacterCell
    
    init(fromFrame: CGRect, fromFrameWithoutTransformation: CGRect, cell: CharacterCell) {
        self.fromFrame = fromFrame
        self.fromFrameWithoutTransformation = fromFrameWithoutTransformation
        self.cell = cell
        super.init()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingCardAnimation(fromFrame: fromFrame, cell: cell)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissingCardAnimation(fromFrame: fromFrame, fromFrameWithoutTransformation: fromFrameWithoutTransformation, cell: cell)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}
