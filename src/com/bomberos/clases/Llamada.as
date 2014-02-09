package com.bomberos.clases
{
	
	/* Esta clase se encarga de crear eventos personalizados con el fin 
	de realizar la comunicación entre módulos mediante eventos. */
	
	
	import flash.events.Event;
	
	public class Llamada extends Event
	{
		
		// Declaración de constantes
		public static const ACCION : String = "Accion";
		
		// Parámetros que se pasan mediante el evento llamada
		// Por ejemplo estas tres que se utilizan en el constructor de ejemplo.
		
		/* Parámetro que indica el nombre de quién ejecuta la acción */
		/* se pueden utilizar tantos argumentos como sean requeridos */
		public var tipo:String;
		public var tipo2:String;
		
		
		/* CONSTRUCTOR */
		public function Llamada(type:String, tipo:String, tipo2:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.tipo = tipo;
			this.tipo2 = tipo2;
		}
	}
}


/*Tipo1 y tipo 2 representan una jerarquía de subclases: 

type: ACCION    --> Representa el tipo personalizado
tipo:   	 	--> 1er grado de la categoría
tipo2:			--> 2º grado de la categoría (p.e.: tipo = "MAPA", tipo2 ("RELIEVE")

*/