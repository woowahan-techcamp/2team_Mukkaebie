//
//  NetworkImagePicker.swift
//  Mukkaebie
//
//  Created by woowabrothers on 2017. 8. 22..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import Foundation
import Alamofire

class NetworkImagePicker {
    
    private let url = URLpath.getURL()
    private let urlImage = URLpath.getURLImage()
    
    func postImage(storeId: Int, userId: String, imgData: Data) {
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imgData, withName: "profileImage", fileName: userId+".jpg", mimeType: "image/jpeg")
        }, to:"\(urlImage)profile/")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let JSON = response.result.value {
                        let parameters = ["storeId": storeId, "mkb": ["userId": userId, "mkbPicUrl": "\(self.urlImage)uploads/" + ((JSON as! [String : Any])["filename"] as! String)]] as [String : Any]
                        Alamofire.request("\(self.url)stores/mkb/"+"\(storeId)", method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default)
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
            
        }
    }
}