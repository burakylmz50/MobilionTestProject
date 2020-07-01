//
//  FooterCollectionViewCell.swift
//  deneme
//
//  Created by Burak Yılmaz on 29.06.2020.
//  Copyright © 2020 Burak Yılmaz. All rights reserved.
//

import UIKit

class FooterCollectionViewCell: UICollectionViewCell {
    
    override init(frame : CGRect){
        super.init(frame : frame)
        posterImageContraints()
        weatherDateContraints()
        weatherTempContraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let weatherDate : UILabel = {
        let weatherDate = UILabel()
        weatherDate.textColor = UIColor.yellow
        weatherDate.font = UIFont.boldSystemFont(ofSize: 25.0)
        weatherDate.layer.cornerRadius = 10
        return weatherDate
    }()
    
    private func weatherDateContraints(){
        self.contentView.addSubview(weatherDate)
        weatherDate.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview()
        }
    }
    
    let posterImage : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor.yellow
        image.layer.cornerRadius = 25
        return image
    }()
    
    private func posterImageContraints(){
        self.contentView.addSubview(posterImage)
        posterImage.snp.makeConstraints { (make) in
            make.centerY.centerX.equalToSuperview()
            make.height.width.equalTo(60)
        }
    }
    
    let weatherTemp : UILabel = {
        let weatherTemp = UILabel()
        weatherTemp.textColor = UIColor.yellow
        weatherTemp.font = UIFont.boldSystemFont(ofSize: 25.0)
        return weatherTemp
    }()
    
    private func weatherTempContraints(){
        self.contentView.addSubview(weatherTemp)
        weatherTemp.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottomMargin.equalToSuperview()
        }
    }
}
