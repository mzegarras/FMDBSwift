//
//  ViewController.swift
//  Consulta Playas
//
//  Created by Manuel Zegarra on 27/09/15.
//  Copyright © 2015 M-Sonic. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    var db: FMDatabase!
    var dataArray:[Parametro] = []
    @IBOutlet weak var txtCodigo: UITextField!
    @IBOutlet weak var txtDescripcion: UITextField!
    
    var paramtroSelecionado:Parametro?;
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "FMDB Using Swift"
        
        let mainDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
         db = FMDatabase(path:mainDelegate.dbFilePath)
        
        if let parametro : Parametro? = paramtroSelecionado{
            txtCodigo.text = parametro!.codigo! as String;
            txtDescripcion.text = parametro!.descripcion! as String;
        }
        
    }
    
    
    

    
    @IBAction func btnInsert(sender: AnyObject) {
        
        if(db.open()==false){
            NSLog("error opening db")
            return;
        }
        
        
        let parametros = [txtCodigo.text!,txtDescripcion.text!]
        
        let addQuery = "INSERT INTO parametro (nombre, valor) VALUES (?,?)"
        let addSuccessful = db.executeUpdate(addQuery, withArgumentsInArray: parametros)
        
        if !addSuccessful {
            print("insert failed: \(db.lastErrorMessage())")
        }else{
            print("insert OK")
        }
        
        db.close()
        
    }
    
    

    @IBAction func btnDelete(sender: AnyObject) {
        
        if(db.open()==false){
            NSLog("error opening db")
            return;
        }
        
        let parametros = [txtCodigo.text!]
        let addQuery = "DELETE FROM parametro WHERE idparametro=?"
        let addSuccessful = db.executeUpdate(addQuery, withArgumentsInArray: parametros)
        
        
        if !addSuccessful {
            print("delete failed: \(db.lastErrorMessage())")
        }else{
            print("delete OK")
        }
        
        db.close()
        
    }
   
    @IBAction func btnUpdate(sender: AnyObject) {
        
        
        
        if(db.open()==false){
            NSLog("error opening db")
            return;
        }
        
        
        
        let parametros: [AnyObject] = [txtCodigo.text!,txtDescripcion.text!,17]
        let addQuery = "UPDATE parametro SET nombre = ?, valor = ? WHERE idparametro = ?"
        let addSuccessful = db.executeUpdate(addQuery, withArgumentsInArray: parametros)
        
        
        if !addSuccessful {
            print("updated failed: \(db.lastErrorMessage())")
        }else{
            print("updated OK")
        }
        
        db.close()
        
        
    }
    
    @IBAction func btnSize(sender: AnyObject) {
        
        if(db.open()==false){
            NSLog("error opening db")
            return;
        }
        
        
         let rsTemp: FMResultSet? = db.executeQuery("SELECT count(*) AS numrows FROM parametro", withArgumentsInArray: [])
            rsTemp!.next()
        let numrows = rsTemp?.intForColumn("numrows")
        rsTemp!.close();
        
        NSLog("numrows: \(numrows)")
        
        db.close()
    }
    
    
    @IBAction func btnListar(sender: AnyObject) {
        
        dataArray.removeAll()
        
        if(db.open()==false){
            NSLog("error opening db")
            return;
        }
        
        let mainQuery = "SELECT nombre, valor FROM parametro"
        let rsMain: FMResultSet? = db.executeQuery(mainQuery, withArgumentsInArray: [])
        
        
        while (rsMain!.next() == true) {
            let nombre = rsMain?.stringForColumn("nombre")
            let valor = rsMain?.stringForColumn("valor")
            
            let parametro = Parametro(codigo: nombre!, descripcion: valor!)
            self.dataArray.append(parametro)
            
        }
        
        rsMain!.close()
        
        db.close()
        
        
        NSLog("numrows: \(dataArray.count)")
        
    }
    
    @IBAction func btnClose(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
         let listadoController = presentingViewController as! ListadoController
        listadoController.loadData()
        
        
    }

}

