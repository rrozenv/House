
import Foundation
import RxSwift
import RxCocoa

protocol UserDetailsViewModelInputs {
    var viewDidLoadInput: AnyObserver<Void> { get }
    var firstNameTextInput: AnyObserver<String> { get }
    var lastNameTextInput:  AnyObserver<String> { get }
    var nextButtonTappedInput:  AnyObserver<Void> { get }
}

protocol UserDetailsViewModelOuputs {
    var inputIsValid: Driver<Bool> { get }
    var mainText: Driver<(header: String, body: String)> { get }
}

protocol UserDetailsViewModelType {
    var inputs: UserDetailsViewModelInputs { get }
    var outputs: UserDetailsViewModelOuputs { get }
}

final class UserDetailsViewModel: UserDetailsViewModelType, UserDetailsViewModelInputs, UserDetailsViewModelOuputs {

    let disposeBag = DisposeBag()
    
    var inputs: UserDetailsViewModelInputs { return self }
    let viewDidLoadInput: AnyObserver<Void>
    let firstNameTextInput: AnyObserver<String>
    let lastNameTextInput:  AnyObserver<String>
    let nextButtonTappedInput:  AnyObserver<Void>
    
    var outputs: UserDetailsViewModelOuputs { return self }
    let inputIsValid: Driver<Bool>
    let mainText: Driver<(header: String, body: String)>
    
    init(router: SignUpFlowCoordinator) {
        
        //MARK: - Subjects
        let _viewDidLoadInput = PublishSubject<Void>()
        let _firstNameTextInput = PublishSubject<String>()
        let _lastNameTextInput = PublishSubject<String>()
        let _nextButtonTappedInput = PublishSubject<Void>()
        
        //MARK: - Observers
        self.viewDidLoadInput = _viewDidLoadInput.asObserver()
        self.firstNameTextInput = _firstNameTextInput.asObserver()
        self.lastNameTextInput = _lastNameTextInput.asObserver()
        self.nextButtonTappedInput = _nextButtonTappedInput.asObserver()
        
        //MARK: - Observables
        let viewDidLoadObservable = _viewDidLoadInput.asObservable()
        let firstNameObservable = _firstNameTextInput.asObservable().startWith("")
        let lastNameObservable = _lastNameTextInput.asObservable().startWith("")
        let nextTappedObservable = _nextButtonTappedInput.asObservable()
        let fullNameObservable = Observable.combineLatest(firstNameObservable, lastNameObservable) { (first: $0, last: $1) }
        
        //MARK: - Outputs
        let header = "What’s your full name?"
        let body = "You will always be in charge of who to share your identitiy with."
        self.mainText = viewDidLoadObservable
            .map { _ in (header: header, body: body) }
            .asDriver(onErrorJustReturn: (header: "", body: ""))
        
        self.inputIsValid = Observable
            .combineLatest(firstNameObservable,
                           lastNameObservable,
                           resultSelector: { $0.count > 0 && $1.count > 0 })
            .asDriver(onErrorJustReturn: false)
        
        //MARK: - Routing
        nextTappedObservable
            .withLatestFrom(fullNameObservable)
            .map { $0.first + " " + $0.last }
            .do(onNext: { router.didSaveName($0) })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
}
