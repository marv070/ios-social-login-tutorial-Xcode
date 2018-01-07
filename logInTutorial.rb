HOW TO ADD SOCIAL LOGINS TO YOUR IOS APP

1, Open the app that you created in Xcode that you want to added social log ins to. 

2, Add a new view controller where your social log in buttons will appear on main story board.
  - From search filter box(bottom right), type view controller and after selecting view controller, drag into  main story board to the left of your existing view.
  - Drag the starting point arrow over to your new view.
  - Create new SWIFT file from file new  and place just under main story board. 
  for eg. SocialLogInController.swift. (capitalize first letter in name then camel case.)
  - Now add your custom class  name  in the  identity inspector by typing  Capitalized  class name in class input box. 
  - CLICK   INHERIT MODULE FROM TARGET BELOW THIS CLASS SELECTION. (Will to work if this is not checked.) 


3,  gem install cocoa pods from terminal

4,  pod init  from terminal  

5,  Open pod file in text editor
     - Add  these pods where it says pods for nameOfMyApp:
        pod ‘Firebase/Core’
        pod ‘Firebase/Auth’
       pod ‘GoogleSignIn’
       pod ‘FBSDKLoginKit’
     - save file.

6, type pod install from terminal.(this could take a few minutes.)

7, Set up firebase needed for google and facebook authorization.
    - you must have a valid google email
    - you must have a valid apple dev account(You many need to use your company accounts apple id since account cost $99 per year.) 
    - go to firebase.google.com
    - make sure you are signed in to the correct gmail that you want to  use. 
    - Then click go to console
    - Then from firebase console click add project
    - Give project name  a click create


8, From the firebase console select add an iOS app. You will need your bundle id from your Xcode app. (General Tab of app)
  - download plist 
  - drag info.plist into your Xcode project with the other plist file.

9, Add initialization code to your AppDelegate.swift file.
    open AppDelegate.swift file from within Xcode

      - Add  import Firebase to import list at top of page.
      - replace func application with :

     func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
    -> Bool {
    FirebaseApp.configure()
    return true
  }

10, Enable google sign from firebase console.

      from firebase console  click develop tab on left side
        - click Authentication under develop tab
        - click sign in methods
        - click google edit pencil
        - click enable tab and then save

11, Add Redirect google url scheme

      from Xcode GoogleService-Info.plist
        -highlight and copy Reversed client id url
        - now click on app name then info tab
        - click url types then click add
        - paste url from reversed client id in url schema input box 
        - hit enter

12, Create Bridging-Header-file where info.plist is in Xcode.
          - go to file, then new file, create HEADER and name file: YourAppNameHere-Bridging-Header.h
          - next open new header file and on line 11 paste: #import <GoogleSignIn/GoogleSignIn.h>

13,  Open AppDelegate.swift file and  add these two functions  below the func application

      @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        
        let googlePlusFlag = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        
        return googlePlusFlag
    }


  - Also  add import GoogleSignIn to the imports on AppDelegate.swift



14, Add view to your logInController in your main story board for the google button.
    - click on your Main.storyboard
    - over in the element search bar(bottom far right search box) type view
    - scroll down and find view
    - click and drag into your log in controller and release.
    -   set class on the right hand side in the identify inspector to GIDSignInButton.(you may be able to click drop down and find else just type in.)
    - Click the play button in the top left of page to run app. You should see a google button appear. It won’t work yet but it should be there.


15,  Open your Controller file for logIn such as SocialLogInController.swift
  update file as such : 

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class SocialLogInController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        
        }
        let authentication = user.authentication
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
        Auth.auth().signIn(with: credential, completion: { (user,error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            print("User loggin in with google")
        })
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
            
        }
    }
    
    
    
}

  - After pasting in the code you need to update your class name to match your specific class that you named earlier for eg. class LogInController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {       (class is named just below the imports at top of page.)


16, Run in simulator to make sure google log in works. It will not redirect anywhere yet without a segue but you should be able to log in. If not go back through all steps and be sure everything was completed up to this point.

17, Add  manual segway from your loginController to  Viewcontroller (This will allow going from the log in page to the next page after successful login.)
    -  click main story board 
    -  From your logincontroller view  highlight the  top yellow button that shows your controller(This is at the top of the view in the nav bar area, there are three options here.) and hold down control. Now drag across to the other view controller and release in the main page area. 
  segue menu pops up.
    - select show
    - Now click the new segway triangle from your main storyboard.
    - add  name for segway in the identifier box on right side in the attribute inspector. 
    - hit enter

    - Open your logincontroller.swift file and add this line under your print(“User logged in with google”):
     
     self.performSegue(withIdentifier: "viewHelloWorldViewController", sender: self)
      
      - should look like this: 
        Auth.auth().signIn(with: credential, completion: { (user,error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            print("User loggin in with google")
            self.performSegue(withIdentifier: "viewHelloWorldViewController", sender: self)
        })

The above line of code(self.performSegue(withIdentifier: "viewHelloWorldViewController", sender: self)) executes the segue which will allow going to your next view controller after successful log in with google.
  - Be sure to update above line so that the segue is named according to the name that you used to name hour segue.

  - You should now have a working google log in that connects to your next view controller. Test this by clicking play button on top left of page. click google button to log in the you should be directed to your next view. 


18, CREATE NEW APP IN FACEBOOK 
  - go to developer.facebook.com and click create new project.
  - give project name
  - click facebook log in then set up
  - click new iOS app.
  - downloaded sdk and add the  FBSDKCoreKIT and FBSDKLoginKit to frameworks folder in your Xcode project.
  - From Xcode click top tab on left side(should be name of your project) then click the general tab in the main area.
  - copy and clip the  bundle id and add to  facebook and click save.
  - from facebook console click next and at this time we don’t need to enable the allow tab. Just click save.


19, Add functions to plist inXcode.
  - From Xcode right click info.plist and select open as then click  source  code. 
  - Copy the two code snippets supplied from facebook to your plist source code(paste at bottom just before closing </dict> tag.

20, Copy this line: #import <FBSDKCoreKit/FBSDKCoreKit.h>
      - add copied line to your bridge-header-file on line 12 just below google sign in line.

21, Get facebook app id  and secret for firebase
      - from your facebook console  select your app and copy your app id so that u can add to firebase.
     - go back to your firebase app and select facebook.
      - click enable 
      - add your facebook id.
      - add your facebook secret. 
      -  BEFORE leaving copy the redirect url and go back to FACEBOOK dashboard. On left hand side click facebook login under products and add the url to the redirect url.

22, Open your AppDelegate.swift file in Xcode and update your code from code below :

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
        -> Bool {
            FirebaseApp.configure()
            return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        
        let wasHandled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
        
        let googlePlusFlag = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
       
        return wasHandled || googlePlusFlag
        
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

 
23, Add Facebook Button to your loginControllerview.
      - Add view to main story board for our facebook button(type view in element search bar on bottom right and select view and drag into your logincontroller)
      -  select FBSDKLOGINButton  in the drop down  for the class in identity inspector
  
24, Add outlet for facebook button.
      - From Xcode console click the double circles on top right. this will bring up the code file for your login controller. If your login controller is not the file showing then click the small four boxes in to top left corner of this page. select your login controller and the code will pop up. 
      - Select the facebook button and then hold down control and drag the line into your login controller above the override function toward the top and release. 
      - Select name for your outlet for eg. faceBookLogInButton, when the options box pops up.
    
25, Add following code snippets to your login controller:
      - import FBSDKLoginKit to imports 
      - Add FBSDKLoginButtonDelegate to delegates in loginController class for eg. class LogInController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
  
      - copy this line: faceBookLogInButton.delegate = self 
      - add copied line into the override func viewDidLoad()

        for eg. override func viewDidLoad() {
                  super.viewDidLoad()
        
                      // Do any additional setup after loading the view, typically from a nib.
                      GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
                       print(GIDSignIn.sharedInstance().clientID, "id is here!!!!!!!!")
                      GIDSignIn.sharedInstance().delegate = self
                      GIDSignIn.sharedInstance().uiDelegate = self
                      faceBookLogInButton.delegate = self      <<<<<< Add line here
               }


      - Add these functions next:
      func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (FBSDKAccessToken.current() == nil) {
            print(error!.localizedDescription)
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential, completion: { (user,error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print("User has signed in with Facebook!")
  self.performSegue(withIdentifier: "viewHelloWorldViewController", sender: self)
        })
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try! Auth.auth().signOut()
    }


26, Update this line: self.performSegue(withIdentifier: "viewHelloWorldViewController", sender: self)] so that your segue name is include for for eg. "viewHelloWorldViewController"

# Now try and run your app in the simulator and be sure your facebook works.