//
//  RequestFunc.swift
//  ManMan
//
//  Created by Apple on 2019/3/28.
//  Copyright © 2019年 Mavismwt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RequestFunction {
    
    let URLStr = "https://slow.hustonline.net/api/v1"
    var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTQwMDA4MTgsImlkIjoib3ExNVU1OTdLTVNlNTV2d21aLUN3ZDZkSDFNMCIsIm9yaWdfaWF0IjoxNTUzMzk2MDE4fQ.m_mjQURafkbSVKGCeuRn79dTY7Gbb0uYmdot1-w_Lek"
    //let token = UserDefaults.standard.value(forKey: "token")
    var userInfo = JSON()
    var record = JSON()
    var flag = JSON()
    var routine = JSON()
    
    
    private func getToken(code: String){
        let urlStr = "\(URLStr)/user/login"
        var token = String()
        Alamofire.request(urlStr,method: .post,parameters:["code": code]).responseJSON { response in
            response.result.ifSuccess {
                let value = response.result.value
                let json = JSON(value)
                self.token = json["token"].string!
                }
                .ifFailure {
                    print("Cannot get Token")
            }
        }
    }
    
    func getUserInfo(token: String){
        let urlStr = "\(URLStr)/user"
        let headers:HTTPHeaders = ["auth": "Bearer \(token)"]
        Alamofire.request(urlStr, method: .get, encoding: URLEncoding.default,headers: headers).responseJSON { response in
            response.result.ifSuccess {
                self.userInfo = JSON(response.result.value)
                }
                .ifFailure {
                    print("Cannot get UserInfo")
            }
            let value = JSON(response.result.value)
            let info = value.dictionaryObject
            UserDefaults.standard.set(info, forKey: "info")
            
        }
    }
    
    func getRecord(token: String) {
        let urlStr = "\(URLStr)/record"
        let headers:HTTPHeaders = ["auth": "Bearer \(token)"]
        Alamofire.request(urlStr, method: .get, encoding: URLEncoding.default,headers: headers).responseJSON { response in
            response.result.ifSuccess {
                self.record = JSON(response.result.value)
                }
                .ifFailure {
                    print("Cannot get Record")
            }
        }
    }
    
    private func getFlag(token: String) {
        let urlStr = "\(URLStr)/flag"
        let headers:HTTPHeaders = ["auth": "Bearer \(token)"]
        Alamofire.request(urlStr, method: .get, encoding: URLEncoding.default,headers: headers).responseJSON { response in
            response.result.ifSuccess {
                self.flag = JSON(response.result.value)
                }
                .ifFailure {
                    print("Cannot get Flag")
            }
        }
    }
    
    func getRoutine(token: String) {
        let urlStr = "\(URLStr)/flag"
        let headers:HTTPHeaders = ["auth": "Bearer \(token)"]
        Alamofire.request(urlStr, method: .get, encoding: URLEncoding.default,headers: headers).responseJSON { response in
            response.result.ifSuccess {
                self.routine = JSON(response.result.value)
                }
                .ifFailure {
                    print("Cannot get Routine")
            }
        }
    }
    
    func postRecord(content:String, token: String) {
        let record = "{\"id\":\"\",\"time\":0,\"content\":\"\(content)\"}"
        let recordData = record.data(using: String.Encoding.utf8)
        
        let urlStr = "\(URLStr)/record"
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "auth")
        request.httpBody = recordData
        
        Alamofire.request(request).responseJSON { response in
            response.result.ifSuccess {
                print(response)
                }
                .ifFailure {
                    print("Cannot Post Record")
            }
        }
    }
    
    func putRecord(id:String, token: String) {
        let record = "{\"id\":\"\(id)\",\"time\":0,\"content\":\"\"}"
        let recordData = record.data(using: String.Encoding.utf8)
        
        let urlStr = "\(URLStr)/record"
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "auth")
        request.httpBody = recordData
        
        Alamofire.request(request).responseJSON { response in
            response.result.ifSuccess {
                print(response)
                }
                .ifFailure {
                    print("Cannot Put Record")
            }
        }
    }
    
    func deleteRecord(id:String, token: String) {
        let record = "{\"id\":\"\(id)\",\"time\":0,\"content\":\"\"}"
        let recordData = record.data(using: String.Encoding.utf8)
        
        let urlStr = "\(URLStr)/record"
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "auth")
        request.httpBody = recordData
        
        Alamofire.request(request).responseJSON { response in
            response.result.ifSuccess {
                print(response)
                }
                .ifFailure {
                    print("Cannot Delete Record")
            }
        }
    }
    
    func postFlag(content:String, token: String) {
        let flag = "{\"id\":\"\",\"time\":0,\"content\":\"\(content)\",\"likes\":[],\"comments\":[],\"sign_in\":0}"
        let flagData = flag.data(using: String.Encoding.utf8)
        
        let urlStr = "\(URLStr)/flag"
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "auth")
        request.httpBody = flagData
        
        Alamofire.request(request).responseJSON { response in
            response.result.ifSuccess {
                print(response)
                }
                .ifFailure {
                    print("Cannot Post Flag")
            }
        }
    }
    
    func deleteFlag(id:String, token: String) {
        let flag = "{\"id\":\"\(id)\",\"time\":0,\"content\":\"\",\"likes\":[],\"comments\":[],\"sign_in\":0}"
        let flagData = flag.data(using: String.Encoding.utf8)
        
        let urlStr = "\(URLStr)/flag"
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "auth")
        request.httpBody = flagData
        
        Alamofire.request(request).responseJSON { response in
            response.result.ifSuccess {
                print(response)
                }
                .ifFailure {
                    print("Cannot Delete Flag")
            }
        }
    }
    
    func putFlag(id:String, content:String, token: String) {
        let flag = "{\"id\":\"\(id)\",\"time\":0,\"content\":\"\(content)\",\"likes\":[],\"comments\":[],\"sign_in\":0}"
        let flagData = flag.data(using: String.Encoding.utf8)
        
        let urlStr = "\(URLStr)/flag"
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "auth")
        request.httpBody = flagData
        
        Alamofire.request(request).responseJSON { response in
            response.result.ifSuccess {
                print(response)
                }
                .ifFailure {
                    print("Cannot Put Flag")
            }
        }
    }
    
    func postFlagSign(id: String, token: String) {
        let flag = "{\"id\":\"\(id)\",\"time\":0,\"content\":\"\",\"likes\":[],\"comments\":[],\"sign_in\":0}"
        let flagData = flag.data(using: String.Encoding.utf8)
        
        let urlStr = "\(URLStr)/flag/sign"
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "auth")
        request.httpBody = flagData
        
        Alamofire.request(request).responseJSON { response in
            response.result.ifSuccess {
                print(response)
                }
                .ifFailure {
                    print("Cannot Post Flag Sign")
            }
        }
    }
    
    func postRoutine(title:String, token: String) {
        
        let routine = "{\"id\":\"\",\"time\":0,\"title\":\"\(title)\",\"icon_id\":\"\",\"sign_in\":0}"
        let routineData = routine.data(using: String.Encoding.utf8)
        
        let urlStr = "\(URLStr)/routine"
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "auth")
        request.httpBody = routineData
        
        Alamofire.request(request).responseJSON { response in
            response.result.ifSuccess {
                print(response)
                }
                .ifFailure {
                    print("Cannot Post Flag Sign")
            }
        }
    }
    
    func putRoutine(id:String, token: String) {
        let routine = "{\"id\":\"\(id)\",\"time\":0,\"title\":\"\",\"icon_id\":\"\",\"sign_in\":0}"
        let routineData = routine.data(using: String.Encoding.utf8)
        
        let urlStr = "\(URLStr)/routine"
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "auth")
        request.httpBody = routineData
        
        Alamofire.request(request).responseJSON { response in
            response.result.ifSuccess {
                print(response)
                }
                .ifFailure {
                    print("Cannot Post Flag Sign")
            }
        }
    }
    
    func deleteRoutine(id:String, token: String) {
        let routine = "{\"id\":\"\(id)\",\"time\":0,\"title\":\"\",\"icon_id\":\"\",\"sign_in\":0}"
        let routineData = routine.data(using: String.Encoding.utf8)
        
        let urlStr = "\(URLStr)/routine"
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "auth")
        request.httpBody = routineData
        
        Alamofire.request(request).responseJSON { response in
            response.result.ifSuccess {
                print(response)
                }
                .ifFailure {
                    print("Cannot Post Flag Sign")
            }
        }
    }
    
    func putRoutineSign(id:String, token: String) {
        let routine = "{\"id\":\"\(id)\",\"time\":0,\"title\":\"\",\"icon_id\":\"\",\"sign_in\":0}"
        let routineData = routine.data(using: String.Encoding.utf8)
        
        let urlStr = "\(URLStr)/routine/sign"
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "auth")
        request.httpBody = routineData
        
        Alamofire.request(request).responseJSON { response in
            response.result.ifSuccess {
                print(response)
                }
                .ifFailure {
                    print("Cannot Post Flag Sign")
            }
        }
    }
    
}

extension Date {
    
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : Int64 {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return millisecond
    }
}


