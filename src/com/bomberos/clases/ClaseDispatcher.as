package com.bomberos.clases
{
	/////////////////////////////////////////////////////////////////
	//																
	//	CLASE SINGLETON 													
	//																
	//	Esta clase está escrita siguiendo el patrón Singleton para que solo se pueda 
	//	crear una única instancia y esta sea accesible dese cualquier clase. 																	
	//																
	//	- -															
	//	Jesús García González											
	//	Universidad Carlos III de Madrid								
	//	- -															
	/////////////////////////////////////////////////////////////////
	
	import flash.events.EventDispatcher;
	//
	public class ClaseDispatcher extends EventDispatcher
	{
		private static var _instancia:ClaseDispatcher;
		public static  const LLAMADA:String = "onClick_llamada";
		
		
		
		// Constructor
		public function ClaseDispatcher(s:Singleton){
		}
		
		// Hacer la llamada realmente
		public static function getInstancia():ClaseDispatcher
		{
			if (_instancia == null) {
				ClaseDispatcher._instancia = new ClaseDispatcher(new Singleton);
			}
			return _instancia;
		}
	}
}
class Singleton
{
}