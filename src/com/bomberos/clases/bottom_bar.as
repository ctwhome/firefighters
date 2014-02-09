/////////////////////////////////////////////////////////////////
//																
//	BARRA INFERIOR (Bottom_bar) 													
//																
//	Se encuentran los botones de las acciones					
//	principales de la aplicación.													
//																
//	- -															
//	Jesús García González											
//	Universidad Carlos III de Madrid								
//	- -															
/////////////////////////////////////////////////////////////////


import assets.bottom_bar;
import com.bomberos.clases.Llamada;								// Dispatch Events Personalizado


//-----------------------------------
// Cerrar los paneles de los menús 
//-----------------------------------
private function button_clickHandler():void
{			
	b_mapas.closeDropDown();
	b_capas.closeDropDown();
	b_herramientas.closeDropDown();
}


//--------------------------------------------------------------------------
//
//  MENÚ MAPA: Desactiva el botón del menú del mapa seleccionado  
//
//--------------------------------------------------------------------------
private function seleccionado(boton:String):void{
	//Activa todos los botones
	b_relieve.enabled= true;
	//b_satelite.enabled= true;
	b_hibrido.enabled = true;
	b_normal.enabled = true;
	b_contraste.enabled=true;
	b_atlas.enabled=true;
	b_rosado.enabled=true;
	
	// Desactiva el botón seleccionado
	switch (boton){
		case "b_normal": 	b_normal.enabled = false;		break;
		case "b_hibrido": 	b_hibrido.enabled= false;		break;
		case "b_relieve":  	b_relieve.enabled = false; 		break;
		case "b_contraste": b_contraste.enabled = false; 	break;
		case "b_atlas": 	b_atlas.enabled = false; 		break;
		case "b_rosado": 	b_rosado.enabled = false; 		break;
		//	case "b_satelite":  b_satelite.enabled= false; 		break;
	} 
}


//-----------------------------------
//  CALCULADORA
//-----------------------------------
private function calculadora():void{
	button_clickHandler();
	if (b_calculadora.selected){
		h_calculadora.visible=true;
	}
	else{
		h_calculadora.visible=false;
	}
}


//-----------------------------------
//  BLOCK DE NOTAS
//-----------------------------------
private function notas():void{
	button_clickHandler();
	if (b_notas.selected){
		h_notas.visible=true;
	}
	else{
		h_notas.visible=false;
	}
}


//--------------------------------------------------------------------------
//
//  Activación y visibilidad de los botones de la barra inferior
//
//--------------------------------------------------------------------------


//-----------------------------------
//  Desactivar Botones
//-----------------------------------
public function desactivarBotones():void{				
	b_mapas.enabled=false;
	b_marcas.enabled=false;
	b_capas.enabled=false;

	bar.dispatchEvent(new Llamada(Llamada.ACCION,'GB_RECURSOS','DESACTIVAR'));
	b_viento_bottom.enabled=false;
	b_web.enabled=false;
	b_herramientas.enabled=false;
	b_medir.enabled=false;
}

//-----------------------------------
//  Activar Botones
//-----------------------------------
public function activarBotones():void{								
	b_mapas.enabled=true;
	b_marcas.enabled=true;
	b_capas.enabled=true;
	
	bar.dispatchEvent(new Llamada(Llamada.ACCION,'GB_RECURSOS','ACTIVAR'));
	b_viento_bottom.enabled=true;
	b_web.enabled=true;
	b_herramientas.enabled=true;

	b_medir.enabled=true;
}

//-----------------------------------
//  Ocultar Botones
//-----------------------------------
public function ocultarBotones():void{							
	b_mapas.visible=false;
	b_marcas.visible=false;
	b_capas.visible=false;
	//b_recursos.visible=false;
	b_viento_bottom.visible=false;
	//b_web.visible=false;
	bar.dispatchEvent(new Llamada(Llamada.ACCION,'GB_RECURSOS','OCULTAR'));
	b_herramientas.visible=false;
	
	b_medir.visible=false;
}

//-----------------------------------
//  Mostrar Botones
//-----------------------------------
public function mostrarBotones():void{							
	b_mapas.visible=true;
	b_marcas.visible=true;
	b_capas.visible=true;
	//b_recursos.visible=true;
	b_viento_bottom.visible=true;
	//b_web.visible=true;
	bar.dispatchEvent(new Llamada(Llamada.ACCION,'GB_RECURSOS','VER'));
	b_herramientas.visible=true;
	b_medir.visible=true;
}