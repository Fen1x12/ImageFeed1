import UIKit
import Foundation

enum Constants {
    static let accessKey = "zlMhopfcl25fMY7_ur-5gBtR8C-JeMFnOCfrXS_FUmk"
    static let secretKey = "iW-WFbqJTqLXWQVk5PSynfJOAXtCqFU3A4GadNO1_Mo"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static var defaultBaseURL: URL {
        guard let url = URL(string: "https://api.unsplash.com") else {
            preconditionFailure("Не удалось получить доступ к unsplash.com")
        }
        return url
    }
}
