//
//  UIViewController+animations.swift
//  Reciplease
//
//  Created by Benjamin Breton on 28/01/2021.
//

import Foundation
import UIKit
extension UIViewController {
    enum ExitDirection {
        case left, right, up, down
        var translationX: CGFloat {
            switch self {
            case .left:
                return -UIScreen.main.bounds.width * 2
            case .right:
                return UIScreen.main.bounds.width * 2
            default:
                return 0
            }
        }
        var translationY: CGFloat {
            switch self {
            case .up:
                return -UIScreen.main.bounds.height * 2
            case .down:
                return UIScreen.main.bounds.height * 2
            default:
                return 0
            }
        }
    }
    func exit(view: UIView, direction: ExitDirection) {
        animate(view: view) {
            let transform = CGAffineTransform(translationX: direction.translationX, y: direction.translationY)
            view.transform = transform
        }
    }
    func returnIdentity(_ view: UIView) {
        animate(view: view) {
            view.transform = .identity
        }
    }
    private func animate(view: UIView, animations: @escaping () -> Void) {
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, animations: animations, completion: nil)
    }
}
