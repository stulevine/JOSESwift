//: A UIKit based Playground for presenting user interface
  
import UIKit
import Foundation
import PlaygroundSupport
import JOSESwift

class MyViewController : UIViewController {
    var enc: String = ""
    let newView = UIView()
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello World!"
        label.textAlignment = .center
        label.textColor = .black
        self.view.addSubview(label)
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        self.view.addSubview(self.button)
        self.button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 25).isActive = true
        self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        return label
    }()

    lazy var button: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.setTitle("Decrypt", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(decrypt(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true

        return button
    }()

    let key = Data(base64Encoded: "9pR0S35yYqRJyV+TJE3Tc+KC9T/Z83eL40fkQqDfWPs+BOW3/96LXoe5rnPpzW11lVWjEppLGF6TEKFmtN+DZg==")//try? SecureRandom.generate(count: 64)

    @objc
    func decrypt(_ sender: UIButton) {
        let e = "eyJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiYWxnIjoiZGlyIn0..m12Xi5lnqG-2N7xUDdTbNg.iDps8v-kvs3JhKBRJ8Ai9ktzF85_2Fd5gMh6nVXOFRyO8khMu73EhWQEk57pb3os.jieqcZxH9FRU0TnVR9D-GVrFow4voli--WLzExjtb-Y"
        if
            let decrypter = Decrypter(keyDecryptionAlgorithm: .direct,
                                      decryptionKey: key!,
                                      contentDecryptionAlgorithm: .A256CBCHS512),
            let dec = try? JWE(compactSerialization: e).decrypt(using: decrypter).data() {
            label.text = String(data: dec, encoding: .utf8)
        }
    }

    override func loadView() {

        self.view = newView
        view.backgroundColor = .white

        let encrypter = Encrypter(keyEncryptionAlgorithm: .direct,
                                  encryptionKey: key!, contentEncyptionAlgorithm: SymmetricKeyAlgorithm.A256CBCHS512)!
        let header = JWEHeader(algorithm: .direct,
                               encryptionAlgorithm: .A256CBCHS512)
        let payload = Payload("I am clear as day test.".data(using: .utf8)!)
        let jwe = try? JWE(header: header,
                           payload: payload,
                           encrypter: encrypter)
        enc = jwe?.compactSerializedString ?? "error"
        label.text = enc
        print(key?.base64EncodedString())
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
