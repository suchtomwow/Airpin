import UIKit
import PlaygroundSupport

extension UIColor {

  convenience init(hex: Int) {
    let components = (
      R: CGFloat((hex >> 16) & 0xff) / 255,
      G: CGFloat((hex >> 08) & 0xff) / 255,
      B: CGFloat((hex >> 00) & 0xff) / 255
    )

    self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
  }

  class var primary: UIColor {
    return UIColor(hex: 0x2FE0AC)
  }

}

class Tag: UIButton {

  enum Configuration {
    static let contentEdgeInsets = UIEdgeInsets(top: 3.0, left: 7.0, bottom: 4.0, right: 7.0)
    static let cornerRadius: CGFloat = 3
  }

  enum Mode {
    case `default`, suggestion
  }

  var label: String {
    didSet {
      setTitle(label, for: .normal)
    }
  }

  var mode: Mode {
    didSet {
      let hideDashedBorder: Bool
      let backgroundColor: UIColor
      let titleColor: UIColor

      if mode == .suggestion {
        hideDashedBorder = false
        backgroundColor = .white
        titleColor = .primary
      } else {
        hideDashedBorder = true
        backgroundColor = .primary
        titleColor = .white
      }

      UIView.animate(withDuration: 0.15) {
        self.dashedBorder.isHidden = hideDashedBorder
        self.backgroundColor = backgroundColor
        self.setTitleColor(titleColor, for: .normal)
      }
    }
  }

  private var dashedBorder: CAShapeLayer {
    let border = CAShapeLayer()
    border.fillColor = nil
    border.lineWidth = 3
    border.lineDashPattern = [4, 4]

    border.path = UIBezierPath(roundedRect: bounds, cornerRadius: Configuration.cornerRadius).cgPath
    border.frame = bounds

    return border
  }

  init(label: String, mode: Mode = .default) {
    self.label = label
    self.mode = mode

    super.init(frame: CGRect(x: 0, y: 0, width: 45, height: 30))

    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func commonInit() {
    configureView()
    configureStyles()
  }

  func configureView() {
    contentEdgeInsets  = Configuration.contentEdgeInsets
    clipsToBounds      = true
    layer.cornerRadius = Configuration.cornerRadius

    setTitle(label, for: .normal)
  }

  func configureStyles() {
    backgroundColor = .primary
  }
}

class Responder {
  @objc func action(sender: Tag) {
    sender.mode = sender.mode == .default ? .suggestion : .default
  }
}

let tag = Tag(label: "ios", mode: .suggestion)

let border = CAShapeLayer()
border.strokeColor = UIColor.primary.cgColor
border.fillColor = nil
border.lineWidth = 3
border.lineDashPattern = [4, 4]

border.path = UIBezierPath(roundedRect: tag.bounds, cornerRadius: tag.layer.cornerRadius).cgPath
border.frame = tag.bounds

tag.layer.addSublayer(border)

tag.backgroundColor = .white
tag.setTitleColor(.primary, for: .normal)

let responder = Responder()
tag.addTarget(responder, action: #selector(Responder.action(sender:)), for: .touchUpInside)

let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
view.addSubview(tag)
tag.center = view.center
view.backgroundColor = .white

PlaygroundPage.current.liveView = view

