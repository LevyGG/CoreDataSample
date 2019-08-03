//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Tadashi on 9/20/16.
//  Copyright © 2016 T@d. All rights reserved.
//

import UIKit
import CoreData



class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var item = [Manager]()
    let rfreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.setUpRrefreshControl()
        
        let arr = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        print("项目沙盒路径",arr[0])
        
        self.loadCoreData()
    }
    
    private func setUpRrefreshControl() {
//        let attributes = [ NSAttributedString.Key.foregroundColor.rawValue : UIColor.lightGray ]  as [String: Any]
        rfreshControl.tintColor = UIColor.black
        rfreshControl.attributedTitle = NSAttributedString(string: "Refresh ...")//, attributes: attributes)
        rfreshControl.addTarget(self, action: #selector(ViewController.refreshData(sender:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = rfreshControl
        } else {
            self.tableView.addSubview(rfreshControl)
        }
        
    }
    
    @objc func refreshData(sender: UIRefreshControl) {
        rfreshControl.beginRefreshing()
        self.loadCoreData()
        self.tableView.reloadData()
        rfreshControl.endRefreshing()
    }
    
    
	@IBAction func removeAllData(_ sender: AnyObject) {

		if item.count != 0 {

			let alert: UIAlertController =
                UIAlertController(title: "Warning!", message: "Remove all data?", preferredStyle:  UIAlertController.Style.alert)
			let defaultAction: UIAlertAction =
                UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
				(action: UIAlertAction!) -> Void in
			
				let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
				for obj in self.item {
					context.delete(obj)
				}
				do {
					try context.save()
				} catch {
					print(String(format: "Error %@: %d",#file, #line))
				}
				self.item = [Manager]()
				self.tableView.reloadData()
			})
			let cancelAction: UIAlertAction =
                UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:{
				(action: UIAlertAction!) -> Void in
			})
			alert.addAction(cancelAction)
			alert.addAction(defaultAction)
			present(alert, animated: true, completion: nil)
		}
	}

    
    /// 添加数据
    ///
    /// - Parameter sender: 按钮
	@IBAction func addData(_ sender: AnyObject) {

        let alert: UIAlertController = UIAlertController(title: "添加Manager对象", message: "名字", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler:{
			(action: UIAlertAction!) -> Void in

			let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
			let manager = Manager(context: context)
			let textField = alert.textFields![0] as UITextField
			if textField.text != "" {
				manager.name = textField.text
			} else {
				manager.name = String(self.item.count+1)
			}
			manager.date = NSDate()

			do {
				try context.save()
			} catch {
				print(String(format: "Error %@: %d",#file, #line))
			}

			self.loadCoreData()
			self.tableView.reloadData()
		})
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler:{ (action: UIAlertAction!) -> Void in })
		alert.addAction(cancelAction)
		alert.addAction(defaultAction)
		alert.addTextField(configurationHandler: {(text:UITextField!) -> Void in })
		present(alert, animated: true, completion: nil)
	}

	func loadCoreData() {
	
		let fetchRequest: NSFetchRequest<Manager> = Manager.fetchRequest()
		do {
			self.item = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(fetchRequest)
		} catch {
			print(String(format: "Error %@: %d",#file, #line))
		}
	}


	

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if segue.identifier == "StaffView" {
			let staffView:StaffView = segue.destination as! StaffView
			staffView.manager = item[(self.tableView.indexPathForSelectedRow?.row)!]
			staffView.title = item[(self.tableView.indexPathForSelectedRow?.row)!].name
		} else if segue.identifier == "AllStaffView" {
			let staffView:StaffView = segue.destination as! StaffView
			staffView.manager = nil
		}
    }
}


extension  ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel!.text = item[indexPath.row].name
        cell.detailTextLabel!.text = String(describing: item[indexPath.row].date!)
        
        return cell
    }
    
    private func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let alert: UIAlertController =
                UIAlertController(title: "Warning!", message: "Remove data?", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction =
                UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    (action: UIAlertAction!) -> Void in
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    context.delete(self.item[indexPath.row])
                    do {
                        try context.save()
                    } catch {
                        print(String(format: "Error %@: %d",#file, #line))
                    }
                    
                    self.loadCoreData()
                    
                    tableView.deleteRows(at: [indexPath], with: .fade)
                })
            let cancelAction: UIAlertAction =
                UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:{
                    (action: UIAlertAction!) -> Void in
                    self.tableView.reloadData()
                })
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            
        } else if editingStyle == .insert {
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}
