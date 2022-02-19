//
//  BaseViewController.swift
//  SecondWeatherApp
//
//  Created by Shakhzod Bektemirov on 2022/02/19.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    private lazy var backGroundImage:UIImageView =  {
        let image = UIImageView()
        image.image = UIImage(named:"backgroundImage")
        image.contentMode = .scaleAspectFill
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backGroundImage)
        backGroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
