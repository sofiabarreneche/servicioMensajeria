class Mensaje{
	var property chat
	var usuarioEnviador
	var pesoKB
	const datosTransferencia
	var contenido
	var factorRed
	method peso(){
		return datosTransferencia + contenido.pesoC() * factorRed
	}
}
class Texto{
	var caracteres
	method pesoC(){
		return 1*caracteres
	}
}
class Audio{
	var duracionEnSeg
	method pesoC(){
		return duracionEnSeg*1.2
	}
}
class Imagen{
	var alto
	var ancho
	var pesoPixeles = alto*ancho*2
	var modoCompresion
}
object original inherits Imagen{
	method pesoC(){
		return pesoPixeles
	}
}
object variable inherits Imagen{
	var porcentaje
	method pesoC(){
		return porcentaje*pesoPixeles
	}	
}
object maxima inherits Imagen{
	method pesoC(){
		return pesoPixeles.min(10000)
	}
}
class Gif inherits Imagen{
	var cantCuadros
	method pesoC(){
		return pesoPixeles*cantCuadros
	}
}
class Contacto{
	var nombre
	method pesoC(){
		return 3
	}
}
class Usuario{
	var property chats = #{}
	var memoriaUsada
	var memoriaTotal
	var mensajesNoLeidos = #{}
	
	method mensajesMasPesados(){
		chats.map({unChat => unChat.mensajeMasPesado()})
	}
	method enviar(mensaje,contacto){
			contacto.recibir(mensaje)
		}
	method recibir(mensaje){
		memoriaUsada + mensaje.pesoC()
		self.recibirNotificacion(mensaje)
	} 
	method recibirNotificacion(mensaje){
		mensajesNoLeidos.add(mensaje)
	}
	//method leerMensaje(mensaje){//esta parte no se que onda el == chat pq me la copie de la resolucion
		//mensajesNoLeidos.filter({x => x.chat() == chat}).forEach({x =>x.leerNoLeidos()})
	//}
	method tieneEspacio(unPeso){
		if(memoriaUsada + unPeso > memoriaTotal){
			self.error("no tiene suficiente espacio")
		}else true
	}
}
class Chat{
	var property memoriaUsada
	var property participantes =#{}
	var mensajes = #{}
	var property mensajesNoLeidos = #{}
	method condicionParaEnviar(mensaje,contacto, usuario){
		if(participantes.contains(contacto) and participantes.all({unParticipante => unParticipante.tieneEspacio(mensaje.pesoC())})){
				usuario.enviar(mensaje,contacto)
				memoriaUsada += mensaje.pesoC()
				mensajes.add(mensaje)
				mensajesNoLeidos.add(mensaje)
		}
		
	}
	method leerNoLeidos(){
		mensajesNoLeidos.removeAll()
	}
	method mensajeMasPesado(){
		mensajes.max({unMensaje => unMensaje.pesoC()})
	}

}
class ChatPremium{
	var usuarios = #{}
	var restricciones
	var creador
	var limiteMensajes
	var mensajesEnChat
	var limitePeso
}
object difusion inherits ChatPremium{
	method condicionParaEnviar(mensaje,contacto,usuario){
		if(creador == usuario){
			usuario.enviar(mensaje,contacto)
		}
	}
}
object restringido inherits ChatPremium{
	method condicionParaEnviar(mensaje,contacto,usuario){
		if(mensajesEnChat == limiteMensajes){
			self.error("ya se ha llegado al limite permitido de mensajes")
		}else {
			usuario.enviar(mensaje,contacto) 
			mensajesEnChat += 1
			}
	}
}
object ahorro inherits ChatPremium{
	method condicionParaEnviar(mensaje,contacto,usuario){
		if(mensaje.pesoC()> limitePeso){
			self.error("no se puede enviar el mensaje ya que supera el limite")
		}else usuario.enviar(mensaje,contacto)
	}
}