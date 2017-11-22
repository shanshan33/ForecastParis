//
//  CollectionReusableHeaderView.swift
//  Weather
//
//  Created by Shanshan Zhao on 22/11/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import UIKit

/**
 *  A 'CollectionReusableHeaderView' contains 3 buttons: weather, news, photos,
 *  The idea is to click on button to switch the list,
 *  for the moment, the only data is weather :)
 *  i add a gray tab view to animate and hightlight the choosen list
 */

enum SelectedList : Int {
    case weather = 0
    case news    = 1
    case photos  = 2
}

class CollectionReusableHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var weatherButton: UIButton!
    @IBOutlet weak var photosButton: UIButton!
    @IBOutlet weak var newsButton: UIButton!
    
    
    var grayTabWeatherCenterXConstraint: NSLayoutConstraint! = nil
    var grayTabNewsCenterXConstraint :NSLayoutConstraint! = nil
    var grayTabPhotosCenterXConstraint :NSLayoutConstraint! = nil
    
    @IBOutlet weak var grayTabView: UIView!

    var persistentSelectedListType: SelectedList {
        get {
            let storedValue = UserDefaults.standard.integer(forKey: "SelectedListType")
            return SelectedList(rawValue: storedValue) ?? .weather
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "SelectedListType")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareConstraints()
    }
    
    private func prepareConstraints() {
        grayTabView.translatesAutoresizingMaskIntoConstraints = false
        grayTabWeatherCenterXConstraint = NSLayoutConstraint(item: weatherButton, attribute: .centerX, relatedBy: .equal, toItem: grayTabView, attribute: .centerX, multiplier: 1, constant: 0)
        grayTabNewsCenterXConstraint = NSLayoutConstraint(item: newsButton, attribute: .centerX, relatedBy: .equal, toItem: grayTabView, attribute: .centerX, multiplier: 1, constant: 0)
        grayTabPhotosCenterXConstraint = NSLayoutConstraint(item: photosButton, attribute: .centerX, relatedBy: .equal, toItem: grayTabView, attribute: .centerX, multiplier: 1, constant: 0)
        
        if persistentSelectedListType == .weather {
            grayTabWeatherCenterXConstraint.isActive = true
        } else if  persistentSelectedListType == .news {
            grayTabNewsCenterXConstraint.isActive = true
        } else {
            grayTabPhotosCenterXConstraint.isActive = true
        }
    }
    
    @IBAction func tapOnWeatherButton(_ sender: UIButton) {
        updateHeader(view: .weather, animated: true)
    }
    
    @IBAction func tapOnNewsButton(_ sender: UIButton) {
        updateHeader(view: .news, animated: true)
    }
    
    @IBAction func tapOnPhotosButton(_ sender: UIButton) {
        updateHeader(view: .photos, animated: true)
    }
    
    func updateHeader(view: SelectedList, animated: Bool) {
        if view == .weather {
            grayTabWeatherCenterXConstraint.isActive = true
            grayTabNewsCenterXConstraint.isActive = false
            grayTabPhotosCenterXConstraint.isActive = false
            
            if animated {
                UIView.animate(withDuration: 0.1) {
                    self.layoutIfNeeded()
                }
            }
        } else if view == .news {
            grayTabWeatherCenterXConstraint.isActive = false
            grayTabNewsCenterXConstraint.isActive = true
            grayTabPhotosCenterXConstraint.isActive = false
            if animated {
                UIView.animate(withDuration: 0.1) {
                    self.layoutIfNeeded()
                }
            }
        } else {
            grayTabWeatherCenterXConstraint.isActive = false
            grayTabNewsCenterXConstraint.isActive = false
            grayTabPhotosCenterXConstraint.isActive = true
            if animated {
                UIView.animate(withDuration: 0.1) {
                    self.layoutIfNeeded()
                }
            }
        }
        persistentSelectedListType = view
    }
    
}
