import UIKit
protocol TabBarDelegate {
    func buttonPressed(rank: Int)
}
class TabBar: UIView {
    
    var path = UIBezierPath()
    var startPoint = 1
    private var gap: CGFloat = 0.0
    private var bezierView: UIView!
    private var shapeMask = CAShapeLayer()
    private var circle: UIView!
    private var firstPoint:CGFloat = 0.0
    private var buttons = [UIButton]()
    private let k = K()
    
    var delegate: TabBarDelegate?
    
    override func draw(_ rect: CGRect) {
        
        initializeTabBar()
        
    }
    private func initializeTabBar() {
        self.subviews.forEach({$0.removeFromSuperview()})
        self.backgroundColor = k.mainColorBackground
        bezierView = UIView()
        bezierView.frame = self.bounds
        bezierView.backgroundColor = k.mainColorTheme
        self.addSubview(bezierView)
        createBezier()
        addCircle()
        addButtons()
        addGradientView()
    }
    private func addGradientView() {
        
        let gradient = UIView()
        gradient.frame.size = CGSize(width: self.frame.size.width, height: 100)
        gradient.frame.origin.x = -1
        gradient.frame.origin.y = -100
        gradient.backgroundColor = .clear
        
        self.insertSubview(gradient, at: 0)
        addGradient(for: gradient)
    }
    private func addGradient(for view: UIView) {
        
        let gradient = CAGradientLayer()
        
        gradient.colors = [k.mainColorBackground.withAlphaComponent(0.0).cgColor, k.mainColorBackground.withAlphaComponent(1.0).cgColor, k.mainColorBackground.withAlphaComponent(1.0).cgColor]
        
        gradient.locations = [NSNumber(value: 0.0),NSNumber(value: 0.8),NSNumber(value: 1.0)]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1)
        gradient.frame = view.bounds
        print(view.bounds)
        //        gradient.cornerRadius = self.circle.frame.size.height / 2
        view.layer.addSublayer(gradient)
    }
    private func addButtons() {
        
        buttons.forEach({$0.removeFromSuperview()})
        buttons.removeAll()
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        let position = [0,width/4,width/2,width*3/4]
        
        let imagesStrings = ["doc.richtext","square.grid.2x2","magnifyingglass.circle","person.crop.circle"]
        
        for i in 0...3 {
            let newB = UIButton()
            newB.frame.origin.x = position[i]
            newB.frame.origin.y = 0
            newB.tintColor = .white
            if i == startPoint - 1 {
                newB.frame.origin.y = -height / 2
            }
            newB.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            newB.frame.size = CGSize(width: width/4, height: height)
            newB.backgroundColor = .clear
            let config = UIImage.SymbolConfiguration(pointSize: 30)
            newB.setImage(UIImage(systemName: imagesStrings[i], withConfiguration: config), for: .normal)
            
            newB.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            
            self.addSubview(newB)
            
            buttons.append(newB)
        }
        
    }
    @objc private func buttonPressed(_ sender: UIButton!) {
        
        switch sender {
        case buttons[0]:
            startPoint = 1
        case buttons[1]:
            startPoint = 2
        case buttons[2]:
            startPoint = 3
        case buttons[3]:
            startPoint = 4
        default:
            startPoint = 1
        }
        self.animateShape()
        
        delegate?.buttonPressed(rank: startPoint)
        
    }
    private func addCircle() {
        
        let width = self.frame.size.width
        let sizeWidth = width/4 - 30
        gap = width/4
        
        switch startPoint {
        case 1:
            firstPoint = 0
        case 2:
            firstPoint = width/4
        case 3:
            firstPoint = width/2
        case 4:
            firstPoint = width * 3/4
        default:
            firstPoint = 0
        }
        
        circle = UIView()
        circle.frame.size = CGSize(width: sizeWidth, height: sizeWidth)
        circle.center.x = firstPoint + gap/2
        circle.center.y = 0
        circle.backgroundColor = k.mainColorTheme
        circle.layer.cornerRadius = sizeWidth/2
        
        self.addSubview(circle)
        
    }
    private func drawPath() -> UIBezierPath{
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        gap = width/4
        let depth = height * 0.45
        
        switch startPoint {
        case 1:
            firstPoint = 0
        case 2:
            firstPoint = width/4
        case 3:
            firstPoint = width/2
        case 4:
            firstPoint = width * 3/4
        default:
            firstPoint = 0
        }
        
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        
        bezierPath.addLine(to: CGPoint(x: firstPoint - gap/2, y: 0.0))
        
        bezierPath.addCurve(to: CGPoint(x: firstPoint + gap/2, y: depth),
                            controlPoint1: CGPoint(x: firstPoint + gap/4 - gap/8, y: 0),
                            controlPoint2: CGPoint(x: firstPoint + gap/4 - gap/8, y: depth))
        
        bezierPath.addCurve(to: CGPoint(x: firstPoint + gap + gap/2, y: 0),
                            controlPoint1: CGPoint(x: firstPoint + 3/4 * gap + gap/8, y: depth),
                            controlPoint2: CGPoint(x: firstPoint + 3/4 * gap + gap/8, y: 0))
        
        bezierPath.addLine(to: CGPoint(x: width, y: 0))
        bezierPath.addLine(to: CGPoint(x: width, y: height))
        bezierPath.addLine(to: CGPoint(x: 0, y: height))
        bezierPath.close()
        
        return bezierPath
        
    }
    private func createBezier() {

        let bezierPath = drawPath()
        
        shapeMask.path = bezierPath.cgPath
        self.bezierView.layer.mask = shapeMask
    
//        self.addSubview(bezierView)
        
    }
    func animateShape() {
        let newShapePath = self.drawPath().cgPath
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.4
        animation.toValue = newShapePath
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.delegate = self
        
        self.shapeMask.add(animation, forKey: "path")
        
        UIView.animate(withDuration: 0.4, delay: 0.02, options: .curveEaseInOut, animations: {
            self.circle.center.x = self.firstPoint + self.gap/2
        }, completion: nil)
        for (i,button) in buttons.enumerated() {
            UIView.animate(withDuration: 0.4, animations: {
                button.frame.origin.y = i == self.startPoint - 1 ? -self.frame.size.height/2 : 0.0
            }, completion: nil)
        }
    }
    
}
extension TabBar: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.createBezier()
        }
    }
}
