//
//  MoviesCollectionViewCell.swift
//  MoviesApplication
//
//  Created by Burak Yılmaz on 25.05.2020.
//  Copyright © 2020 Burak Yılmaz. All rights reserved.
//

import UIKit

class HomePageCollectionViewCell: UICollectionViewCell {
    
    override init(frame : CGRect){
        super.init(frame : frame)
        posterImageContraints()
        weatherDateBackContraints()
        weatherDateContraints()
        weatherTempContraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let posterImage : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.30)
        image.layer.cornerRadius = 25
        return image
    }()
    
    private func posterImageContraints(){
        self.contentView.addSubview(posterImage)
        posterImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(300)
        }
    }
    
    let weatherDateBack : UIImageView = {
        let weatherDateBack = UIImageView()
        weatherDateBack.layer.cornerRadius = 25
        weatherDateBack.backgroundColor = UIColor.brown
        return weatherDateBack
    }()
    
    private func weatherDateBackContraints(){
        self.contentView.addSubview(weatherDateBack)
        weatherDateBack.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(0)
            make.height.equalTo(70)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
        }
    }
    
    let weatherDate : UILabel = {
        let weatherDate = UILabel()
        weatherDate.textColor = UIColor.yellow
        weatherDate.font = UIFont.boldSystemFont(ofSize: 25.0)
        weatherDate.layer.cornerRadius = 10
        return weatherDate
    }()
    
    private func weatherDateContraints(){
        self.weatherDateBack.addSubview(weatherDate)
        weatherDate.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    let weatherTemp : UILabel = {
        let weatherTemp = UILabel()
        weatherTemp.textColor = UIColor.yellow
        weatherTemp.font = UIFont.boldSystemFont(ofSize: 25.0)
        return weatherTemp
    }()
    
    private func weatherTempContraints(){
        self.posterImage.addSubview(weatherTemp)
        weatherTemp.snp.makeConstraints { (make) in
            make.top.equalTo(posterImage.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
    }
}

