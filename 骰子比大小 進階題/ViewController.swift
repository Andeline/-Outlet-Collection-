//
//  ViewController.swift
//  骰子比大小 進階題
//
//  Created by 蔡佳穎 on 2021/4/29.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var leftDiceImageView: [UIImageView]!
    @IBOutlet var rightDiceImageView: [UIImageView]!
    
    @IBOutlet weak var leftWinImageView: UIImageView!
    @IBOutlet weak var rightWinImageView: UIImageView!
    
    @IBOutlet weak var leftPointLabel: UILabel!
    @IBOutlet weak var rightPointLabel: UILabel!
    @IBOutlet weak var score: UILabel!
    
    @IBOutlet weak var rollBtn: UIButton!
    @IBOutlet weak var playAnotherRoundBtn: UIButton!
    
    //骰子圖片陣列
    let imageViewNames = ["die.face.1.fill", "die.face.2.fill", "die.face.3.fill", "die.face.4.fill", "die.face.5.fill", "die.face.6.fill"]
    
    //用變數儲存分數
    var leftPoint = 0
    var rightPoint = 0
    var leftScore = 0
    var rightScore = 0
    
    //生成播放音樂的AVPlayer物件
    let player = AVPlayer()
    
    //生成產生Money粒子效果的CAEmitterCell物件，及產生CAEmitterLayer
    let moneyEmitterCell = CAEmitterCell()
    let moneyEmitterLayer = CAEmitterLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftWinImageView.isHidden = true
        rightWinImageView.isHidden = true
        playAnotherRoundBtn.isHidden = true
        
    }
    
    func moneyRain() {
        if leftScore > rightScore {
            //設定粒子
            moneyEmitterCell.contents = UIImage(named: "money.png")?.cgImage
            moneyEmitterCell.scale = 0.06
            moneyEmitterCell.scaleRange = 0.03
            moneyEmitterCell.yAcceleration = 40
            moneyEmitterCell.velocity = 120
            moneyEmitterCell.birthRate = 8
            moneyEmitterCell.lifetime = 30
            moneyEmitterCell.spin = 3
            moneyEmitterCell.spinRange = 1
            
            //設定layer
            moneyEmitterLayer.emitterCells = [moneyEmitterCell]
            moneyEmitterLayer.emitterPosition = CGPoint(x: view.bounds.width / 4, y: -70)
            moneyEmitterLayer.emitterSize = CGSize(width: view.bounds.width / 4, height: 0)
            moneyEmitterLayer.emitterShape = .line
            view.layer.addSublayer(moneyEmitterLayer)
        } else {
            //設定粒子
            moneyEmitterCell.contents = UIImage(named: "money.png")?.cgImage
            moneyEmitterCell.scale = 0.06
            moneyEmitterCell.scaleRange = 0.03
            moneyEmitterCell.yAcceleration = 40
            moneyEmitterCell.velocity = 120
            moneyEmitterCell.birthRate = 8
            moneyEmitterCell.lifetime = 30
            moneyEmitterCell.spin = 3
            moneyEmitterCell.spinRange = 1
            
            //設定layer
            moneyEmitterLayer.emitterCells = [moneyEmitterCell]
            moneyEmitterLayer.emitterPosition = CGPoint(x: view.bounds.width / 4 * 3, y: -70)
            moneyEmitterLayer.emitterSize = CGSize(width: view.bounds.width / 4, height: 0)
            moneyEmitterLayer.emitterShape = .line
            view.layer.addSublayer(moneyEmitterLayer)
        }
    }
    
    func rollSoundEffect() {
        let fileUrl = Bundle.main.url(forResource: "diceRoll", withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: fileUrl)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    func yaSoundEffect() {
        let fileUrl = Bundle.main.url(forResource: "Yayyy", withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: fileUrl)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }

    @IBAction func roll(_ sender: UIButton) {
        //骰子亂數
        for i in leftDiceImageView {
            rollSoundEffect()
            let dicePoint = Int.random(in: 1...6)
            i.image = UIImage(systemName: imageViewNames[dicePoint-1])
            leftPoint += dicePoint
            leftPointLabel.text = "\(leftPoint)"
        }
        for i in rightDiceImageView {
            rollSoundEffect()
            let dicePoint = Int.random(in: 1...6)
            i.image = UIImage(systemName: "die.face.\(dicePoint).fill")
            rightPoint += dicePoint
            rightPointLabel.text = "\(rightPoint)"
        }
        //此局哪邊得分，並將point歸零
        if leftPoint >= 30 && leftPoint > rightPoint {
            leftScore += 1
            leftPoint = 0
            rightPoint = 0
        } else if rightPoint >= 30 && rightPoint > leftPoint {
            rightScore += 1
            leftPoint = 0
            rightPoint = 0
        }
        score.text = "\(leftScore) : \(rightScore)"
        
        //哪邊贏，出現贏家圖片及音效
        if leftScore == 3 {
            leftWinImageView.isHidden = false
            rollBtn.isHidden = true
            playAnotherRoundBtn.isHidden = false
            moneyRain()
            yaSoundEffect()
        } else if rightScore == 3 {
            rightWinImageView.isHidden = false
            rollBtn.isHidden = true
            playAnotherRoundBtn.isHidden = false
            moneyRain()
            yaSoundEffect()
        }
     }
    
    @IBAction func playAnotherRound(_ sender: UIButton) {
        
        //歸零
        leftPoint = 0
        rightPoint = 0
        leftScore = 0
        rightScore = 0
        leftPointLabel.text = "\(leftPoint)"
        rightPointLabel.text = "\(rightPoint)"
        score.text = "\(leftScore) : \(rightScore)"
        
        //移除money雨layer
        moneyEmitterLayer.removeFromSuperlayer()
    
        //把贏家桂冠圖＆再玩一次Btn隱藏，Roll出現
        leftWinImageView.isHidden = true
        rightWinImageView.isHidden = true
        playAnotherRoundBtn.isHidden = true
        rollBtn.isHidden = false
    }
}
