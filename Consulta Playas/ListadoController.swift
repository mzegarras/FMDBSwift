//
//  ListadoController.swift
//  Consulta Playas
//
//  Created by Manuel Zegarra on 28/09/15.
//  Copyright © 2015 M-Sonic. All rights reserved.
//

import UIKit

class ListadoController: UIViewController {
    
    
    @IBOutlet weak var tblView: UITableView!
    
    var dataArray:[Parametro] = []
        var db: FMDatabase!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let mainDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        db = FMDatabase(path:mainDelegate.dbFilePath)
        
        loadParametros()
        
        
        
    }
    
    func loadParametros() -> Void{
        
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
    
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!  {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "FMDBTest")
        
        let parametro: Parametro = self.dataArray[indexPath.row]
        
        let num = indexPath.row + 1
        
        cell.textLabel!.text = "\(num). \(parametro.descripcion!)"
        cell.detailTextLabel!.text = parametro.codigo! as String
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let renglon = indexPath.row;
        let section = indexPath.section
        
        print("renglon \(renglon)")
        print("seccion \(section)")
        
        
        self.performSegueWithIdentifier("verDetalle", sender: renglon)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let seleccion = sender as! Int;
         print("seleccion \(seleccion)")
        
        let viewController = segue.destinationViewController as! ViewController
        viewController.paramtroSelecionado = dataArray[seleccion]
        
    }
    
    func loadData(){
        print("data")
        
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.loadParametros()
            
            self.tblView.reloadData()

        })
    }
    

}
