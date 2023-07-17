import UIKit
import SnapKit

class StartViewController: UIViewController {
    let progressBar = UIProgressView(progressViewStyle: .default)

    override func viewDidLoad() {
        super.viewDidLoad()
        let bgLayer = CALayer()
        bgLayer.frame = view.bounds
        view.layer.addSublayer(bgLayer)
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = UIColor.red.cgColor
        colorAnimation.toValue = UIColor.blue.cgColor
        colorAnimation.duration = 2
        colorAnimation.autoreverses = true
        colorAnimation.repeatCount = Float.infinity
        bgLayer.add(colorAnimation, forKey: "colorAnimation")
        let backgroundView = UIView(frame: self.view.bounds)
        self.view.addSubview(backgroundView)
        self.view.addSubview(progressBar)
        progressBar.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }

        let starCount = 70
        for _ in 0..<starCount {
            let starView = UIImageView(image: UIImage(named: "logo"))
            starView.contentMode = .scaleAspectFit
            starView.frame = CGRect(x: randomX(), y: randomY(), width: 20, height: 20)
            starView.alpha = 0.0
            self.view.addSubview(starView)
            UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                starView.alpha = 1.0
            })
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            let vc = ViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        startProgressBar()
    }

    private func randomX() -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(self.view.bounds.width)))
    }

    private func randomY() -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(self.view.bounds.height)))
    }

    private func startProgressBar() {
        var progress: Float = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { (timer) in
            progress += 0.1
            self.progressBar.progress = progress

            switch progress {
            case 0.1...0.2:
                self.progressBar.progressTintColor = .red
            case 0.3...0.4:
                self.progressBar.progressTintColor = .green
            case 0.5...0.6:
                self.progressBar.progressTintColor = .blue
            case 0.6...0.7:
                self.progressBar.progressTintColor = .yellow
            case 0.8...1.0:
                self.progressBar.progressTintColor = .systemPink
            default:
                break
            }
            if progress >= 1.0 {
                timer.invalidate()
            }
        }
    }
}

class ViewController: UIViewController {
    let imageView = UIImageView()
    var squares: [UIView] = []
    var animator: UIDynamicAnimator!
    let earthImageView = UIImageView(image: UIImage(named: "gem1"))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        view.addSubview(imageView)
        setupImage()
        makeConstraints()
        setupSquares()
        earthImageView.center = view.center
        view.addSubview(earthImageView)
        earthImageView.frame = CGRect(x: 0, y: 300, width: 400, height: 300)
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = CGFloat.pi * 2.0
        rotationAnimation.duration = 10
        rotationAnimation.repeatCount = .infinity
        earthImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    func setupImage() {
        if let image = UIImage(named: "eccomerce") {
            imageView.image = image
        }
    }

    func setupNavigationBar() {
        let openBarButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(openButtonTapped))
        navigationItem.leftBarButtonItem = openBarButton
        navigationItem.title = "Главная страница"
    }

    func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
            $0.width.equalTo(400)
            $0.height.equalTo(200)
        }
    }

    @objc func openButtonTapped() {
        let menuViewController = MenuViewController()
        if let sheet = menuViewController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
            sheet.detents = [.medium()]
        }
        present(menuViewController, animated: true, completion: nil)
    }

    func setupSquares() {
        for (index, _) in (0..<6).enumerated() {
            let square = UIImageView(image: UIImage(named: "coin"))
            square.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            view.addSubview(square)
            squares.append(square)

            let xPosition = view.bounds.midX + CGFloat(index * 60 - 150)
            square.center = CGPoint(x: xPosition, y: view.bounds.midY)
        }

        start()
    }

    func start() {
        animator = UIDynamicAnimator(referenceView: view)

        let gravityBehavior = UIGravityBehavior(items: squares)
        animator.addBehavior(gravityBehavior)

        let collisionBehavior = UICollisionBehavior(items: squares)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)

        let dynamicItemBehavior = UIDynamicItemBehavior(items: squares)
        dynamicItemBehavior.elasticity = 1
        animator.addBehavior(dynamicItemBehavior)
    }
}
