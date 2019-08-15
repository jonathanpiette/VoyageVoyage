//
//  makeATradViewController.swift
//  VoyageVoyage
//
//  Created by Cr3AD on 29/05/2019.
//  Copyright © 2019 Cr3AD. All rights reserved.
//

import UIKit

class TranslationVC: UIViewController  {
    
    // Mark: - IBOutlets

    @IBOutlet weak var translationTableView: UITableView?
    @IBOutlet weak var mainView: UIView?
    @IBOutlet weak var languageInButton: UIButton?
    @IBOutlet weak var languageOutButton: UIButton?
    @IBOutlet weak var inversionButton: UIButton?
    @IBOutlet weak var translateButton: UIButton?
    @IBOutlet weak var textField: UITextField?
    
    // Mark : - IBAction
    
    @IBAction func didTapTranslateButton(_ sender: Any) {
        updateTranslationData()
    }
    
    @IBAction func didTapReverseBUtton(_ sender: Any) {
        reverseTraductionButtons()
    }
    
    @IBAction func didTapTextField(_ sender: Any) {
        animateView(way: .up)
    }
    @IBAction func didUnTapTextField(_ sender: Any) {
        animateView(way: .down)
    }

    // MARK: - Proprieties
    
    // user choise for language input
    private var langIn: String {
        return languageInButton?.titleLabel?.text ?? ""
    }
    
    // user choise for language output
    private var langOut: String {
        return languageOutButton?.titleLabel?.text ?? ""
    }
    
    // text to tranlate
    private var textIn: String {
        return textField?.text ?? ""
    }
    
    private var dataTranslation: TranslationDataJSON?
    
    // MARK: - Animation
    
    // enumeration for animation when keyboard appear on the textField
    enum animationWay {
        case up
        case down
    }
    
    // animate the mainView to show the textField when the keyboard appear
    private func animateView(way: animationWay) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            let screenHeight = UIScreen.main.bounds.height
            switch way {
            case .up:
                    self.mainView?.center.y -= screenHeight / 3
            case .down:
                    self.mainView?.center.y += screenHeight / 3
            }
        })
    }


    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "langueInSegue" {
            let langTableView = segue.destination as! LanguageUITableViewController
            langTableView.delegateLangIn = self
        }
        if segue.identifier == "langueOutSegue" {
            let langTableView = segue.destination as! LanguageUITableViewController
            langTableView.delegateLangOut = self
        }
    }

    // MARK - ViewDidLoad
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        viewSetup()
    }
    
    // View setup called when viewDidLoad

    private func viewSetup() {
        translateButton?.layer.cornerRadius = 5
    }

    // MARK: - Download Data for Translation
    
    internal func updateTranslationData() {
        let textToTranslate = textIn.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if textToTranslate != "" {
            TranslationService.shared.getTraduction(textToTranslate: textToTranslate, langIn: langIn, langOut: langOut) { (data, error) in
                guard error == nil else {
                    print(error as Any)
                    return
                }
                self.dataTranslation = data
                let textOut: String = self.dataTranslation?.data?.translations?[0].translatedText ?? ""
                let translation = Traduction(langIn: self.langIn, langOut: self.langOut, textIn: self.textIn, textOut: textOut)
                TranslationService.shared.add(traduction: translation)
                self.translationTableView?.reloadData()
            }
        }
    }
    
    // MARK: - Update Data on the screen
    
    private func reverseTraductionButtons() {
        let temp1 = languageInButton?.titleLabel?.text
        let temp1image = languageInButton?.image(for: .normal)
        let temp2 = languageOutButton?.titleLabel?.text
        let temp2image = languageOutButton?.image(for: .normal)
        
        languageInButton?.setTitle(temp2, for: .normal)
        languageInButton?.setImage(temp2image, for: .normal)
        languageOutButton?.setTitle(temp1, for: .normal)
        languageOutButton?.setImage(temp1image, for: .normal)
    }

    
}

extension TranslationVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TranslationService.shared.traductions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TranslationCell", for: indexPath) as? TranslationTableViewCell else {
            return UITableViewCell()
        }
        let traduction = TranslationService.shared.traductions[indexPath.row]
        
        cell.configure(langIn: traduction.langIn, langOut: traduction.langOut, tranlatedText: traduction.textOut, originalText: traduction.textIn)
        
        return cell
    }
}

extension TranslationVC: GetLangChoosen {
    
    func updateLangInChoosen(data: String, image: String) {
        let image = UIImage(named: image)
        languageInButton?.setImage(image, for: .normal)
        languageInButton?.setTitle(data, for: .normal)
    }
    
    func updateLangOutChoosen(data: String, image: String) {
        let image = UIImage(named: image)
        languageOutButton?.setImage(image, for: .normal)
        languageOutButton?.setTitle(data, for: .normal)
    }
}

extension TranslationVC: ShowErrorMessage {
    func showAlertNoConnectionError(with title: String, and message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let reload = UIAlertAction(title: "Retry", style: .default, handler: { (action) -> Void in
            self.updateTranslationData()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: {(action) -> Void in
        })
        alert.addAction(reload)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}