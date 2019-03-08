//
//  SelectCityController.swift
//  weather2
//
//  Created by 王玉珀 on 2019/3/8.
//  Copyright © 2019 王玉珀. All rights reserved.
//

import UIKit

// 自定义了一个协议——相当于制造了一个工具，待会儿让干活的人使用
protocol SelectCityDelegate {
    func didChangeCiry(city: String)
}

class SelectCityController: UIViewController {
    
    var currentCity = ""
    var delegate:SelectCityDelegate?

    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var cityInput: UITextField!
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func changeCity(_ sender: Any) {
        delegate?.didChangeCiry(city: cityInput.text!)
        
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentCityLabel.text = currentCity
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
