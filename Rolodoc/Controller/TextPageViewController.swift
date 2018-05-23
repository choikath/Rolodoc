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


class TextPageViewController: UITableViewController, UITextViewDelegate, MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    

    var consultRecord: ConsultRecord!
    var delegate: HomeTableViewController?
    
   
    
    @IBOutlet var messageTableView: UITableView!
    
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

        
        messageTableView.separatorStyle = .none
        
//        configureTableView()
//        self.messageTableView.reloadData()
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
            
            cell.titleLabel.text = consultRecord.name//"Cardiology"
            cell.providerLabel.text = consultRecord.consultant //"Sri Adusumalli, MD"
            if consultRecord.last_updated != "" {
                cell.updatedAtLabel.text = "Last updated " + consultRecord.last_updated + " ago" //"24 minutes ago"
            } else { cell.updatedAtLabel.text = "" }
            return cell
        }
        if indexPath.row == 1 {
            print("indexpath 1!")
            let cell = messageTableView.dequeueReusableCell(withIdentifier: "centerLabelCell", for: indexPath) as! CenterLabelCell  // since our cell is a custom data type
            return cell
        }
        if indexPath.row == 2 {
            print("indexpath 2!")

            let cell = messageTableView.dequeueReusableCell(withIdentifier: "profileFieldCell", for: indexPath) as! ProfileFieldCell  // since our cell is a custom data type
            

            cell.titleLabel.text = "Blg and Room # "
            cell.textField.placeholder = "e.g. Rhodes #309a"
            cell.consultLabel.text = "Message: "
            cell.consultText.delegate = self as! UITextViewDelegate
            
//            cell.consultText.text = "Ask a question"
//            cell.consultText.textColor = UIColor.lightGray
            
//            cell.consultText.becomeFirstResponder()
//
//            cell.consultText.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)

            return cell
        }
        else {return cell}
    }
    
    //TODO: - number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(80.0)
        }
        if indexPath.row == 1 {
            return CGFloat(100.0)
        }
        if indexPath.row == 2 {
            return CGFloat(400.0)
        }
        else {
            return CGFloat(600.0)
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
    
    
    @IBAction func cancelTextPage(_ sender: Any) {
        self.dismiss(animated: true) {
            print("closing textpage modal")
        }
    }
    
    
    // send the saved draft in realm
    @IBAction func sendTextPage(_ sender: Any) {
        
        
        let animationView = LOTAnimationView(name: "checked_done_")
        self.view.addSubview(animationView)
        animationView.frame.size.width = UIScreen.main.bounds.width
        animationView.frame.size.height = UIScreen.main.bounds.width
//        animationView.setValue(UIColor.flatPink(), forKeypath: "layers.Shape Layer 8.Ellipse 1.Fill 1.Color", atFrame: 0)
//        animationView.setValue(UIColor.flatPink(), forKeypath: "layers.Shape Layer 1.Ellipse 1.Fill 1.Color", atFrame: 0)
//        animationView.setValue(UIColor.flatPink(), forKeypath: "layers.Shape Layer 2.Ellipse 1.Fill 1.Color", atFrame: 0)
//        animationView.setValue(UIColor.flatPink(), forKeypath: "layers.Shape Layer 3.Ellipse 1.Fill 1.Color", atFrame: 0)
//        animationView.setValue(UIColor.flatPink(), forKeypath: "layers.Shape Layer 4.Ellipse 1.Fill 1.Color", atFrame: 0)
//        
//        print(animationView.logHierarchyKeypaths())
        
        animationView.play{ (finished) in
            print("lottie played")
            animationView.removeFromSuperview()

        }
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "HI THIS IS A CONSULT"
            controller.recipients = [consultRecord.number]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }

    
}

