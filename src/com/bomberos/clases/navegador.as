/*
/////////////////////////////////////////////////////////////////
/																/
/	NAVEGADOR WEB				 								/					
/																/
/	Instacia del navegador nativo donde se ejecuta				/ 
/	la aplicación.												/
/																/
/	- -															/
/	Jesús García González										/	
/	Universidad Carlos III de Madrid							/	
/	- -															/
/////////////////////////////////////////////////////////////////
*/
/*<!--Nota para la memoria, explicación de lo que hace el complemento que se instala:
The StageWebView class creates an instance of the native HTML browser right in your application. From this view you can browse the web, handle authentications, or anything else you may need to do in HTML. There are even events that you can get from this StageWebView to respond to location changes and other events.

The StageWebView is a bit odd that it isn’t a normal display object that you can just drop onto the stage and be done with it. Instead you need to create a Rectangle and set the rectangle’s position on the stage. The StageWebView will be rendered in the rectangle and you can attach your listeners to the StageWebView instance.
-->*/


// Función que inicia al pulsar en el botón del navegador. 
// El panel de marcadores está abierto por defecto.
private var first:Boolean=true;  									// Primera vez que entra al navegador web.
import com.bomberos.clases.Llamada;

import com.bomberos.clases.ClaseDispatcher;

private var dispatcher:ClaseDispatcher;
//-----------------------------------
//  Activar Navegador
//-----------------------------------
private function activarNavegador():void{
	if (first){
		webView.load("http://google.com");
		first=false;
	}
	
	if (!b_web.emphasized){											//bontón activado:
		b_web.emphasized=true; 
		webView.visible=true;
		ocultarBotones();
		b_web.visible=true;
		b_web_historial.visible=true;
		tb_marcadores.selected=true;
		tbMarcadores();
		ta_web.visible=true;
		dispatcher = ClaseDispatcher.getInstancia();
		dispatcher.dispatchEvent(new Llamada(Llamada.ACCION,'GB_RECURSOS','VER'));
	}
	else{
		webView.visible=false;
		b_web.emphasized=false; 
		mostrarBotones();
		b_web_historial.visible=false;
		panel_marcadores.visible=false;
		ta_web.visible=false;
		dispatcher = ClaseDispatcher.getInstancia();
		dispatcher.dispatchEvent(new Llamada(Llamada.ACCION,'GB_RECURSOS','OCULTAR'));
		// Desactiva el panel de marcadores al salir:
		/* if (panel_marcadores.visible){						
		tb_marcadores.selected=false;
		tbMarcadores();
		} */
	}
}


//--------------------------------------------
//  Activa y desactiva el panel de marcadores
//--------------------------------------------
private function tbMarcadores():void{
	if(tb_marcadores.selected){
		webView.width=1035; 
		webView.x=245; 			
		panel_marcadores.visible=true;
		iniciarMarcadores();
	}
	else{
		webView.x=0;
		webView.width=1280;
		
		panel_marcadores.visible=false;
	}
}



//--------------------------------------------------------------------------
//
//  Iniciar Marcadores: ToggleButton
//
//--------------------------------------------------------------------------
import spark.events.IndexChangeEvent;


private function iniciarMarcadores():void{
	datos_marcadores.send();
	datos_marcadores.makeObjectsBindable=true;									// Al llamar de nuevo al método datos_marcadores.send() se actualizan los datos de la lista.
}

//-----------------------------------
//  Cargar webs al selecionar item
//-----------------------------------
private function marcadoresServicios(e:IndexChangeEvent):void {
	var item:* = marcadores_servicios.dataProvider.getItemAt(e.newIndex);		// LE PASA EL OBJETO COMPLETO, así que para acceder!!!!!
	webView.load("http://"+item.url);
}
private function marcadoresDocumentacion(e:IndexChangeEvent):void {
	var item:* = marcadores_documentacion.dataProvider.getItemAt(e.newIndex);	// LE PASA EL OBJETO COMPLETO, así que para acceder!!!!!
	webView.load("http://"+item.url);
}
private function marcadoresOtros(e:IndexChangeEvent):void {
	var item:* = marcadores_otros.dataProvider.getItemAt(e.newIndex);			// LE PASA EL OBJETO COMPLETO, así que para acceder!!!!!
	webView.load("http://"+item.url);
}


//-----------------------------------
//  Panel de introucción de URl
//-----------------------------------
private function irURL():void{
	if (url_area.text!="http://"){
		webView.load(url_area.text);		
		grupo_url.visible=false;
		webView.visible=true;
	}
}




