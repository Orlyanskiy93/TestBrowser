//
//  ViewController.swift
//  TestBrowser
//
//  Created by Дмитрий Орлянский on 31.05.2021.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    var isFinishedLoading: Bool = false
    var loadingTimer: Timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.progress = 0
        progressView.isHidden = true
    }
    
    func startLoadingTimer() {
        self.progressView.progress = 0.0
        progressView.isHidden = false
        self.loadingTimer = Timer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }

    func stopLoadingTimer() {
        self.isFinishedLoading = true
    }

    @objc func timerCallback() {
        if self.isFinishedLoading {
            if self.progressView.progress >= 1 {
                self.progressView.isHidden = true
                self.loadingTimer.invalidate()
            } else {
                self.progressView.progress += 0.1
            }
        } else {
            self.progressView.progress += 0.05
            if self.progressView.progress >= 0.95 {
                self.progressView.progress = 0.95
            }
            if !webView.isLoading {
                isFinishedLoading = true
            }
        }
    }

    func showAllert(with title: String) {
        let allert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        allert.addAction(action)
        present(allert, animated: true, completion: nil)
    }

    @IBAction func loadURL(_ sender: UIButton) {
        guard let text = urlTextField.text, !text.isEmpty else {
            showAllert(with: "URL field is empty!")
            return
        }
        
        let url = URL(string: text)!
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        startLoadingTimer()
    }
    @IBAction func back(_ sender: UIButton) {
        webView.goBack()
    }
    
    @IBAction func forward(_ sender: UIButton) {
        webView.goForward()
    }
}

