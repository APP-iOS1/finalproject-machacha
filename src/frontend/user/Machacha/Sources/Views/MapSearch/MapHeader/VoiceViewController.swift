//
//  VoiceViewController.swift
//  Machacha
//
//  Created by Sue on 2023/02/13.
//

import SwiftUI
import UIKit
import InstantSearchVoiceOverlay


class VoiceViewModel: ObservableObject {
    @Published var final: Bool = false
}


struct VoiceView: UIViewControllerRepresentable {
    @Binding var text: String
    @ObservedObject var voiceViewModel: VoiceViewModel
    
    func makeUIViewController(context: Context) -> VoiceViewController {
        // Return MyViewController instance
        let voiceVC = VoiceViewController(voiceViewModel: voiceViewModel)
        voiceVC.text = $text
        
        return voiceVC
    }
    
    func updateUIViewController(_ uiViewController: VoiceViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
        // SwiftUI의 @State변수, 여기에 @Binding으로 연결되어 있다고 했을 때
        // SwiftUI 뷰에서 값의 변화가 생기면 해당 함수 실행
        print("updated")
    }
    
    //teardown process : notify other objects that the view controller is disappearing
    
}

class VoiceViewController: UIViewController, VoiceOverlayDelegate {
    
    lazy var voiceOverlayController: VoiceOverlayController = {
        let recordableHandler = {
            return SpeechController(locale: Locale(identifier: "ko_KR"))
        }
        return VoiceOverlayController(speechControllerHandler: recordableHandler)
    }()
    
    let button = UIButton()
    let label = UILabel()
    var config = UIButton.Configuration.filled()
    var text: Binding<String>!
    
    var voiceViewModel: VoiceViewModel
    
    init(voiceViewModel: VoiceViewModel) {
            self.voiceViewModel = voiceViewModel
            super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let margins = view.layoutMarginsGuide
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        //        label.text = "Result Text from the Voice Input" // 여기가 검색 결과가 나오는 곳
        //        label.font = UIFont.boldSystemFont(ofSize: 16)
        //        label.lineBreakMode = .byWordWrapping
        //        label.numberOfLines = 0
        //        label.textAlignment = .center
        
        //    button.setTitle("Start using voice", for: .normal)
        //    button.setTitleColor(.white, for: .normal)
        //    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        //    button.backgroundColor = UIColor(red: 255/255.0, green: 64/255.0, blue: 129/255.0, alpha: 1)
        //        button.setImage(UIImage(systemName: "mic"), for: .normal)
        
        config.buttonSize = .large
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.image = UIImage(systemName: "mic")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .large)
        
        button.configuration = config
        
        
        
        //        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(label)
        self.view.addSubview(button)
        
        //        NSLayoutConstraint.activate([
        //            label.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10),
        //            label.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10),
        //            label.topAnchor.constraint(equalTo: margins.topAnchor, constant: 110),
        //        ])
        
        //        NSLayoutConstraint.activate([
        //            button.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10),
        //            button.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10),
        //            button.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: 10),
        //            button.heightAnchor.constraint(equalToConstant: 50),
        //        ])
        
        voiceOverlayController.delegate = self
        
        // If you want to start recording as soon as modal view pops up, change to true
        voiceOverlayController.settings.autoStart = true
        voiceOverlayController.settings.autoStop = true
        voiceOverlayController.settings.showResultScreen = false
        
        //    voiceOverlayController.settings.layout.inputScreen.subtitleBulletList = ["Suggestion1", "Suggestion2"]
        voiceOverlayController.settings.layout.inputScreen.subtitleBulletList = ["명동", "붕어빵"]
        voiceOverlayController.settings.layout.inputScreen.titleListening = "듣고 있습니다..."
        voiceOverlayController.settings.layout.inputScreen.subtitleInitial = "이렇게 말해보세요:"
        voiceOverlayController.settings.layout.inputScreen.titleInProgress = "검색 중..."
        voiceOverlayController.settings.layout.inputScreen.titleError = "잘 듣지 못했어요."
        voiceOverlayController.settings.layout.inputScreen.subtitleError = "다시 시도하려면 마이크를 탭하세요"
        voiceOverlayController.settings.layout.inputScreen.errorHint = "다시 시도"
        
    }
    
    @objc func buttonTapped() {
        // First way to listen to recording through callbacks
        voiceOverlayController.start(on: self, textHandler: { (text, final, extraInfo) in
            print("callback: getting \(String(describing: text))")
            print("callback: is it final? \(String(describing: final))")
            print("final outside if final : \(final)")
            if final {
                print("final inside if final: \(final)")
                self.voiceViewModel.final = true
                // here can process the result to post in a result screen
                Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (_) in
                    let myString = text
                    let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.red ]
                    let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                    
                    self.voiceOverlayController.settings.resultScreenText = myAttrString
                    self.voiceOverlayController.settings.layout.resultScreen.titleProcessed = "BLA BLA"
                })
                
            }
        }, errorHandler: { (error) in
            print("callback: error \(String(describing: error))")
        }, resultScreenHandler: { (text) in
            print("Result Screen: \(text)")
        }
        )
    }
    
    
    // Second way to listen to recording through delegate
    func recording(text: String?, final: Bool?, error: Error?) {
        if let error = error {
            print("delegate: error \(error)")
        }
        
        if error == nil {
            label.text = text
            self.text.wrappedValue = label.text ?? ""
        }
    }
    
    
    
}
