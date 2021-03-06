
import UIKit
import ResearchKit

class OnboardingViewController: UIViewController {
    // MARK: IB actions
    
    @IBAction func joinButtonTapped(_ sender: UIButton) {
        let consentDocument = ConsentDocument()
        let consentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
        
        let healthDataStep = HealthDataStep(identifier: "Health")
                
        let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: nil ,in: consentDocument)
        
        reviewConsentStep.text = "Prüfen Sie die Einverständniserklärung."
        reviewConsentStep.reasonForConsent = "Zustimmung zur Teilnahme an der Studie."
        
        let completionStep = ORKCompletionStep(identifier: "CompletionStep")
        completionStep.title = "Willkommen!"
        completionStep.text = "Vielen Dank das du teilnimmst."
         
        let orderedTask = ORKOrderedTask(identifier: "Join", steps: [consentStep, reviewConsentStep, healthDataStep, completionStep])
        let taskViewController = ORKTaskViewController(task: orderedTask, taskRun: nil)
        taskViewController.delegate = self
        
        present(taskViewController, animated: true, completion: nil)
    }
}

extension OnboardingViewController: ORKTaskViewControllerDelegate {
    
    public func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        print(reason)
        switch reason {
            case .completed:
                defaults.set(true, forKey: "joinedStudy")
                performSegue(withIdentifier: "unwindToStudy", sender: nil)

            case .discarded, .failed, .saved:
                dismiss(animated: true, completion: nil)
        @unknown default:
            dismiss(animated: true, completion: nil)
        }
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, viewControllerFor step: ORKStep) -> ORKStepViewController? {
        if step is HealthDataStep {
            let healthStepViewController = HealthDataStepViewController(step: step)
            return healthStepViewController
        }
        
        return nil
    }
}
