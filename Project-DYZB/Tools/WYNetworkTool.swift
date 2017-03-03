//
//  WYNetworkTool.swift
//  AlamofireTest
//
//  Created by liweiyou on 17/3/1.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit
import Alamofire
enum WYMethodType : String {
    case OPTIONS = "OPTIONS"
    case GET     = "GET"
    case HEAD    = "HEAD"
    case POST    = "POST"
    case PUT     = "PUT"
    case PATCH   = "PATCH"
    case DELETE  = "DELETE"
    case TRACE   = "TRACE"
    case CONNECT = "CONNECT"
    
}
class WYNetworkTool {
    
    class func requestData(type : WYMethodType,urlString : String, parameters : [String : Any]? = nil, finishCallBack : @escaping  (_ responeCallBack :
        AnyObject)->()) {//_ 不想要外部参数可以在参数名称之前加_ 因为函数默认所有的参数既是外部参数 也是内部参数 在函数调用的时候能看到的参数就是外部参数 在函数内部可以看到的参数是内部参数
        /**
         @escaping 逃逸闭包
         逃逸的闭包常用于异步的操作，这类函数会在异步操作开始之后立刻返回，但是闭包直到异步操作结束后才会被调用。例如这个闭包是异步处理一个网络请求，只有当请求结束后，闭包的生命周期才结束。当闭包作为函数的参数传入时，很有可能这个闭包在函数返回之后才会被执行。
         */
        
        //1.获取类型
        let method = WYNetworkTool.getHTTPMethod(type: type)
        
        Alamofire.request(urlString, method: method , parameters: parameters).responseJSON { (respone) in
            guard let result = respone.result.value else {
                print(respone.result.error ?? "")
                return
            }
            
            finishCallBack(result as AnyObject)
            
        }
        
        
        
        
        
        
//        let header = ["Content-Type" : "application/json"]
        
//        let parameters = ["name":"lwy"]
//        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header)
//            .responseJSON { response in
//                guard response.result.error == nil else {
//                    print(response.result.error!)
//                    return
//                }
//        }
//        
//        let headers: HTTPHeaders = [
//            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
//            "Accept": "application/json"
//        ]
//        Alamofire.request(urlString, method : .post , parameters : parameters, encoding: JSONEncoding.default ,  headers: headers).responseJSON { response in
//            
//        }
        
        
        
        
    }
}
//private let urlString = "https://httpbin.org/get"
// MARK:- 获得请求类型
extension WYNetworkTool {
    fileprivate class func getHTTPMethod(type : WYMethodType) -> HTTPMethod {
        
        let methodDict = [WYMethodType.GET : HTTPMethod.get ,
                          WYMethodType.POST : HTTPMethod.post,
                          WYMethodType.OPTIONS : HTTPMethod.options,
                          WYMethodType.HEAD : HTTPMethod.head,
                          WYMethodType.PUT : HTTPMethod.put,
                          WYMethodType.PATCH : HTTPMethod.patch,
                          WYMethodType.DELETE : HTTPMethod.delete,
                          WYMethodType.TRACE : HTTPMethod.trace,
                          WYMethodType.CONNECT : HTTPMethod.connect]
        
        let method = methodDict[type]
        return method!
    }
}


/*********************Alamofire 用法示例****************************************/
extension WYNetworkTool {
    private func example() {
        Alamofire.request("https://httpbin.org/get").responseJSON { response in
            print(response.request ?? "")  // original URL request
            print(response.response ?? "") // HTTP URL response
            print(response.data ?? "")     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }
  
    private func responeExample() {
        Alamofire.request("https://httpbin.org/get").response { response in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Error: \(response.error)")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
        }
    }
    
    private func dataExample () {
        Alamofire.request("https://httpbin.org/get").responseData { response in
            debugPrint("All Response Info: \(response)")
            
            if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
        }
    }
    
    private func stringExample (){
        Alamofire.request("https://httpbin.org/get").responseString { response in
            print("Success: \(response.result.isSuccess)")
            print("Response String: \(response.result.value)")
        }
    }
    
    
    
    private func queueExample (){
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        Alamofire.request("https://httpbin.org/get").responseJSON(queue: utilityQueue) { response in
            print("Executing response handler on utility queue")
        }
    }
    
    // MARK:- get请求 带参数
    private func getExample (){
        let parameters: Parameters = ["foo": "bar"]
        
        // All three of these calls are equivalent
        Alamofire.request("https://httpbin.org/get", parameters: parameters).responseJSON { (DataResponse) in
            
        }
        // encoding defaults to `URLEncoding.default`
//        Alamofire.request("https://httpbin.org/get", parameters: parameters, encoding: URLEncoding.default)
//        Alamofire.request("https://httpbin.org/get", parameters: parameters, encoding: URLEncoding(destination: .methodDependent))
        
        // https://httpbin.org/get?foo=bar
    }
    
    
    // MARK:- POST请求 带参数
    private func postExample (){
        let parameters: Parameters = [
            "foo": "bar",
            "baz": ["a", 1],
            "qux": [
                "x": 1,
                "y": 2,
                "z": 3
            ]
        ]
        
        // All three of these calls are equivalent
        Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters).responseJSON { (respone) in
            
        }
//        Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: URLEncoding.default)
//        Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: URLEncoding.httpBody)

    }
    // MARK:- POST Request with JSON-Encoded Parameters
    private func jsonEncoderExample (){
        let parameters: Parameters = [
            "foo": [1,2,3],
            "bar": [
                "baz": "qux"
            ]
        ]
        
        // Both calls are equivalent
        Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (respone) in
            
        }
//        Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: JSONEncoding(options: []))
        
        // HTTP body: {"foo": [1, 2, 3], "bar": {"baz": "qux"}}
    }
    // MARK:- 下载文件
    private func downloadExample (){
        Alamofire.download("https://httpbin.org/image/png").responseData { response in
//            if let data = response.result.value {
////                let image = UIImage(data: data)
//            }
        }
    }
    // MARK:- 下载文件 自定义下载路径
    private func downloadDestinationExample (){
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            let fileURL = documentsURL.appendingPathComponent("pig.png")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let urlString = "https://httpbin.org/get"
        Alamofire.download(urlString, to: destination).response { response in
            print(response)
            
//            if response.error == nil, let imagePath = response.destinationURL?.path {
////                let image = UIImage(contentsOfFile: imagePath)
//            }
        }
        
        //or
//        let destination = DownloadRequest.suggestedDownloadDestination(directory: .documentDirectory)
//        Alamofire.download("https://httpbin.org/image/png", to: destination)
        
    }
    // MARK:- 下载进度
    private func downloadProgress() {
        Alamofire.download("https://httpbin.org/image/png")
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .responseData { response in
//                if let data = response.result.value {
//                    let image = UIImage(data: data)
//                }
        }
    }
    // MARK:- 下载进度 传queue参数
    private func downloadProgressWithQueue() {
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        Alamofire.download("https://httpbin.org/image/png")
            .downloadProgress(queue: utilityQueue) { progress in
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .responseData { response in
//                if let data = response.result.value {
////                    let image = UIImage(data: data)
//                }
        }
    }
    // MARK:- 重新下载 Resuming a Download
    private func resumeDownload() {
//        private var resumeData: Data?
//        private var image: UIImage?
//        
//        func fetchImage(completion: (UIImage?) -> Void) {
//            guard image == nil else { completion(image) ; return }
//            
//            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
//                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                let fileURL = documentsURL.appendPathComponent("pig.png")
//                
//                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//            }
//            
//            let request: DownloadRequest
//            
//            if let resumeData = resumeData {
//                request = Alamofire.download(resumingWith: resumeData)
//            } else {
//                request = Alamofire.download("https://httpbin.org/image/png")
//            }
//            
//            request.responseData { response in
//                switch response.result {
//                case .success(let data):
//                    self.image = UIImage(data: data)
//                case .failure:
//                    self.resumeData = response.resumeData
//                }
//            }
//        }
    }
    
    
    // MARK:- 上传数据 Uploading Data
    private func uploadingData() {
        let image : UIImage = UIImage.init(named: "")!
        let imageData = UIImagePNGRepresentation(image)!
        
        Alamofire.upload(imageData, to: "https://httpbin.org/post").responseJSON { response in
            debugPrint(response)
        }
    }
    // MARK:- 上传文件 Uploading a File
    private func uploadingFile() {
        let fileURL = Bundle.main.url(forResource: "video", withExtension: "mov")
        
        Alamofire.upload(fileURL!, to: "https://httpbin.org/post").responseJSON { response in
            debugPrint(response)
        }
    }
    // MARK:- Uploading Multipart Form Data
    private func uploadMultipartData() {
//        Alamofire.upload(
//            multipartFormData: { multipartFormData in
//                multipartFormData.append(unicornImageURL, withName: "unicorn")
//                multipartFormData.append(rainbowImageURL, withName: "rainbow")
//        },
//            to: "https://httpbin.org/post",
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                        debugPrint(response)
//                    }
//                case .failure(let encodingError):
//                    print(encodingError)
//                }
//        }
//        )
    }
    
    
    private func uploadProgress(){
        let fileURL = Bundle.main.url(forResource: "video", withExtension: "mov")
        
        Alamofire.upload(fileURL!, to: "https://httpbin.org/post")
            .uploadProgress { progress in // main queue by default
                print("Upload Progress: \(progress.fractionCompleted)")
            }
            .downloadProgress { progress in // main queue by default
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .responseJSON { response in
                debugPrint(response)
        }
    }
    
}
