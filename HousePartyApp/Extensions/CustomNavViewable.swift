//
//  CustomNavViewable.swift
//  DesignatedHitter
//
//  Created by Robert Rozenvasser on 4/20/18.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import Foundation
import UIKit

protocol CustomNavBarViewable: class {
    associatedtype View: UIView
    var navView: View { get set }
    var navBackgroundView: UIView { get set }
    func setupNavBar()
}

extension CustomNavBarViewable where Self: UIViewController {
    
    func setupNavBar() {
        self.navigationController?.isNavigationBarHidden = true
        setupNavView()
        setupNavBarBackgroundView()
    }
    
    private func setupNavView() {
        view.addSubview(navView)
        navView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(Constants.CUSTOM_NAV_HEIGHT)
            make.topEqualTo(view)
        }
    }
    
    private func setupNavBarBackgroundView() {
        view.insertSubview(navBackgroundView, belowSubview: navView)
        navBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.bottom.equalTo(navView.snp.bottom)
        }
    }
    
}

//final class GameViewModel {
//
//    private let disposeBag = DisposeBag()
//    let scoreKeeper: ScoreKeeperType
//    let playOptions: Driver<[PlayResult]>
//
//    private var gameVar: Game
//    var game: Observable<Game> {
//        return Observable.from(object: gameVar)
//            .do(onNext: { [unowned self] in self.gameVar = $0 })
//
//    }
//
//    let gameService: GameService
//
//    init(game: Game,
//         scoreKeeper: ScoreKeeperType,
//         gameService: GameService = GameService()) {
//        self.gameService = gameService
//        self.gameVar = game
//        self.playOptions = Driver.of(PlayResult.list)
//        self.scoreKeeper = scoreKeeper
//        gameService.initalizeFirstInningHalfFor(game: game, isHomeTeamBatting: true, scoreKeeper: scoreKeeper)
//    }
//
//    func playSelected(_ result: PlayResult) {
//        let play = Play(type: result.rawValue,
//                        fielder: nil,
//                        batter: gameVar.currentBatterFor(scoreKeeper),
//                        pitcher: gameVar.currentPitcherFor(scoreKeeper))
//        gameService.addLatestPlayFor(game: gameVar,
//                                     play: play,
//                                     nextBatterIndex: gameVar.currentBatterIndexFor(scoreKeeper),
//                                     scoreKeeper: scoreKeeper)
//    }
//
//    func atBatCompleted(_ result: AtBatResult) {
//        let play = Play(type: result.rawValue,
//                        fielder: nil,
//                        batter: gameVar.currentBatterFor(scoreKeeper),
//                        pitcher: gameVar.currentPitcherFor(scoreKeeper))
//        gameService.addLatestPlayFor(game: gameVar,
//                                     play: play,
//                                     nextBatterIndex: gameVar.nextUpBatterIndex(scoreKeeper),
//                                     scoreKeeper: scoreKeeper)
//    }
//
//    func createNextInningHalf() {
//        let wasHomeTeamBatting = gameVar.isHomeTeamBatting(scoreKeeper)
//        let nextInningHalf = InningHalf(isHomeTeamBatting: !wasHomeTeamBatting,
//                                        atBats: [AtBat()])
//        gameService.createNextInningHalfFor(game: gameVar,
//                                            inningHalf: nextInningHalf,
//                                            scoreKeeper: scoreKeeper)
//    }
//
//}

