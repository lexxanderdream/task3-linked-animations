//
//  ViewController.swift
//  linked-animations
//
//  Created by Alexander Zhuchkov on 09.02.2024.
//

import UIKit

/**
 
 На экране квадратная вью и слайдер. Вью перемещается из левого края в правый с поворотом и увеличением.

 - В конечной точке вью должна быть справа (минус отступ), увеличится в 1.5 раза и повернуться на 90 градусов.
 - Когда отпускаем слайдер, анимация идет до конца с текущего места.
 - Слева и справа отступы layout margins. Отступ как для квадратной вью, так и для слайдера.
 
 */
class ViewController: UIViewController {

    // MARK: - Properties
    private lazy var animator: UIViewPropertyAnimator = {
        let animator = UIViewPropertyAnimator(duration: 0.66, curve: .linear)
        
        // Setup Animator
        animator.pausesOnCompletion = true
        
        // Add Animations
        let rotate = CGAffineTransform(scaleX: 1.5, y: 1.5)
        let scale = CGAffineTransform(rotationAngle: .pi / 2)
        
        animator.addAnimations {
            self.squareView.transform = CGAffineTransformConcat(rotate, scale)
            self.squareView.frame.origin.x = self.view.frame.width - self.squareView.frame.width - self.view.layoutMargins.right
        }
        
        
        //
        return animator
    }()
    
    // MARK: - Subviews
    private let squareView: UIView = {
        let view = UIView()
        
        // Setup
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.layer.cornerRadius = 20
        
        // Size
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        
        //
        return view
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderValueChanged(slider:event:)), for: .valueChanged)
        
        return slider
    }()
    
    
    // MARK: - Helper Methods
    private func setupView() {
        view.addSubview(squareView)
        view.addSubview(slider)
        
        squareView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        squareView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100).isActive = true
        
        slider.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        slider.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        slider.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
    }
    
    
    @objc
    private func sliderValueChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                animator.pauseAnimation()
            case .moved:
                animator.fractionComplete = CGFloat(slider.value)
            case .ended:
                animator.startAnimation()
                
                // Calculate duration
                let duration = animator.duration - animator.duration * animator.fractionComplete
                UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear]) {
                    slider.setValue(1, animated: true)
                }
            default:
                break
            }
        }
    }

}

// MARK: - UIViewController Life Cycle
extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
    }


}
