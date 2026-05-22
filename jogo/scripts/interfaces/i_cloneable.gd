## Prototype Pattern — interface para objetos que suportam clonagem profunda.
##
## Em GDScript não existem interfaces nativas, então ICloneable é implementada
## como uma classe base (Resource) com um método clone() virtual.
## Qualquer Resource que precise ser copiado via Prototype deve estender esta classe
## e sobrescrever clone() com sua lógica de cópia profunda.
##
## Uso:
##   var copia := meu_objeto.clone() as MinhaClasse
extends Resource
class_name ICloneable
 
 
## Retorna uma cópia profunda deste objeto.
## Subclasses DEVEM sobrescrever este método.
## Retorna null na implementação base — nunca chame diretamente sem sobrescrever.
func clone() -> Resource:
	return null
