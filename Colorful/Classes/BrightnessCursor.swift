//
//  HRBrightnessCursor.swift
//  ColorPicker3
//
//  Created by Ryota Hayashi on 2020/05/06.
//  Copyright © 2020 Hayashi Ryota. All rights reserved.
//

import UIKit

internal class BrightnessCursor: UIView {

    let texfField = UITextField()
    var needToChangeColor: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.5
        layer.borderWidth = 1
        if #available(iOS 13.0, *) {
            texfField.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .light)
        } else {
            texfField.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .light)
        }

        texfField.textAlignment = .center
        texfField.isUserInteractionEnabled = true
        texfField.delegate = self
        addSubview(texfField)
        isUserInteractionEnabled = false
    }

    func set(hsv: HSVColor) {
        backgroundColor = hsv.uiColor
        let borderColor = hsv.borderColor
        layer.borderColor = borderColor.cgColor
        texfField.textColor = borderColor
        texfField.text = hsv.rgbColor.hexString
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 6
        texfField.frame = bounds
    }
}

extension BrightnessCursor: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        needToChangeColor?(textField.text ?? "FFFFFF")
        textField.resignFirstResponder()
        return true
    }
}

extension RGBColor {
    var hexString: String {
        return String(format: "#%02x%02x%02x", red, green, blue)
    }
}

extension UIColor {
    convenience init(hex string: String) {
        var hex = string.hasPrefix("#")
            ? String(string.dropFirst())
            : string
        guard hex.count == 3 || hex.count == 6
            else {
                self.init(white: 1.0, alpha: 0.0)
                return
        }
        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }
        if let intHex = Int(hex, radix: 16) {
            self.init(
                red: CGFloat((intHex >> 16) & 0xFF) / 255.0,
                green: CGFloat((intHex >> 8) & 0xFF) / 255.0,
                blue: CGFloat((intHex) & 0xFF) / 255.0, alpha: 1.0)
        } else {
            self.init(white: 1.0, alpha: 0.0)
        }
    }
}
