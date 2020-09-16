/*
  Clase NodoArco
  
  Base para construir gráficas de propósito múltiple.
*/

class Nodo {
  int x, y, Id;
  int OrdenDeVisita;
  color Color;
  boolean Marcado;
  boolean Vecino;
  boolean SeMuestraOrden;
  Nodo padre;
  ArrayList<Nodo> aristas = new ArrayList();
  Nodo(int X, int Y) {
    x = X;
    y = Y;
    padre = null;
    Color = ColorNodoNormal;
    Marcado = false;
    Vecino = false;
    Id = CuantosNodosHay++;
    OrdenDeVisita = 0;
    SeMuestraOrden = false;
  }
  void AgregarArista(Nodo Vecino) {
    aristas.add(Vecino);
    Vecino.aristas.add(this);
  } 
  boolean mouseIn() {
    if ( x-Radio/2<mouseX && mouseX<x+Radio/2  &&
         y-Radio/2<mouseY && mouseY<y+Radio/2 ) {
           return true;
    }
     return false;
  }
  void Mover(int x, int y) {
    if ( x<Radio ) 
        x = Radio+1;
    this.x = x;
    if ( y<Radio ) 
        y = Radio+1;
    if ( y > height-Radio )
        y = height-Radio-1;
    this.y = y;
  }
  void Dibujar() 
  {
    if ( !mouseIn() )
      noStroke();
    fill(this.Color);
    ellipse(x, y, Radio, Radio);
    stroke(25);
  }
  void MostrarId() {
    textSize(SizeId);
    fill(0);
    text(str(this.Id),this.x+Radio/2,this.y-Radio/2);
  }
  void MostrarOrden() {
    textSize(SizeId);
    fill(0);
    text(str(OrdenDeVisita),x+Radio/2,y-Radio/2);
  }
  void DibujarAristas() {
    for (Nodo Adjacentes : aristas) {
      if ( Adjacentes.Vecino && Vecino )
        stroke(ColorNodoVecino);
      else 
        stroke(200);
      line(x, y, Adjacentes.x, Adjacentes.y);
    }
  }
}
