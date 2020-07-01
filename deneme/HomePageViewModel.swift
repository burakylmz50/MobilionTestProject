//
//  HomePageViewModel.swift
//  deneme
//
//  Created by Burak Yılmaz on 28.06.2020.
//  Copyright © 2020 Burak Yılmaz. All rights reserved.
//

import Foundation

protocol HomePageViewModelDelegate{
    func homePagerequestCompleted()
}

class HomePageViewModel{
    var homePageArray = [WeatherModel]()
    var delegate: HomePageViewModelDelegate?
}

extension HomePageViewModel{
    func getData(latitude:String,longitude:String,completionHandler:@escaping([WeatherModel])-> ()){
        var request = URLRequest(url: URL(string:"http://api.openweathermap.org/data/2.5/forecast?lat=" + latitude + "&lon=" + longitude + "&appid=949edb4b6f9692d3ce0866f361ac3d55")!)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try? Data(contentsOf: request.url!)
        
        do {
            let json = try? JSONDecoder().decode(WeatherModel.self, from: data!)
            homePageArray.append(json!)
            
        }
        completionHandler(homePageArray)
        self.delegate?.homePagerequestCompleted()
    }
}
