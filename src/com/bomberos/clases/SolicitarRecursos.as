/////////////////////////////////////////////////////////////////
//																
//	Colicitar Recursos 													
//																
//	Gestiona las funciones de la solicitud de los recursos.
//	Situado en: main
//																
//	- -															
//	Jesús García González											
//	Universidad Carlos III de Madrid								
//	- -															
/////////////////////////////////////////////////////////////////


//-----------------------------------------------------------------
//  Después de inicializar uds_disponibles está llena de la 
//	unidades que están disponibles.
//-----------------------------------------------------------------
private function initPuntos():void{
	// inicializamos los contadores de los puntos
	num_unidad.text="0";
	num_cis.text="0";
	num_hel.text="0";
	uds_disponibles= new Array;
	
	
	// Llena la matriz de recursos disponibles
	for (var i:int = 0; i < unidades_xml.length; i++) {
		
		if (unidades_xml[i].estado=="disponible"){
			trace ("Añadido "+unidades_xml[i].tipo);
			
			uds_disponibles[uds_disponibles.length] = unidades_xml[i];
		}
	} // fin del for.
	
	
	// Actualiza el estado de los puntos de los puntos de los recursos. 
	actualizarPuntos();
}



//-----------------------------------------------------------------
//  Utilizar cada vez que se añada un recurso al mapa.
//-----------------------------------------------------------------
private function actualizarPuntos():void{
	var cout_unds:Number=0;
	var cout_cis:Number=0;
	var cout_hel:Number=0;
	
	
	for (var i:int = 0; i < uds_disponibles.length; i++) {
		switch (uds_disponibles[i].tipo){
			case "dotacion":cout_unds++;	break;
			case "cisterna":cout_cis++;	break;
			case "helicoptero":cout_hel++;	break;
		}		
	}
	
	
	// Asignamos el número de unidades disponibles
	num_unidad.text=cout_unds.toString();
	num_cis.text=cout_cis.toString();
	num_hel.text=cout_hel.toString();
	
	
	// actualiza los punto
	if (cout_unds>0) {punto_unidad.visible=true;	num_unidad.visible=true; b_recursos.enabled=true;}
	else{ punto_unidad.visible=false; num_unidad.visible=false; b_recursos.enabled=false;}
	
	if (cout_cis>0)  {punto_cis.visible=true;	num_cis.visible=true;b_cisterna.enabled=true;}
	else{ punto_cis.visible=false; num_cis.visible=false;b_cisterna.enabled=false;}
	
	
	if (cout_hel>0) {punto_hel.visible=true;	num_hel.visible=true; b_helicoptero.enabled=true;}
	else{ punto_hel.visible=false; num_hel.visible=false;b_helicoptero.enabled=false;}
	
	b_peticion.enabled=true;
	
}// Fin actualizar puntos