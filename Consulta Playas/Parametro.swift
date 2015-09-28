//
//  Parametro.swift
//  Consulta Playas
//
//  Created by Manuel Zegarra on 28/09/15.
//  Copyright © 2015 M-Sonic. All rights reserved.
//

import Foundation


class Parametro:NSObject{

    
    var codigo:NSString?;
    var descripcion:NSString?;
    
    override init(){
        super.init()
    }
    
    convenience init(codigo:NSString, descripcion:NSString) {
        self.init()

            self.codigo = codigo
            self.descripcion = descripcion

    }
    
    
}