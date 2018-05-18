
import Foundation
import RxSwift
import RxCocoa
import RxOptional

protocol SignupLoginViewModelInputs {
    var viewDidLoadInput: AnyObserver<Void> { get }
    var signupButtonTappedInput: AnyObserver<Void> { get }
    var loginButtonTappedInput: AnyObserver<Void> { get }
    var learnMoreTappedInput: AnyObserver<Void> { get }
    var quickLoginTappedInput: AnyObserver<Void> { get }
}

protocol SignupLoginViewModelOutputs {
    var welcomeText: Driver<(header: FontMixer, body: String)> { get }
}

protocol SignupLoginViewModelType {
    var inputs: SignupLoginViewModelInputs { get }
}

struct FontMixer {
    let originalText: String
    let fontDict: [String: UIFont]
}

final class SignupLoginViewModel: SignupLoginViewModelType, SignupLoginViewModelInputs, SignupLoginViewModelOutputs {
    
    let disposeBag = DisposeBag()
    
//MARK: - Inputs
    var inputs: SignupLoginViewModelInputs { return self }
    let viewDidLoadInput: AnyObserver<Void>
    let signupButtonTappedInput: AnyObserver<Void>
    let loginButtonTappedInput: AnyObserver<Void>
    let learnMoreTappedInput: AnyObserver<Void>
    let quickLoginTappedInput: AnyObserver<Void>

//MARK: - Outputs
    var outputs: SignupLoginViewModelOutputs { return self }
    let welcomeText: Driver<(header: FontMixer, body: String)>
    
//MARK: - Init
    init(router: SignUpFlowCoordinator, userService: UserService = UserService()) {
    
//MARK: - Subjects
        let _viewDidLoadInput = PublishSubject<Void>()
        let _signupTappedInput = PublishSubject<Void>()
        let _loginTappedInput = PublishSubject<Void>()
        let _learnMoreTappedInput = PublishSubject<Void>()
        let _quickLoginTappedInput = PublishSubject<Void>()
        
//MARK: - Observers
        self.viewDidLoadInput = _viewDidLoadInput.asObserver()
        self.loginButtonTappedInput = _loginTappedInput.asObserver()
        self.signupButtonTappedInput = _signupTappedInput.asObserver()
        self.learnMoreTappedInput = _learnMoreTappedInput.asObserver()
        self.quickLoginTappedInput = _quickLoginTappedInput.asObserver()
        
//MARK: - Outputs
        let headerTextDict: [String: UIFont] = [
            "Ready to": FontBook.AvenirMedium.of(size: 14),
            "PARTY?": FontBook.AvenirBlack.of(size: 18),
        ]
        let bodyText = "You will bring your friends. \n She will bring her friends. \n We will plan the time & place for you. \n Ready to party?"
        let headerText = FontMixer(originalText: "Ready to PARTY?",
                                   fontDict: headerTextDict)
        self.welcomeText = Driver.of((header: headerText, body: bodyText))
        
//MARK: - Routing
        _signupTappedInput.asObservable()
            .do(onNext: router.toUserDetails)
            .subscribe()
            .disposed(by: disposeBag)
        
        _learnMoreTappedInput.asObservable()
            .do(onNext: router.toOnboardingFlow)
            .subscribe()
            .disposed(by: disposeBag)
        
//        _loginTappedInput.asObservable()
//            .do(onNext: router.toLoginFlow)
//            .subscribe()
//            .disposed(by: disposeBag)
        
//        _learnMoreTappedInput.asObservable()
//            .do(onNext: router)
//            .subscribe()
//            .disposed(by: disposeBag)
    }
    
}
