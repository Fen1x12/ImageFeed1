import UIKit

    let AccessKey = "zlMhopfcl25fMY7_ur-5gBtR8C-JeMFnOCfrXS_FUmk"
    let SecretKey = "iW-WFbqJTqLXWQVk5PSynfJOAXtCqFU3A4GadNO1_Mo"
    let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
    let AccessScope = "public+read_user+write_likes"
    var DefaultBaseURL: URL {
        guard let url = URL(string: "https://api.unsplash.com") else {
            preconditionFailure("Не удалось получить доступ к unsplash.com")
        }
        return url
    }
