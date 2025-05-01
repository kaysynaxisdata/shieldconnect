//
//  SpeedCheckerView.swift
//  shield-connect
//
//  Created by Александр on 13.04.2025.
//

import UIKit

class SpeedCheckerView: UIView {
    
    private let pointer = UIView()
    
    private let startAngle = CGFloat.pi * 0.85
    private let endAngle = CGFloat.pi * 2.13
    private var shapeLayer: CAShapeLayer?
    
    private var whiteLayer: CALayer?
    private var arcGradientLayer: CALayer?
    
    private lazy var label: UILabel = {
        var label = ViewFactory.label(
            font: FontFamily.RedHatText.medium.font(size: 20),
            color: Asset.mainSecondary.color
        )
        label.text = "-"
        label.alpha = 0.5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Центральный круг (фон)
        let angularView = UIImageView(image: Asset.speedcheckerAngular.image)
        let backView = UIImageView(image: Asset.speedcheckerThumb.image)
        
        angularView.contentMode = .center
        backView.contentMode = .center
        
        addSubview(angularView)
        addSubview(backView)
        
        angularView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(32)
        }
        
        // Стрелка
        pointer.backgroundColor = UIColor.white
        pointer.layer.cornerRadius = 2
        pointer.layer.shadowColor = Asset.mainPurple.color.withAlphaComponent(0.3).cgColor
        pointer.layer.shadowOpacity = 0.6
        pointer.layer.shadowOffset = CGSize(width: 0, height: 4)
        pointer.layer.shadowRadius = 5
        addSubview(pointer)
        
        let pointerLength = bounds.width * 0.5
        pointer.bounds = CGRect(x: 0, y: 0, width: pointerLength, height: 6)
        pointer.center = center
        pointer.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        let startAngle = self.startAngle
        let fullTransform = CGAffineTransform(rotationAngle: startAngle)
        pointer.transform = fullTransform
        
        DispatchQueue.main.async {
            let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            let radius = self.bounds.width * 0.45
            let lineWidth: CGFloat = 6

            self.whiteLayer = self.createWhiteArc(center: center, radius: radius, lineWidth: lineWidth, startAngle: self.startAngle, endAngle: self.endAngle)
            if let whiteLayer = self.whiteLayer {
                self.layer.insertSublayer(whiteLayer, below: self.pointer.layer)
            }

            self.arcGradientLayer = self.createGradientArc(center: center, radius: radius, lineWidth: lineWidth, startAngle: self.startAngle, endAngle: self.endAngle)
            if let arcGradientLayer = self.arcGradientLayer {
                self.layer.insertSublayer(arcGradientLayer, below: self.pointer.layer)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        // Размеры и углы дуги
        let radius = bounds.width * 0.45
        let lineWidth: CGFloat = 6
        
        let pointerLength = bounds.width * 0.5
        pointer.bounds = CGRect(x: 0, y: 0, width: pointerLength, height: 6)
        pointer.center = CGPoint(x: bounds.midX, y: bounds.midY)
        pointer.layer.anchorPoint = CGPoint(x: 0, y: 0.5)

    }
    
    func setAngle(_ angle: CGFloat, animated: Bool = true) {
        let startAngle = CGFloat.pi * 0.8
        let fullTransform = CGAffineTransform(rotationAngle: startAngle + angle)

        if animated {
            UIView.animate(withDuration: 0.3) {
                self.pointer.transform = fullTransform
            }
        } else {
            pointer.transform = fullTransform
        }
    }
    
    func setProgress(_ progress: CGFloat, animated: Bool = true) {
        // clamp
        let clamped = max(0, min(1, progress))
        
        // Вычисляем угол стрелки относительно дуги
        let totalAngle = endAngle - startAngle
        let angle = totalAngle * clamped

        // Поворачиваем стрелку
        let pointerAngle = startAngle + clamped * totalAngle
        let transform = CGAffineTransform(rotationAngle: pointerAngle)

        let duration: CFTimeInterval = 1.5
        
        guard let shapeMask = arcGradientLayer?.mask as? CAShapeLayer else {
            print("Нет маски у градиентного слоя")
            return
        }

        if animated {
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(duration)
            CATransaction.setDisableActions(false)
            
            let currentStroke = shapeMask.presentation()?.strokeEnd ?? shapeMask.strokeEnd
            let strokeAnim = CABasicAnimation(keyPath: "strokeEnd")
//            strokeAnim.fromValue = shapeMask.presentation()?.strokeEnd ?? shapeMask.strokeEnd
            strokeAnim.fromValue = currentStroke
            strokeAnim.toValue = clamped
            strokeAnim.duration = duration
            strokeAnim.fillMode = .forwards
            strokeAnim.isRemovedOnCompletion = false
            shapeMask.add(strokeAnim, forKey: "strokeEnd")
        } else {
            shapeMask.strokeEnd = clamped
        }

        UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear], animations: {
            self.pointer.transform = transform
        })

        CATransaction.commit()
        
    }
    
    func configure(result: String) {
        self.label.text = result
    }
    
    private func createGradientArc(center: CGPoint, radius: CGFloat, lineWidth: CGFloat, startAngle: CGFloat, endAngle: CGFloat) -> CALayer {
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        
        // Градиент
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.systemPink.cgColor,
            UIColor.systemRed.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.locations = [0, 0.5, 1]
        gradient.mask = shapeLayer
        self.shapeLayer = shapeLayer
        
        return gradient
    }
    
    private func createWhiteArc(center: CGPoint, radius: CGFloat, lineWidth: CGFloat, startAngle: CGFloat, endAngle: CGFloat) -> CALayer {
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        return shapeLayer
    }
    
}
