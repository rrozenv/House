
import Foundation
import UIKit
import RxSwift
import RxCocoa

final class SignupLoginViewController: UIViewController, BindableType {
    
    let disposeBag = DisposeBag()
    var viewModel: SignupLoginViewModel!
    private var headerLabel: UILabel!
    private var bodyLabel: UILabel!
    private var dividerView: UIView!
    private var labelsStackView: UIStackView!
    private var learnMoreButton: UIButton!
    private var signupButton: UIButton!
    private var learnMore: UIButton!
    private var quickLoginButton: UIButton!
    private var onboardingView: OnboardingView!
    private let widthMultiplier = 0.74
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.white
        setupLearnMoreButton()
        setupOnboardingView()
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit { print("Signup Login deinit") }
    
    func bindViewModel() {
        //MARK: - Inputs
        onboardingView.button(at: 0).rx.tap.asObservable()
            .bind(to: viewModel.inputs.learnMoreTappedInput)
            .disposed(by: disposeBag)
        
//        onboardingView.button(at: 1).rx.tap.asObservable()
//            .bind(to: viewModel.inputs.signupButtonTappedInput)
//            .disposed(by: disposeBag)
        
        learnMore.rx.tap.asObservable()
            .bind(to: viewModel.inputs.loginButtonTappedInput)
            .disposed(by: disposeBag)
        
        viewModel.outputs.welcomeText
            .drive(onNext: { [weak self] in
                self?.onboardingView.headerLabel
                    .varyingFonts(originalText: $0.header.originalText,
                                  fontDict: $0.header.fontDict,
                                  fontColor: .black)
                self?.onboardingView.bodyLabel.text = $0.body
            })
            .disposed(by: disposeBag)
    }
    
    private func setupLearnMoreButton() {
        learnMore = UIButton()
        learnMore.backgroundColor = UIColor.clear
        learnMore.titleLabel?.font = FontBook.AvenirMedium.of(size: 13)
        learnMore.setTitle("Learn More", for: .normal)
        learnMore.setTitleColor(Palette.lightGrey.color, for: .normal)
        
        view.addSubview(learnMore)
        learnMore.snp.makeConstraints { (make) in
            make.width.equalTo(view).multipliedBy(widthMultiplier)
            make.centerX.equalTo(view)
            make.height.equalTo(40)
            make.bottom.equalTo(view.snp.bottom).offset(-100)
        }
    }
    
    private func setupOnboardingView() {
        onboardingView = OnboardingView(numberOfButtons: 1)
        onboardingView.headerLabel.style(font: FontBook.AvenirBlack.of(size: 14),
                                         color: .black)
        
        onboardingView.bodyLabel.style(font: FontBook.AvenirMedium.of(size: 17),
                                       color: Palette.lightGrey.color,
                                       alignment: .left)
        
        onboardingView.button(at: 0).style(title: "Submit my application",
                                           font: FontBook.AvenirHeavy.of(size: 14),
                                           backColor: Palette.brightYellow.color,
                                           titleColor: Palette.darkYellow.color)
        
        //onboardingView.bodyLabel.isHidden = true
        onboardingView.dividerView.isHidden = true
        
        view.addSubview(onboardingView)
        onboardingView.snp.makeConstraints { (make) in
            make.width.equalTo(view).multipliedBy(widthMultiplier)
            make.centerX.equalTo(view)
            make.bottom.equalTo(learnMore.snp.top).offset(-18)
        }
    }
    
}

