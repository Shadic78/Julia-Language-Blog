# Estructura Vertice
mutable struct Vertice
    nombre::String
    numerodeVertice::Int
end

nombre(v::Vertice) = v.nombre
verticeString(v::Vertice) = "vertice: $(v.nombre), #$(v.numerodeVertice)"

# Estructura grafo
mutable struct Grafo
    numeroVertices::Int
    matrizAD::Array{Int,2}
    vertices::Array{Vertice,1}
end
# Crea un grafo iniciando la matriz de adyacencia en zeros, y los vertices como nulos el numero de vertice comienza en zero
crearGrafo(dim::Int64) = Grafo(0, zeros(Int64, dim, dim), Array{Vertice,1}(undef, dim)) 

# Funcion encargada de crear vertices e insertarlos en el grafo
function insertarVertice(nombre::String)
    grafo.numeroVertices += 1
    numV = grafo.numeroVertices
    if numV > size(grafo.vertices, 1)
        
        println("Error")
        return nothing
    end
  
    vertice = Vertice(nombre, numV)
    grafo.vertices[numV] = vertice
    
end

# funcion que obtienen el numero de vertice con un nombre en especifico
function getNumeroVertice(nombre::String)
    a = grafo.numeroVertices
    for i = 1:a 
        if nombre == grafo.vertices[i].nombre
            return i
        end
    end
    return -1
end


# funcion encargada de modificar la matriz de adyacencia para representar el grafo
function enlazarVertices(nombre1::String, nombre2::String, peso::Int64)
    n1 = getNumeroVertice(nombre1)
    n2 = getNumeroVertice(nombre2)
    if n1 == -1 | n2 == -1
        return nothing
    end
    
    grafo.matrizAD[n1, n2] = peso
    # No dirigido
    grafo.matrizAD[n2, n1] = peso
end

# funcion que imprime la matriz de adyacencia
function printMatrizAD()
    for i = 1:dimension
        for j = 1:dimension
            print(grafo.matrizAD[i, j], " ")
        end
        println()
    end
end

function esAdyacente(va::Int64, vb::Int64)
    if va < 0 | vb < 0
        println("->EROR")
        return nothing
    end


    return grafo.matrizAD[va, vb] >= 1

end

function getPeso(va::Int64, vb::Int64)
    if va < 0 | vb < 0
        println("->EROR")
        return nothing
    end

    return grafo.matrizAD[va, vb]
end

function getNumMinimunDistanceVertex(procesados::Array{Bool,1}, distancia::Array{Int64,1})
    totalVertices = length(procesados)
    min = typemax(Int64)
    min_Index = -1
    
    for i = 1:totalVertices 
        
        if (distancia[i] <= min) && (!procesados[i])
           
            min = distancia[i]
            min_Index = i
        end

    end

    return min_Index
end

function encontrarRutaMasCorta(inicial, final, listaPadres::Array{Int64,1})
    a = []
    
    destino = final
    push!(a, destino)
    
    while (destino != inicial )
        push!(a, listaPadres[destino])
        
        destino = listaPadres[destino]
       
    end

    a = reverse!(a)
    for i = 1:length(a)
        print(a[i], " -> ")
    end

end


function DijkstraAlgorithm(verticeInicial::String, verticeFinal::String, grafo::Grafo)
    totalVertices = grafo.numeroVertices
    # Encontramos el numero del vertice inicial y final
    vi = getNumeroVertice(verticeInicial)
    vf = getNumeroVertice(verticeFinal)

    # Lista de cada vertice
    # listOfLists = fill([], totalVertices)
    listaPadres = fill(0, totalVertices)
    listaPadres[1] = vi
    

    # Inicializamos los arrays de distancia y procesados
    procesados = fill(false, totalVertices)
    distancia = fill(typemax(Int64), totalVertices)
    rutas = []
    
     

    # La distancia del vertice inicial es 0
    distancia[vi] = 0

    # recorremos todos los vertices
    for i = 1:totalVertices
       # buscamos el vertice que tenga la menor distancia
        u = getNumMinimunDistanceVertex(procesados, distancia)
       
        procesados[u] = true
       

        # Actualizamos las distancias de los vertices adyacentes a u
        for j = 1:totalVertices
            
            if esAdyacente(u, j) && !procesados[j] && (distancia[u] != typemax(Int64))  && (distancia[u] + getPeso(u, j) < distancia[j])
                
                distancia[j] = distancia[u] + getPeso(u, j)
                
               # listOfLists[j] = vcat(listOfLists[j], u)
                listaPadres[j] = u
               
                    
            end
    
        end

       
    end

    # Aun no aplico entre dos vertices!!!!
    if distancia[vf] != typemax(Int64)
        println("La distancia más corta de $(grafo.vertices[vi].nombre) a $(grafo.vertices[vf].nombre) es: $(distancia[vf])")
        println("La ruta es: ")
        encontrarRutaMasCorta(vi, vf, listaPadres)
        println()

    else
        println("No existe ruta")
    end
    printSolution(distancia)
    
end

function printSolution(distancia::Array{Int64,1})
    println("Vertice\t\tDistancia")
    for i = 1:length(distancia)
        nombre = grafo.vertices[i].nombre
        println(" $nombre \t\t $(distancia[i]) ")
    end
    
end



dimension = 8
grafo = crearGrafo(dimension) # Variable global que representa el grafo



insertarVertice("1")
insertarVertice("2")
insertarVertice("3")
insertarVertice("4")
insertarVertice("5")
insertarVertice("6")
insertarVertice("7")
insertarVertice("8")


enlazarVertices("1", "2", 4)
enlazarVertices("1", "3", 3)

enlazarVertices("2", "5", 8)

enlazarVertices("3", "4", 12)
enlazarVertices("3", "6", 4)

enlazarVertices("4", "6", 2)
enlazarVertices("4", "8", 15)

enlazarVertices("5", "7", 17)

enlazarVertices("7", "4", 20)
enlazarVertices("7", "8", 9)

enlazarVertices("8", "6", 22)



printMatrizAD()
DijkstraAlgorithm("1", "8", grafo)


# Falta testear esto 



