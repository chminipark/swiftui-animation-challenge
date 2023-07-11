//
//  _MaskableUIView.swift
//  MaskingImage
//
//  Created by minii on 2023/07/09.
//

import UIKit

class MaskableUIView: UIView {
  // MARK: - Private Property
  private let croppedImageUIView: UIImageView = {
    let uiImageView = UIImageView()
    uiImageView.contentMode = .scaleAspectFit
    return uiImageView
  }()
  
  private var renderer: UIGraphicsImageRenderer?
  private var maskImage: UIImage? = nil
  private var maskLayer = CALayer()
  private var shapeLayer = CAShapeLayer()
  private var panGestureRecognizer = TouchDownPanGestureRecognizer()
  
  typealias CacheContent = (CAShapeLayer, UIImage?)
  private var cache: [CacheContent] = []
  
  // MARK: - Public Property
  var curDrawingAction: DrawingAction
  var curCircleRadius: CGFloat
  var maskedImage: UIImage? {
    guard let renderer = renderer else { return nil}
    let result = renderer.image {
      context in
      
      return self.croppedImageUIView.layer.render(in: context.cgContext)
    }
    return result
  }
  
  // MARK: - initializer
  init(
    croppedImage: UIImage,
    curDrawingAction: DrawingAction,
    curCircleRadius: CGFloat
  ) {
    self.croppedImageUIView.image = croppedImage
    self.curDrawingAction = curDrawingAction
    self.curCircleRadius = curCircleRadius
    super.init(frame: .init())
    addMaskGesture()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addMaskGesture() {
    panGestureRecognizer.addTarget(self, action: #selector(gestureRecognizerUpdate))
    self.addGestureRecognizer(panGestureRecognizer)
  }
  
  private func setupLayout() {
    self.croppedImageUIView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(croppedImageUIView)
    
    croppedImageUIView.layer.mask = maskLayer
    croppedImageUIView.layer.superlayer?.addSublayer(shapeLayer)
  }
}

extension MaskableUIView {
  func updateBounds() {
    guard self.bounds != self.croppedImageUIView.frame else {
      return
    }
    
    self.croppedImageUIView.frame = self.bounds
    maskLayer.frame = self.layer.bounds
    shapeLayer.frame = self.layer.bounds
    shapeLayer.fillColor = UIColor.clear.cgColor
    
    renderer = UIGraphicsImageRenderer(size: self.bounds.size)
    guard let renderer = renderer else {
      return
    }
    let image = renderer.image { context in
      UIColor.black.setFill()
      context.fill(self.bounds, blendMode: .normal)
    }
    maskImage = image
    maskLayer.contents = maskImage?.cgImage
  }
}

extension MaskableUIView {
  @IBAction func gestureRecognizerUpdate(_ sender: UIGestureRecognizer) {
    let cgPoint = sender.location(in: self)
    if sender.state == .began {
      addToCache()
    }
    if sender.state != .ended {
      drawCircleAtPoint(cgPoint: cgPoint)
    } else {
      self.shapeLayer.path = nil
    }
  }
  
  private func drawCircleAtPoint(cgPoint: CGPoint) {
    guard let renderer = renderer else {
      return
    }
    let image = renderer.image { context in
      if let maskImage = maskImage {
        maskImage.draw(in: self.bounds)
        let rect = CGRect(origin: cgPoint, size: .zero)
          .insetBy(dx: -curCircleRadius/2, dy: -curCircleRadius/2)
        let color = UIColor.black.cgColor
        context.cgContext.setFillColor(color)
        let blendMode: CGBlendMode
        let alpha: CGFloat
        
        if curDrawingAction == .erase {
          blendMode = .sourceIn
          alpha = 0
        } else {
          blendMode = .normal
          alpha = 1
        }
        
        let circlePath = UIBezierPath(ovalIn: rect)
        circlePath.fill(with: blendMode, alpha: alpha)
        shapeLayer.path = circlePath.cgPath
      }
    }
    
    maskImage = image
    maskLayer.contents = maskImage?.cgImage
  }
}

// Undo, cache Method
extension MaskableUIView {
  func undo() {
    guard let tmpCache = self.cache.popLast() else {
      return
    }
    let tmpShapeLayer = tmpCache.0
    let tmpMaskImage = tmpCache.1
    
    self.shapeLayer = tmpShapeLayer
    self.maskImage = tmpMaskImage
    self.maskLayer.contents = tmpMaskImage?.cgImage
  }
  
  func addToCache() {
    guard let tmpCGImage = self.maskImage?.cgImage else {
      return
    }
    let tmpMaskImage = UIImage(cgImage: tmpCGImage)
    let tmpShapeLayer = CAShapeLayer(layer: self.shapeLayer)
    
    let element: CacheContent = (tmpShapeLayer, tmpMaskImage)
    self.cache.append(element)
  }
}

// Reset, trash method
extension MaskableUIView {
  func reset() {
    self.cache = []
    
    shapeLayer.fillColor = UIColor.clear.cgColor
    guard let renderer = renderer else { return }
    let image = renderer.image { (ctx) in
      UIColor.black.setFill()
      ctx.fill(self.bounds, blendMode: .normal)
    }
    maskImage = image
    maskLayer.contents = maskImage?.cgImage
  }
}

import SwiftUI

struct MaskableUIView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
  }
}
