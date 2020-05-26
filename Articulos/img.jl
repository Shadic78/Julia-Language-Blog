import REPL
using REPL.TerminalMenus
# Estructura Vertice
mutable struct Vertice
    nombre::String
    numerodeVertice::Int64
end

nombre(v::Vertice) = v.nombre
verticeString(v::Vertice) = "vertice: $(v.nombre), #$(v.numerodeVertice)"

# Estructura grafo
mutable struct Grafo
    numeroVertices::Int64
    matrizAD::Array{Int64,2}
    vertices::Array{Vertice,1}
end
# Crea un grafo iniciando la matriz de adyacencia en zeros, y los vertices como nulos el numero de vertice comienza en zero
crearGrafo(dim::Int64) = Grafo(0, zeros(Int64, dim, dim), Array{Vertice,1}(undef, dim))

# Funcion encargada de crear vertices e insertarlos en el grafo
function insertarVertice(nombre::String, grafo::Grafo)

    numero = getNumeroVertice(nombre, grafo)
    if numero > 0
        println("<--------ERROR Vertice ya existe--------->")
        return nothing
    end

    grafo.numeroVertices += 1
    numV = grafo.numeroVertices


    if numV > size(grafo.vertices, 1)
        grafo.numeroVertices -= 1
        println("<--------ERROR--------->")
        return nothing
    end


    vertice = Vertice(nombre, numV)
    grafo.vertices[numV] = vertice

end

# funcion que obtienen el numero de vertice con un nombre en especifico
function getNumeroVertice(nombre::String, grafo::Grafo)
    a = grafo.numeroVertices
    for i = 1:a
        if nombre == grafo.vertices[i].nombre
            return i
        end
    end
    return -1
end


# funcion encargada de modificar la matriz de adyacencia para representar el grafo
function enlazarVertices(nombre1::String, nombre2::String, peso::Int64, grafo::Grafo)
    n1 = getNumeroVertice(nombre1, grafo)
    n2 = getNumeroVertice(nombre2, grafo)
    if n1 == -1 | n2 == -1
        println("<--------ERROR--------->")
        return nothing
    end

    grafo.matrizAD[n1, n2] = peso

    grafo.matrizAD[n2, n1] = peso
end

# funcion que imprime la matriz de adyacencia
function printMatrizAD(grafo::Grafo)
    for i = 1:grafo.numeroVertices
        for j = 1:grafo.numeroVertices
            print(grafo.matrizAD[i, j], " ")
        end
        println()
    end
end

# Funcion que verifica si un vertice es adyacente a otro
function esAdyacente(va::Int64, vb::Int64, grafo::Grafo)
    if va < 0 | vb < 0
        println("<--------ERROR--------->")
        return nothing
    end


    return grafo.matrizAD[va, vb] >= 1

end

# Funcion que obtiene el peso entre dos vertices
function getPeso(va::Int64, vb::Int64, grafo::Grafo)
    if va < 0 | vb < 0
        println("<--------ERROR--------->")
        return nothing
    end

    return grafo.matrizAD[va, vb]
end

# Funcion que obtien la minima distancia entre todos los vertices
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

# Funcion que imprime el recorrido más corto entre dos vertices
function encontrarRutaMasCorta(inicial::Int64, final::Int64, listaPadres::Array{Int64,1})
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

# Funcion que calcula todas las distncias más cortas respecto a un vertice
function DijkstraAlgorithm(verticeInicial::String, verticeFinal::String, grafo::Grafo)
    totalVertices = grafo.numeroVertices
    # Encontramos el numero del vertice inicial y final
    vi = getNumeroVertice(verticeInicial, grafo)
    vf = getNumeroVertice(verticeFinal, grafo)

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

            if esAdyacente(u, j, grafo) && !procesados[j] && (distancia[u] != typemax(Int64))  && (distancia[u] + getPeso(u, j, grafo) < distancia[j])

                distancia[j] = distancia[u] + getPeso(u, j, grafo)

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
    printSolution(distancia, grafo)

end

# Imprime una tabla con las distancias más cortas respecto a un vertice
function printSolution(distancia::Array{Int64,1}, grafo::Grafo)

    println("Vertice\t\tDistancia")
    for i = 1:length(distancia)
        nombre = grafo.vertices[i].nombre
        println(" $nombre \t\t $(distancia[i]) ")
    end

end



# Funcion que permite visualizar un menu
function menu()
    options = ["1. Insertar vertice", "2. Enlazar vertices", "3. Calcular distancia más corta", "4. Generar nuevo grafo",
            "5. Salir"]
    menu = RadioMenu(options, pagesize = 10)
    println("_________________________________")
    choice = request("Elige una opcion:", menu)


    return choice
end

# Funcion que lista los vertices de un grafo
function listarVertices(grafo::Grafo)
    vertices = grafo.vertices
    numVertices = grafo.numeroVertices
    for i = 1:numVertices
        println(verticeString(vertices[i]))
    end
end

# Funcion que crea un ejemplo de un grafo
# Presenta un error cuando se actualizan los pesos ya que al parecer el maximo valor lo considera 54
function grafoEjemplo()
    grafo = crearGrafo(8)
    insertarVertice("1", grafo)
    insertarVertice("2", grafo)
    insertarVertice("3", grafo)
    insertarVertice("4", grafo)
    insertarVertice("5", grafo)
    insertarVertice("6", grafo)
    insertarVertice("7", grafo)
    insertarVertice("8", grafo)


    enlazarVertices("1", "2", 6666::Int64, grafo)
    enlazarVertices("1", "3", 3, grafo)

    enlazarVertices("2", "5", 8, grafo)

    enlazarVertices("3", "4", 12, grafo)
    enlazarVertices("3", "6", 4, grafo)

    enlazarVertices("4", "6", 2, grafo)
    enlazarVertices("4", "8", 15, grafo)

    enlazarVertices("5", "7", 17, grafo)

    enlazarVertices("7", "4", 20, grafo)
    enlazarVertices("7", "8", 9, grafo)

    enlazarVertices("8", "6", 22, grafo)

    return grafo
end


function main()
    println("Bienvenido para salir ingrese 0")
    println("El programa ya cuenta con un ejemplo predeterminado, pero puede generar otro por sí mismo")
    grafo::Grafo = grafoEjemplo()
    while true
        try

            x = menu()


            if x == 1
                print(">Ingrese nombre del nuevo vertice: ")
                nombreVertice = readline()
                insertarVertice(nombreVertice, grafo)
            elseif x == 2
                println("----Lista de vertices disponibles-----")
                listarVertices(grafo)
                print(">Ingrese nombre del vertice origen: ")
                nombreVertice = readline()
                print(">Nombre vertice destino: ")
                nombreVerticeDestino = readline()
                print(">Peso: ")
                peso = parse(Int64, readline())
                enlazarVertices(nombreVertice, nombreVerticeDestino, peso, grafo)
            elseif x == 3
                println("-----Lista de vertices disponibles-----")
                listarVertices(grafo)
                print(">Ingrese nombre del vertice origen: ")
                nombreVertice = readline()
                print(">Nombre vertice destino: ")
                nombreVerticeDestino = readline()
                DijkstraAlgorithm(nombreVertice, nombreVerticeDestino, grafo)
            elseif x == 4
                println("-----Está a punto de generar otro grafo....-----")
                print(">Ingrese numero maximo vertices: ")
                dim = parse(Int64, readline())

                grafo = crearGrafo(dim)
            elseif x == 5
                break
            end
        catch
            println("<--------ERROR--------->")
        end

    end
end



main()



# Falta testear esto
