abstract type GeometricInterpretor end

struct GNNInterpretation{Interpretor <: GeometricInterpretor}
    model :: Chain
    fg :: FeaturedGraph
    X :: Matrix{Real}
    y :: Array{Int}
    interpretor :: Interpretor
end

struct GNNInterpretationResults
    edge_mask :: FeaturedGraph
    node_feat_mask :: Union{Matrix{Real}, Nothing}
end

function explain_node(method :: GNNInterpretation{GeometricInterpretor}, 
    node :: Int) :: GNNInterpretationResults end

function visualize_explanation(edge_mask :: FeaturedGraph)
    swg = graph(edge_mask)
    graphplot(swg |> SimpleDiGraph, arrow_shift = 0.75, arrow_size=20, edge_width=2.5, edge_color=:darkgray, node_color=[3, 5, 3]) # add weights, node colors, node labels
end