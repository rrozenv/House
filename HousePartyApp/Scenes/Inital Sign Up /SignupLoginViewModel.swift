
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
    var welcomeText: Driver<(header: String, body: String)> { get }
}

protocol SignupLoginViewModelType {
    var inputs: SignupLoginViewModelInputs { get }
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
    let welcomeText: Driver<(header: String, body: String)>
    
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
        let headerText = "Welcome to Outpost!"
        let bodyText = "The year is 2075…You are the commander of an outpost on an alien planet. Do you have what it takes to build a thriving democracy?"
        self.welcomeText = Driver.of((header: headerText, body: bodyText))
        
        router.didFinishSignup
            .map {
                User(fullName: $0.fullName!,
                     birthDate: "TesDate",
                     phoneNumber: $0.phoneNumber!)
            }
            .flatMapLatest { userService.create(user: $0) }
            .do(onNext: { (newUser) in
                AppController.shared.currentUser = newUser
                NotificationCenter.default
                    .post(name: Notification.Name.createHomeVc, object: nil)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
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
