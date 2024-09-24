using Agents, Agents.Pathfinding
using CairoMakie

@agent struct Ghost(GridAgent{2})
    type::String = "Ghost"
end

matrix = [
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0;
    0 1 0 1 0 0 0 1 1 1 0 1 0 1 0 1 0;
    0 1 1 1 0 1 0 0 0 0 0 1 0 1 1 1 0;
    0 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 0;
    0 1 0 1 0 1 0 0 0 0 0 1 1 1 0 1 0;
    0 1 1 1 0 1 0 1 1 1 0 1 0 1 0 1 0;
    0 1 0 1 0 1 0 1 1 1 0 1 0 1 0 1 0;
    0 1 0 1 1 1 0 0 1 0 0 1 0 1 1 1 0;
    0 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 0;
    0 1 1 1 0 1 0 0 0 0 0 1 0 1 1 1 0;
    0 1 0 1 0 1 0 1 1 1 0 0 0 1 0 1 0;
    0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
]

#function agent_step!(agent, model)
#    possibleMoves = nearby_positions(agent, model, 1)
#    
#    validMoves = [(x, y) for (x, y) in possibleMoves if matrix[x, y] == 1]
#    
#    if !isempty(validMoves)
#        new_position = rand(validMoves)  
#        move_agent!(agent, new_position, model) 
#    end
#end

global pathfinder


function agent_step!(agent, model)
    println("Antes de moverse: $(agent.pos)")
    move_along_route!(agent, model, pathfinder)
    println("Después de moverse: $(agent.pos)")
end


function initialize_model()
    dims = size(matrix)
    target = (2, 2)

    if matrix[target[1], target[2]] != 1
        println("El objetivo no es accesible")
    end

    bitmatrix = BitMatrix(matrix .== 1)
    space = GridSpace(dims; periodic = false, metric = :manhattan)
    global pathfinder = AStar(space, walkmap = bitmatrix, diagonal_movement = false)

    model = StandardABM(Ghost, space; agent_step!)
    add_agent!(Ghost, pos = (8, 6), model) #8 , 6 originally

    if matrix[8, 6] == 1
        route = plan_route!(model[1], target, pathfinder)
        println("Ruta planeada para el agente: $route")
    else
        println("La posición inicial no es accesible")
    end

    return model
end

model = initialize_model()
