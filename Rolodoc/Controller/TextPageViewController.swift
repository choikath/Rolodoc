//
//  TextPageViewController.swift
//  
//
//  Created by Katherine Choi on 5/19/18.
//

import UIKit
//import Former
import MessageUI
import Lottie
import ChameleonFramework
import SVProgressHUD

class TextPageViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate, MFMessageComposeViewControllerDelegate {
  
    

    var consultRecord: ConsultRecord!
    var delegate: HomeTableViewController?
    
   
    
    @IBOutlet var messageTableView: UITableView!


    var ptRoom: String = ""
    var ptMessage: String = ""
    var placeholderMessage: String = ""
    var puppyGiphy: Bool = false
    let puppyArray = ["pal-meme", "staycool-meme", "slide-meme"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set as the delegate and datasource:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "ProfileLabelCell", bundle: nil), forCellReuseIdentifier: "profileLabelCell")
        print("profilelabelcell registered!")

        messageTableView.register(UINib(nibName: "CenterLabelCell", bundle: nil), forCellReuseIdentifier: "centerLabelCell")
        print("centerlabelcell registered!")

        messageTableView.register(UINib(nibName: "ProfileFieldCell", bundle: nil), forCellReuseIdentifier: "profileFieldCell")
        print("profilefieldcell registered!")

        messageTableView.register(UINib(nibName: "ConsultListingCell", bundle: nil), forCellReuseIdentifier: "consultListing")
        print("consultlistingcell registered!")
        
        messageTableView.separatorStyle = .none
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 100
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)),
            name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(note:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//
//        configureTableView()
        self.messageTableView.reloadData()
    }

    //MARK: - TableView Datasource Methods
    //MARK: - Tableview Delegate Methods
    //TODO: - select row at index path -- ntd
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //TODO: - cell for row at index path
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("calling cellforrowat indexpath for indexpath: \(indexPath)")
        let cell = UITableViewCell()
        
        if indexPath.row == 0 {
            print("indexpath 0!")

            let cell = messageTableView.dequeueReusableCell(withIdentifier: "profileLabelCell", for: indexPath) as! ProfileLabelCell  // since our cell is a custom data type
            cell.titleLabel.text = consultRecord.name //"Cardiology"
           
            
           let startnum = consultRecord.number.index(consultRecord.number.startIndex, offsetBy: 3)
           let endnum = consultRecord.number.index(consultRecord.number.startIndex, offsetBy: 6)

            var phoneNumLabel = "Number unknown"
            if consultRecord.number != "Number unknown" {
                phoneNumLabel = "\(consultRecord.number.prefix(3))" + "-\(consultRecord.number[startnum..<endnum])-\(consultRecord.number.suffix(4))" }
            cell.providerLabel.text = phoneNumLabel + " \(consultRecord.consultant)"  //"Sri Adusumalli, MD"
//            if consultRecord.last_updated != "" {
//                cell.updatedAtLabel.text = "Last updated " + consultRecord.last_updated + " ago" //"24 minutes ago"
//            } else { cell.updatedAtLabel.text = "" }
            
            cell.updatedAtLabel.text = consultRecord.descrip //"24 minutes ago"
            
            
            
            return cell
        }
//        if indexPath.row == 1 {
//            print("indexpath 1!")
//            let cell = messageTableView.dequeueReusableCell(withIdentifier: "centerLabelCell", for: indexPath) as! CenterLabelCell  // since our cell is a custom data type
//            return cell
//        }
        if indexPath.row == 1 && consultRecord.carrier_id != "" {

            let cell = messageTableView.dequeueReusableCell(withIdentifier: "profileFieldCell", for: indexPath) as! ProfileFieldCell  // since our cell is a custom data type
            
            
            cell.delegate = self
            cell.titleLabel.text = "Blg and Room #"
            cell.textField.placeholder = "e.g. Rhodes #309a"

            cell.consultLabel.text = "Message to \(consultRecord.consultant): "
            cell.consultText.text = "\(consultRecord.instruc)"
            placeholderMessage = cell.consultText.text
            cell.consultText.delegate = self as UITextViewDelegate

//            cell.consultText.text = "Ask a question"
//            cell.consultText.textColor = UIColor.lightGray
            
//            cell.consultText.becomeFirstResponder()
//
//            cell.consultText.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)

            return cell
        }
        if indexPath.row == 1 && consultRecord.carrier_id == "" {
            let cell = messageTableView.dequeueReusableCell(withIdentifier: "consultListing", for: indexPath) as! ConsultListingCell

            cell.title?.text = "*Number cannot receive textpages. Please call.*"
            cell.phoneNum.text = ""
            cell.descrip.text = ""
          
            sendTextPageButton.isHidden = true
            cancelTextPageButton.isHidden = true
            return cell
            
            
        }
        else {return cell}
    }
    

    
    //TODO: - number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            var frame = messageTableView.frame
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(0.3)
            frame.size.height -= keyboardSize.height
            messageTableView.frame = frame
            let path = IndexPath(row: 1, section: 0)
            messageTableView.scrollToRow(at: path, at: UITableViewScrollPosition.top, animated: true)
            UIView.commitAnimations()
        }
    }

    @objc func keyboardWillHide(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            var frame = tableView.frame
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(0.2)
            frame.size.height += keyboardSize.height
            tableView.frame = frame
            UIView.commitAnimations()
        }
    }


    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            ptMessage = ""
            textView.textColor = UIColor.black
        }
        
        let path = IndexPath(row: 1, section: 0)
        messageTableView.scrollToRow(at: path, at: UITableViewScrollPosition.top, animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = UIColor.lightGray
            textView.text = placeholderMessage
        }
    }
    
    func didEndEditing(onCell cell: ProfileFieldCell) {
        //        _ = messageTableView.indexPath(for: cell)
        ptRoom = cell.textField.text!
//        print("**********HI KATHERINE******** \(ptRoom)")
        ptMessage = cell.consultText.text
//        print("**********HI KATHERINE******** \(ptMessage)")
    
    }
    
//    func puppyGiphyClicked(isChecked: Bool) {
//        print("PUPPY GIPHY BUTTON CLICKED")
//        puppyGiphy = isChecked
//
//    }

    
//    func textViewDidChange(_ textView: UITextView) {
////        print("CALLED TEXTVIEWDIDENDEDITING")
//        ptMessage = textView.text
////        print("TEXT VIEW'S MESSAGE NOW: \(ptMessage)")
//    }



    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(175.0)
        }
//        if indexPath.row == 1 {
//            return CGFloat(60.0)
//        }
        if indexPath.row == 1 {
            return CGFloat(400.0)
        }
        else {
            return CGFloat(100.0)
        }
        
    }
    

    
    //MARK: - Data Manipulation Methods
    
    func save(message: MessageRecord) {
//        do {
//            //            try context.save()
//            try realm.write {
//                realm.add(category)
//            }
//        }
//        catch {
//            print("error saving context \(error)")
//        }
//        tableView.reloadData()
    }
    
    func loadForm() {
        
        // realm version:
        //        categoryArray = realm.objects(Category.self)
        
        // context version:
        //        let request:NSFetchRequest<Category> = Category.fetchRequest()
        //
        //        do {
        //            categoryArray = try context.fetch(request)
        //        }
        //        catch {
        //            print("error fetching data from context \(error)")
        //        }
//        tableView.reloadData()
    }
    
//
//    func configureTableView() {
//        messageTableView.rowHeight = UITableViewAutomaticDimension
//        messageTableView.estimatedRowHeight = 400.0
//    }
    
    
    @IBAction func backNavPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var sendTextPageButton: UIButton!
    @IBOutlet weak var cancelTextPageButton: UIButton!
    
    @IBAction func cancelTextPage(_ sender: Any) {
        self.dismiss(animated: true) {
            print("closing textpage modal")
        }
    }
    
    
    // send the saved draft in realm
    @IBAction func sendTextPage(_ sender: Any) {
        

        
       
        
        if (MFMessageComposeViewController.canSendText()) {
            SVProgressHUD.show()
            let controller = MFMessageComposeViewController()
            print("########### + \(ptRoom)")
            print("########### + \(ptMessage)")
            
            if self.ptMessage == placeholderMessage {
                self.ptMessage = ""
            }
            controller.body = "*Consult via Rolodoc*" + "\n" + "Patient in room: \(self.ptRoom). " + "\n" + "\(self.ptMessage)"
            controller.recipients = [consultRecord.number]
            controller.messageComposeDelegate = self
            
            if puppyGiphy {
//                print("****CHECKED!*****")
                let giphy = puppyArray[Int(arc4random_uniform(UInt32(puppyArray.count)))]
                let path = Bundle.main.path(forResource: giphy, ofType: "gif")!
                let imageData = try! Data(contentsOf: URL(fileURLWithPath: path))
                controller.addAttachmentData(imageData as Data, typeIdentifier: "image/gif", filename: giphy + ".gif")
            }
            
            
            
            self.present(controller, animated: true) {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    
}

