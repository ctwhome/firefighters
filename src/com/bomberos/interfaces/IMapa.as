package com.bomberos.interfaces 
{ 
	import com.bomberos.clases.Llamada;

	
	// En las interfaces todos los métodos son declarados como públicos
	public interface IMapa{ 
		function cambiarMapa(evento:Llamada):void;	
		function cambiarMapa2(evento:String):void;	
	} 
}