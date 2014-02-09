import flash.events.Event;
import com.bomberos.contenedores.bottom_bar;
// ActionScript file

private function openCargaXML():void{
	//Activa y desactiva el panel del XML
	panel_xml.visible=!panel_xml.visible;
	bottom_bar.b_xml.selected=false;		// desactiva el toggleBotton del panel xml

}

private function resetApp(e:Event):void{
	
	// Cierra el panel de cargar XMl
	panel_xml.visible=false;
	
	lp_recursos.removeAllElements();
	lp_elementos.removeAllElements();
	map.clearOverlays();
	//datos_capas_serv.send();
	
	
	if (!cargadoXML){cargadoXML=true; datos_capas_serv.send(); };
	
	
	//carga el nuevo XML
	if (e.target.id=="Carga1"){
		datos_unidades_serv.send();
	}
	else{
		datos_unidades_serv2.send();
	}	
}