import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
  
  private var controllers: [MVTimerController] = []

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    let controller = MVTimerController()
    controllers.append(controller)
    
    NSUserNotificationCenter.defaultUserNotificationCenter().delegate = self
    
    let nc = NSNotificationCenter.defaultCenter()
    nc.addObserver(self, selector: #selector(handleClose), name: NSWindowWillCloseNotification, object: nil)
  }
  
  func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    for controller in controllers {
      controller.window?.makeKeyAndOrderFront(self)
    }
    return true
  }

  func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
    return true
  }
  
  func newDocument(sender: AnyObject?) {
    let lastController = self.controllers.last
    let controller = MVTimerController(closeToWindow: lastController?.window)
    controllers.append(controller)
  }
  
  func handleClose(notification: NSNotification) {
    if controllers.count <= 1 {
      return
    }
    if let window = notification.object as? NSWindow {
      let controller = self.controllerForWindow(window)
      if controller != nil {
        let index = controllers.indexOf(controller!)
        if index != nil {
          controllers.removeAtIndex(index!)
        }
      }
    }
  }
  
  private func controllerForWindow(window: NSWindow) -> MVTimerController? {
    for controller in controllers {
      if controller.window == window {
        return controller
      }
    }
    return nil
  }

}

