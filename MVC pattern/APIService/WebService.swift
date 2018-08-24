//
//  WebService.swift
//  MVC pattern
//
//  Created by siva prasad on 24/08/18.
//  Copyright © 2018 SIVA PRASAD. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WebService{
    class func requestGETURL(_ strURL: String, success:@escaping (Data) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(strURL).responseJSON { (responseObject) -> Void in
            
//            print(responseObject)
            
            if responseObject.result.isSuccess {
                let resJson = responseObject.data
                success(resJson!)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }

}
