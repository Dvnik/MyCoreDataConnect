//
//  ViewController.swift
//  MyCoreDataConnect
//
//  Created on 2022/12/21.
//

import UIKit

class ViewController: UIViewController {
    //MARK: outlet
    @IBOutlet weak var fieldID: UITextField!
    @IBOutlet weak var fieldName: UITextField!
    @IBOutlet weak var fieldHeight: UITextField!
    
    @IBOutlet weak var outputLogView: UITextView!
    //MARK: values
    let studentEntity = UseEntityStudent.shared

    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        outputLogView.text = ""
    }
    //MARK: function
    func printLogView(_ info:String) {
        outputLogView.text += info + "\n"
        let nsRange = NSMakeRange(outputLogView.text!.count - 1, 1)
        outputLogView.scrollRangeToVisible(nsRange)
        
        print(info)
    }
    //MARK: actions
    
    @IBAction func AddMember(_ sender: Any) {
        guard let name = fieldName.text, let height = fieldHeight.text else {
            printLogView("Name or Height is empty.")
            return
        }
        let result = studentEntity.addNewStudent(name: name, height: height)
        
        printLogView("Add Student reslut:\(result)")
    }
    
    @IBAction func UpdateMember(_ sender: Any) {
        guard let id = fieldID.text, let idNum = Int(id) else {
            printLogView("ID can't use.")
            return
        }
        guard var student = studentEntity.findStudent(id: idNum) else {
            printLogView("Not found student.")
            return
        }
        
        if let name = fieldName.text {
            student.name = name
        }
        if let height = fieldHeight.text {
            student.height = height
        }
        let result = studentEntity.updateStudent(student)
        
        printLogView("Update Student reslut:\(result)")
    }
    
    
    @IBAction func DeleteMember(_ sender: Any) {
        guard let id = fieldID.text, let idNum = Int(id) else {
            printLogView("ID need a number.")
            return
        }
        
        let result = studentEntity.deleteStudent(id: idNum)
        printLogView("Delete Student reslut:\(result)")
    }
    
    @IBAction func GetMember(_ sender: Any) {
        guard let id = fieldID.text, let idNum = Int(id) else {
            printLogView("ID need a number.")
            return
        }
        guard let student = studentEntity.findStudent(id: idNum) else {
            printLogView("Not found student.")
            return
        }
        
        printLogView("id:\(student.id), name:\(student.name ?? ""), height:\(student.height ?? "")")
    }
    
    @IBAction func AllMember(_ sender: Any) {
        let allStudent = studentEntity.getAllStudent()
        
        allStudent.forEach { item in
            printLogView("id:\(item.id), name:\(item.name ?? ""), height:\(item.height ?? "")")
        }
    }
    
    
    
    
    
    
    
    
    
    
}

