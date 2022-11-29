//
//  MailView.swift
//  SendMailApp
//
//  Created by Ege Sucu on 25.04.2022.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {

    var to: String
    var subject: String
    var content: String
    var attachment: Data
    var mimeType: String
    var fileName: String

    typealias UIViewControllerType = MFMailComposeViewController

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        if MFMailComposeViewController.canSendMail() {
            let emailView = MFMailComposeViewController()
            emailView.mailComposeDelegate = context.coordinator
            emailView.setToRecipients([to])
            emailView.setSubject(subject)
            emailView.setMessageBody(content, isHTML: false)
            emailView.addAttachmentData(attachment, mimeType: mimeType, fileName: fileName)
            
         // TODO: Mejorar implementación
            emailView.setPreferredSendingEmailAddress("david.palafox@intelligensap.com.mx")

            return emailView
        } else {
            return MFMailComposeViewController()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
}
