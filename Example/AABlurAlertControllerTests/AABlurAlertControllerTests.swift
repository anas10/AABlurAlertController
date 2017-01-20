//
//  AABlurAlertControllerTests.swift
//  AABlurAlertControllerTests
//
//  Created by Anas Ait Ali on 17/01/2017.
//
//

import Quick
import Nimble
import Nimble_Snapshots

@testable import AABlurAlertController

class AABlurAlertControllerTests: QuickSpec {

    override func spec() {
        var aaBlurAlertController: AABlurAlertController!

        describe("a AABlurAlertController") {
            beforeEach {
                let window = UIWindow(frame: UIScreen.main.bounds)
                window.rootViewController = UIViewController()
                window.makeKeyAndVisible()
                aaBlurAlertController = AABlurAlertController()
            }

            it("looks good with image, title, subtitle and 2 buttons") {
                let subject = self.testSubject(aaBlurAlertController)
                expect(subject).to(haveValidDeviceAgnosticSnapshot())
            }

            it("looks good with image, title, subtitle and 1 button") {
                let subject = self.testSubject(aaBlurAlertController, image: true, title: true, subtitle: true, numberOfBtn: 1)
                expect(subject).to(haveValidDeviceAgnosticSnapshot())
            }

            it("looks good with image, title and 2 buttons") {
                let subject = self.testSubject(aaBlurAlertController, image: true, title: true, subtitle: false)
                expect(subject).to(haveValidDeviceAgnosticSnapshot())
            }

            it("looks good with title, subtitle and 2 buttons") {
                let subject = self.testSubject(aaBlurAlertController, image: false)
                expect(subject).to(haveValidDeviceAgnosticSnapshot())
            }

            it("looks good with title and 2 buttons") {
                let subject = self.testSubject(aaBlurAlertController, image: false, title: true, subtitle: false)
                expect(subject).to(haveValidDeviceAgnosticSnapshot())
            }

            it("looks good with title, long subtitle and 2 buttons") {
                let subject = self.testSubject(aaBlurAlertController, image: false)
                subject.alertSubtitle.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."
                expect(subject).to(haveValidDeviceAgnosticSnapshot())
            }

            it("looks good with long title, subtitle and 2 buttons") {
                let subject = self.testSubject(aaBlurAlertController, image: false)
                subject.alertTitle.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."
                expect(subject).to(haveValidDeviceAgnosticSnapshot())
            }

            it("looks good with title, subtitle and no buttons") {
                let subject = self.testSubject(aaBlurAlertController, image: false, title: true, subtitle: true, numberOfBtn: 0)
                expect(subject).to(haveValidDeviceAgnosticSnapshot())
            }
        }
    }

}

extension AABlurAlertControllerTests {
    func testSubject(_ blurAlertController: AABlurAlertController,
                     image: Bool = true,
                     title: Bool = true,
                     subtitle: Bool = true,
                     numberOfBtn: Int = 2
        ) -> AABlurAlertController {
        if image {blurAlertController.alertImage.image = UIImage(named: "illustration_profile_avatar")}
        if title {blurAlertController.alertTitle.text = "Start a job ?"}
        if subtitle {blurAlertController.alertSubtitle.text = "Are you sure you would like to start the job?\nThis action cannot be undone."}
        if numberOfBtn >= 1 {
            blurAlertController.addAction(action: AABlurAlertAction(title: "Cancel", style: AABlurActionStyle.cancel, handler: nil))
        }
        if numberOfBtn >= 2 {
            blurAlertController.addAction(action: AABlurAlertAction(title: "Start", style: AABlurActionStyle.default, handler: nil))
        }
        return blurAlertController
    }
}
