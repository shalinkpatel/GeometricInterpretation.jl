using GeometricFlux
using Flux
using Flux: onehotbatch, onecold, logitcrossentropy, throttle
using Flux: @epochs
using JLD2
using Statistics
using SparseArrays
using LightGraphs.SimpleGraphs
using LightGraphs: adjacency_matrix
using Random
using DataFrames
using Gadfly

@load joinpath(pkgdir(GeometricFlux), "data/cora_features.jld2") features
@load joinpath(pkgdir(GeometricFlux), "data/cora_labels.jld2") labels
@load joinpath(pkgdir(GeometricFlux), "data/cora_graph.jld2") g

num_nodes = 2708
num_features = 1433
hidden₀ = 1024
hidden₁ = 256
target_cat = 7
epochs = 25

## Preprocessing data
train_X = Matrix{Float32}(features)
train_y = Matrix{Float32}(labels)
adj_mat = Matrix{Float32}(adjacency_matrix(g))
fg = FeaturedGraph(adj_mat)

## Model
model = Chain(GCNConv(fg, num_features => hidden₀, leakyrelu),
              Dropout(0.5),
              GCNConv(fg, hidden₀ => hidden₁, leakyrelu),
              Dropout(0.5),
              Dense(hidden₁, target_cat)
        )

## Loss
loss(x, y) = logitcrossentropy(model(x), y)
accuracy(x, y) = mean(onecold(softmax(model(x))) .== onecold(y))

## Training
ps = Flux.params(model)
train_data = [(train_X, train_y)]
opt = ADAM(0.01)
acc = Float32[]
function evalcb()
    accₜ = accuracy(train_X, train_y)
    push!(acc, accₜ)
    @show accₜ
end

@epochs epochs Flux.train!(loss, ps, train_data, opt, cb=throttle(evalcb, 10))

df = DataFrame(epoch=collect(1:epochs), acc=acc)
plot(df, x=:epoch, y=:acc, Geom.line)