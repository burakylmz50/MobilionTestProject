//
//  ViewController.swift
//  deneme
//
//  Created by Burak Yılmaz on 28.06.2020.
//  Copyright © 2020 Burak Yılmaz. All rights reserved.
//

import UIKit
import CoreLocation
import SnapKit

class ViewController: UIViewController {
    
    let getLocation = GetLocation()
    var latitude : Double?
    var longitude : Double?
    var weatherArray = [WeatherModel]()
    var days : [String] = ["sat","sun","mon","tue","wed"]
    let mf = MeasurementFormatter()
    func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return mf.string(from: output)
    }
    
    lazy var homePageViewModel: HomePageViewModel = {
        let homePageVM = HomePageViewModel()
        homePageVM.delegate = self
        return homePageVM
    }()
    
    
    fileprivate var currentPage: Int = 0 {
        didSet{
            print("")
        }
    }
    fileprivate var pageSize: CGSize{
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
            
        } else{
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    
    fileprivate let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HomePageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    fileprivate let collectionView2 : UICollectionView = {
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        let collectionView2 = UICollectionView(frame: .zero, collectionViewLayout: layout2)
        collectionView2.translatesAutoresizingMaskIntoConstraints = false
        collectionView2.register(FooterCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView2
    }()
    
    
    let scrollView = UIScrollView()
    func setScrollView(){
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(0)
            make.leading.equalTo(view).offset(0)
            make.trailing.equalTo(view).offset(0)
            make.bottom.equalTo(view).offset(0)
        }
    }
    
    let container = UIView()
    func setContainer(){
        scrollView.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView.snp.top)
            make.left.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.height.equalTo(1300)
            make.bottom.equalTo(scrollView.snp.bottom).offset(-20)
        }
    }
    
    func setCollectionView(){
        view.addSubview(collectionView)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.equalTo(container).offset(0)
            make.top.equalTo(container).offset(50)
            make.height.equalTo(400)
        }
    }
    
    func setCollectionView2(){
        footerView.addSubview(collectionView2)
        collectionView2.showsVerticalScrollIndicator = false
        collectionView2.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.top.bottom.equalTo(0)
        }
    }
    func setupDelegate(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView2.delegate = self
        collectionView2.dataSource = self
    }
    
    //Footer
    let footerView = UIView()
    func setFooterView(){
        footerView.backgroundColor = UIColor.red
        footerView.layer.cornerRadius = 15
        container.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom).offset(50)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.height.equalTo(300)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScrollView()
        setContainer()
        setCollectionView()
        setupDelegate()
        
        setFooterView()
        setCollectionView2()
        //Updated Location
        getLocation.run(callback: {
            if let location = $0 {
                print("location = \(location.coordinate.latitude) \(location.coordinate.longitude)")
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude
            } else {
                print("Get Location failed \(String(describing: self.getLocation.didFailWithError))")
            }
            self.homePageViewModel.getData(latitude: String(describing:self.latitude!), longitude: String(describing:self.longitude!), completionHandler: {
                response in print(response)
                self.weatherArray = response
            })
        })
        
        let flowLayout = UPCarouselFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 60.0, height: collectionView.frame.size.height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sideItemScale = 0.8
        flowLayout.sideItemAlpha = 1.0
        flowLayout.spacingMode = .fixed(spacing: 5.0)
        collectionView.collectionViewLayout = flowLayout
        
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
            let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
            let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
            let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
            currentPage = Int(floor(offset - pageSide / 2) / pageSide + 1)
        }
    }
}

extension ViewController : HomePageViewModelDelegate{
    func homePagerequestCompleted() {
        print("Fonk bitti")
        collectionView.reloadData()
    }
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return homePageViewModel.homePageResultsArray.count
        if collectionView == self.collectionView2 {
            return 5
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomePageCollectionViewCell
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = Locale.init(identifier: "tr_TR")
            let dateObj = dateFormatter.date(from: weatherArray[0].list![indexPath.row].dt_txt!)
            dateFormatter.dateFormat = "HH:mm"
            
            cell.weatherDate.text = dateFormatter.string(from: dateObj!)
            cell.weatherTemp.text = convertTemp(temp: self.weatherArray[0].list![indexPath.row].main!.temp!, from: .kelvin, to: .celsius) // 18°C
            cell.posterImage.loadImageAsync(with: "http://openweathermap.org/img/w//" + self.weatherArray[0].list![indexPath.row].weather![0].icon! + ".png", completed: { })
            
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FooterCollectionViewCell
            cell.weatherDate.text = days[indexPath.row]
            cell.posterImage.loadImageAsync(with: "http://openweathermap.org/img/w//" + self.weatherArray[0].list![indexPath.row*8].weather![0].icon! + ".png", completed: { })
            cell.weatherTemp.text = convertTemp(temp: self.weatherArray[0].list![indexPath.row*8].main!.temp!, from: .kelvin, to: .celsius) // 18°C
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: 350, height: 263)
        }
        else{
            return CGSize(width: 100, height: 200)
        }
    }
    
    //TODO: Cell'lerin kenarlara olan uzaklıkları
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            
        }
        else{
            
        }
    }
}

extension UIButton {
    func getURL2(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data),
                httpURLResponse.url == url
                else { return }
            DispatchQueue.main.async() {
                self.setImage(image, for: .normal)
                self.imageView?.contentMode = .scaleAspectFit
                //self.image = image
            }
        }.resume()
    }
    
    public func downloadedFrom2(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        getURL2(url: url, contentMode: mode)
        
    }
}
