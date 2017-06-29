//
//  ViewController.swift
//  MyNFC
//
//  Created by Morgan Collino on 6/19/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import UIKit
import CoreNFC

class MyNFCReaderSession: NFCNDEFReaderSession {
    
}

class ViewController: UIViewController {

    // MARK: - Private properties
    
    @IBOutlet private weak var scanButton: UIButton!
    private var session: NFCNDEFReaderSession?
    
    // MARK: - Overriden functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private functions
    
    @IBAction private func scanButtonTapped() {
        launchScan()
    }
    
    private func launchScan() {
        session?.invalidate()
        session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: true)
        session?.begin()
    }
    
    fileprivate func showMessage(title: String?, message: String?, action: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func retrieveTagsInfo(messages: [NFCNDEFMessage]) -> String {
        guard let message = messages.first,
            let record = message.records.first else {
            return ""
        }
        
        return String(data: record.payload, encoding: .utf8) ?? ""
    }
    
}

extension ViewController: NFCNDEFReaderSessionDelegate {
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        showMessage(title: "Error", message: error.localizedDescription, action: UIAlertAction(title: "OK", style: .destructive, handler: nil))
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        let message = retrieveTagsInfo(messages: messages)
        showMessage(title: "Scan received", message: message, action: UIAlertAction(title: "OK", style: .destructive, handler: nil))
    }
    
    
}
