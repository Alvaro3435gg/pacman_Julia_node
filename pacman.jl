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

function agent_step!(agent, model)
    possibleMoves = nearby_positions(agent, model, 1)
    
    validMoves = [(x, y) for (x, y) in possibleMoves if matrix[x, y] == 1]
    
    if !isempty(validMoves)
        new_position = rand(validMoves)  
        move_agent!(agent, new_position, model) 
    end
end


function agent_step!(agent, model)
    possibleMoves = nearby_positions(agent, model, 1)
    
    validMoves = [(x, y) for (x, y) in possibleMoves if matrix[x, y] == 1]
    
    if !isempty(validMoves)
        new_position = rand(validMoves)  
        move_agent!(agent, new_position, model) 
    end
end


function initialize_model()
    dims = size(matrix)
    target = (1, 1)
    space = GridSpace(dims; periodic = false, metric = :manhattan)
    pathfinder = AStar(space, walkmap = matrix, diagonal_movement=false)
    model = StandardABM(Ghost, space; agent_step!)
    add_agent!(Ghost, pos=(8, 6), model)
    plan_route!(model[1], target, pathfinder)
    return model, pathfinder
end

model = initialize_model()
add_agent!(Ghost, pos=(8, 6), model)