/* 
    Búsqueda en Amplitud y Profundidad
    
    Comparación de los dos recorridos básicos en el
    espacio de estados.

    Miguel Angel Norzagaray Cosío
    UABCS/DSC
*/

import java.util.Queue;
import java.util.ArrayDeque;
import java.util.Stack;

int Radio = 8;
boolean MostrarId = false;
boolean Buscando = false;
boolean Fin = false;

int Tam = 500;
int Divisiones=20;
int AnchoPincel = 1;
int SizeId = 12;
int Tabulador = 8;

color ColorFondo = 240;

color colorNodoMeta = #FF00FF;

// Para la edición inicial
color ColorNodoNormal = #80a0FF;
color ColorNodoTocado = #0000FF;
color ColorNodoMarcado = #80FF80;
color ColorNodoMarcadoTocado = #00FF00;
color ColorNodoVecino = #FF8000;

// Para el recorrido
color ColorNoVisitado = #80a0FF;
color ColorPendiente = #00FF00;
color ColorVisitado = #FFFF00;
color ColorCamino = #F000F0;

color ColorAristaNormal = 150;
color COlorAristaAdyacente = 50;

int MaxNodos = 32;
int NodosMarcados = 0;

//boolean MarcandoNodos = false;
Nodo NodoMarcado1, NodoMarcado2;

int CuantosNodosHay = 0;

ArrayList<Nodo> Nodos1 = new ArrayList();
ArrayList<Nodo> Nodos2 = new ArrayList();
Queue<Nodo> Cola = new ArrayDeque();
Stack<Nodo> Pila = new Stack<Nodo>();

void setup()
{
    int rmin,rmax;
    Nodo n1, n2, v;
    
    size(1000,600);
    
    int T = Tam/Divisiones;
    int M = 5;  // Desorden
      
    for ( int i=0 ; i<Divisiones ; i++ )
        for ( int j=0 ; j<Divisiones ; j++ ) {
            n1 = new Nodo( int(j*T+T/2+random(-T/M,T/M)),      // Columna
                            int(i*T+T/2+random(-T/M,T/M)) );    // Fila
            Nodos1.add(n1);
			      n2 = new Nodo(n1.x+Tam, n1.y); 
            Nodos2.add(n2);
            if ( random(100)<1 ) {
                n1.Color = colorNodoMeta;
                n2.Color = colorNodoMeta;
            }
        }
    rmin = 2;
    rmax = 3;
    for ( int i=1 ; i<Divisiones ; i++ )
        for ( int j=1 ; j<Divisiones ; j++ ) {
            n1 = Nodos1.get(i*Divisiones+j);
            n2 = Nodos2.get(i*Divisiones+j);
            
            if ( random(rmin) < random(rmax) ) {
                v = Nodos1.get(i*Divisiones+j-1);
                n1.AgregarArista(v);
                v = Nodos2.get(i*Divisiones+j-1);
                n2.AgregarArista(v);
            }

            if ( random(rmin) < random(rmax) ) {
                v = Nodos1.get((i-1)*Divisiones+j);
                n1.AgregarArista(v);
                v = Nodos2.get((i-1)*Divisiones+j);
                n2.AgregarArista(v);
            }
        }
      
    rmin = 5;
    rmax = 3;
    for ( int i=1 ; i<Divisiones-1 ; i++ )
        for ( int j=1 ; j<Divisiones-1 ; j++ ) {
            n1 = Nodos1.get(i*Divisiones+j);
            n2 = Nodos2.get(i*Divisiones+j);

            if ( random(rmin) < random(rmax) ) {
                v = Nodos1.get((i-1)*Divisiones+j-1);
                n1.AgregarArista(v);
                v = Nodos2.get((i-1)*Divisiones+j-1);
                n2.AgregarArista(v);
            }
            if ( random(rmin) < random(rmax) ) {
                v = Nodos1.get((i-1)*Divisiones+j+1);
                n1.AgregarArista(v);
                v = Nodos2.get((i-1)*Divisiones+j+1);
                n2.AgregarArista(v);
            }
            if ( random(rmin) < random(rmax) ) {
                v = Nodos1.get((i+1)*Divisiones+j-1);
                n1.AgregarArista(v);
                v = Nodos2.get((i+1)*Divisiones+j-1);
                n2.AgregarArista(v);
            }
            if ( random(rmin) < random(rmax) ) {
                v = Nodos1.get((i+1)*Divisiones+j+1);
                n1.AgregarArista(v);
                v = Nodos2.get((i+1)*Divisiones+j+1);
                n2.AgregarArista(v);
            }
        }
  
    rmin = 2;
    rmax = 4;
    for ( int i=1 ; i<Divisiones ; i++ ) {
        n1 = Nodos1.get(i);
        n2 = Nodos2.get(i);
        if ( random(rmin) < random(rmax) ) {
            v = Nodos1.get(i-1);
            n1.AgregarArista(v);
            v = Nodos2.get(i-1);
            n2.AgregarArista(v);
        }
        n1 = Nodos1.get(i*Divisiones);
        n2 = Nodos2.get(i*Divisiones);
        if ( random(rmin) < random(rmax) ) {
            v = Nodos1.get((i-1)*Divisiones);
            n1.AgregarArista(v);
            v = Nodos2.get((i-1)*Divisiones);
            n2.AgregarArista(v);
        }
    }
}

void draw()
{
    background(ColorFondo);
    stroke(0);
    line(Tam,0,Tam,Tam);
    line(0,Tam,width,Tam);
    cursor(CROSS);
    strokeWeight(AnchoPincel);

    for (Nodo n : Nodos1) 
        n.DibujarAristas();
    for (Nodo n : Nodos2) 
        n.DibujarAristas();
  
    if ( !Buscando ) {
        for (Nodo n : Nodos1) {
            if ( n.mouseIn()==true ) {
                if ( n.Color != colorNodoMeta )
                    n.Color = n.Marcado ? 
                        ColorNodoMarcadoTocado : ColorNodoTocado;
                n.MostrarId();
            } else
                if ( n.Color != colorNodoMeta )
                  n.Color = n.Marcado ? 
                    ColorNodoMarcado : ColorNodoNormal;
            if ( n.Vecino == true )
                if ( n.Color != colorNodoMeta )
                    n.Color = ColorNodoVecino;
        }
        for (Nodo n : Nodos2) {
            if ( n.mouseIn()==true ) {
                if ( n.Color != colorNodoMeta )
                    n.Color = n.Marcado ? 
                        ColorNodoMarcadoTocado : ColorNodoTocado;
                n.MostrarId();
            } else
                if ( n.Color != colorNodoMeta )
                  n.Color = n.Marcado ? 
                    ColorNodoMarcado : ColorNodoNormal;
            if ( n.Vecino == true )
                if ( n.Color != colorNodoMeta )
                    n.Color = ColorNodoVecino;
        }

        // Comienzan ambas búsquedas
        if ( NodosMarcados > 0  &&  key == ' ' ) {
            Buscando = true;
            for (Nodo n : Nodos1) {
                if ( n.Color != colorNodoMeta )
                  n.Color = ColorNoVisitado;
                n.Marcado = n.Vecino = false;
            }
            for (Nodo n : Nodos2) {
                if ( n.Color != colorNodoMeta )
                  n.Color = ColorNoVisitado;
                n.Marcado = n.Vecino = false;
            }
            Cola.add(NodoMarcado1);
            Pila.push(NodoMarcado2 );
        }
    } else if ( Buscando ) {
        // Iteraciones de las búsqueda
        Nodo u;
        if ( !Cola.isEmpty() ) {
            u = Cola.poll();
            for ( Nodo v : u.aristas ) {
                if ( v.Color == colorNodoMeta ) {
                    v.padre = u;
                    ObjetivoEncontrado(v);
                }
                if ( v.Color  == ColorNoVisitado ) {
                    v.Color = ColorPendiente;
                    v.padre = u;
                    Cola.add(v);
                }
            }
            u.Color = ColorVisitado;
        }
        if ( !Pila.isEmpty() ) {
            u = Pila.pop();
            for ( Nodo v : u.aristas ) {
                if ( v.Color == colorNodoMeta ) {
                    v.padre = u;
                    ObjetivoEncontrado(v);
                }
                if ( v.Color  == ColorNoVisitado ) {
                    v.Color = ColorPendiente;
                    v.padre = u;
                    Pila.add(v);
                }
            }
            u.Color = ColorVisitado;
        }
        //noLoop();
    }
    for (Nodo n : Nodos1)
        n.Dibujar(); //<>//
    for (Nodo n : Nodos2)
        n.Dibujar();
}

void ObjetivoEncontrado(Nodo p)
{
    fill(0);
    textSize(24);
    text("¡Nodo objetivo encontrado!", 350, 550);
    noStroke();
    fill(ColorCamino);
    circle(p.x, p.y, Radio+5);
    print("p="+p.Id);
    while ( p.padre != null ) {
      fill(ColorCamino);
      circle(p.x, p.y, Radio+5);
      p.MostrarId();
      print(" -> "+p.padre.Id);
      p = p.padre;
    }
    p.Color = colorNodoMeta;
    p.Dibujar();
    noFill();
    circle(p.x, p.y, Radio+5);
    p.MostrarId();
    Fin = true;
    Buscando=false;
    noLoop();
}

void mouseClicked()
{
	Nodo n1 = null;
  
	if ( Buscando ) {
		redraw();
		return;
	}
  if ( Fin ) {
    
    exit();
  }
  if ( mouseX>Tam )
  	return;

  for ( Nodo a : Nodos1) {
    if ( a.mouseIn() ) {
      n1 = a;
      break;
    }
  }
  if ( n1 == null )
    return;
	Nodo n2 = Nodos2.get(Nodos1.indexOf(n1));

  switch ( NodosMarcados ) {
    case 0:
      NodosMarcados = 1;
      NodoMarcado1 = n1;
      NodoMarcado2 = n2;
      for ( Nodo v : n1.aristas )
        v.Vecino = true;
      for ( Nodo v : n2.aristas )
        v.Vecino = true;
      break;
    case 1: 
      // Click sobre nodo marcado lo desmarca
      if ( NodoMarcado1 == n1 ) {
        NodosMarcados = 0;
        for ( Nodo v : n1.aristas )
          v.Vecino = false;
        for ( Nodo v : n2.aristas )
          v.Vecino = false;
      } 
      break;
    }

    n1.Marcado = !n1.Marcado;
    if ( n1.Color != colorNodoMeta )
        n1.Color = n1.Marcado ? ColorNodoMarcado : ColorNodoNormal;
    n2.Marcado = !n2.Marcado;
    if ( n2.Color != colorNodoMeta )
        n2.Color = n2.Marcado ? ColorNodoMarcado : ColorNodoNormal;

} // mouseClicked

/* Fin de archivo */
