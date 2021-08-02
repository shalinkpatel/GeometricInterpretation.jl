using GeometricInterpretation
using Documenter

DocMeta.setdocmeta!(GeometricInterpretation, :DocTestSetup, :(using GeometricInterpretation); recursive=true)

makedocs(;
    modules=[GeometricInterpretation],
    authors="Shalin Patel <shalin.kp.patel@gmail.com> and contributors",
    repo="https://github.com/shalinkpatel/GeometricInterpretation.jl/blob/{commit}{path}#{line}",
    sitename="GeometricInterpretation.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://shalinkpatel.github.io/GeometricInterpretation.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/shalinkpatel/GeometricInterpretation.jl",
    devbranch = "main"
)
