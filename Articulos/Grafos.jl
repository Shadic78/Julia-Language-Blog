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
createGrafo(dim::Int64) = Grafo(0, zeros(Int64, dim, dim), Array{Vertice,1}(undef, dim)) 

# Funcion encargada de crear vertices e insertarlos en el grafo
function insertarVertice(nombre::String)
    grafo2.numeroVertices += 1
    numV = grafo2.numeroVertices
    if numV > size(grafo2.vertices, 1)
        
        println("Erros")
        return nothing
    end
  
    vertice = Vertice(nombre, numV)
    grafo2.vertices[numV] = vertice
    
end

# funcion que obtienen el numero de vertice con un nombre en especifico
function getNumeroVertice(nombre::String)
    a = grafo2.numeroVertices
    for i = 1:a 
        if nombre == grafo2.vertices[i].nombre
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
    
    grafo2.matrizAD[n1, n2] = peso
    # No dirigido
    grafo2.matrizAD[n2, n1] = peso
end

# funcion que imprime la matriz de adyacencia
function printMatrizAD()
    for i = 1:dimension
        for j = 1:dimension
            print(grafo2.matrizAD[i, j], " ")
        end
        println()
    end
end

function esAdyacente(va::Int64, vb::Int64)
    if va < 0 | vb < 0
        println("->EROR")
        return nothing
    end


    return grafo2.matrizAD[va, vb] >= 1

end

function getPeso(va::Int64, vb::Int64)
    if va < 0 | vb < 0
        println("->EROR")
        return nothing
    end

    return grafo2.matrizAD[va, vb]
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


function DijkstraAlgorithm(verticeInicial::String, verticeFinal::String, grafo::Grafo)
    totalVertices = grafo.numeroVertices
    # Encontramos el numero del vertice inicial y final
    vi = getNumeroVertice(verticeInicial)
    vf = getNumeroVertice(verticeFinal)

    # Inicializamos los arrays de distancia y procesados
    procesados = fill(false, totalVertices)
    distancia = fill(typemax(Int64), totalVertices)

    distancia[vi] = 0

    # recorremos todos los vertices
    for i = 1:totalVertices
       # buscamos el vertice que tenga la menor distancia
        u = getNumMinimunDistanceVertex(procesados, distancia)
       
        procesados[u] = true

        # Actualizamos las distancias de los vertices adyacentes a u
        for i = 1:totalVertices
            
            if esAdyacente(u, i) && !procesados[i] && (distancia[u] != typemax(Int64))  && (distancia[u] + getPeso(u, i) < distancia[i])
               
                distancia[i] = distancia[u] + getPeso(u, i)
               
            end
    
        end

       
    end

    # Aun no aplico entre dos vertices!!!!
    if distancia[vf] != typemax(Int64)
        println("La distancia más corta de $(grafo2.vertices[vi].nombre) a $(grafo2.vertices[vf].nombre) es: $(distancia[vf])")

    else
        println("No existe ruta")
    end
    printSolution(distancia)
end

function printSolution(distancia::Array{Int64,1})
    println("Vertice\t\tDistancia")
    for i = 1:length(distancia)
        nombre = grafo2.vertices[i].nombre
        println(" $nombre \t\t $(distancia[i]) ")
    end
    
end



dimension = 8
grafo2 = createGrafo(dimension) # Variable global que representa el grafo



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
DijkstraAlgorithm("1", "8", grafo2)


# Falta testear esto 



