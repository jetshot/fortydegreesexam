//
//  RestApiManager.swift
//  fortydegreesexam
//
//  Created by Collabera on 4/26/22.
//

import Foundation
import MobileCoreServices
import SwiftyJSON
import Alamofire
typealias ServiceResponseOld = (JSON, NSError?) -> Void
typealias ServiceResponseOld2 = (String, NSError?) -> Void


class RestApiManager: NSObject {

    static let shared = RestApiManager();
    let session = URLSession(configuration: URLSessionConfiguration.default)
    var searchTask: URLSessionDataTask!

    func httpRequest(url: String, method: String, data: [String:Any], onCompletion: @escaping ServiceResponseOld) {
        let site_url = url;
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type":"application/json"
        ]


        AF.request(site_url, method: .get, parameters: data, headers: headers)
            .responseJSON { response in
                guard let responseData = response.data else { return }
                if let data = try? JSON(data: responseData) {
                    DispatchQueue.global(qos: .background).async {
                        DispatchQueue.main.async {
                            onCompletion(data, response.error as NSError?)
                        }
                    }
                }
            }
    }

    func getCountries(data: [String:String], onCompletion: @escaping (JSON) -> Void) {
        httpRequest(url: "https://restcountries.com/v3.1/all", method: "GET", data: data, onCompletion: { json, err in
            onCompletion(json)
        });
    }


}
private func mimeType(for path: String) -> String {
    let pathExtension = URL(fileURLWithPath: path).pathExtension as NSString

    guard
        let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, nil)?.takeRetainedValue(),
        let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue()
    else {
        return "application/octet-stream"
    }

    return mimetype as String
}

extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
