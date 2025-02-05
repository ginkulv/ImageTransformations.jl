using CoordinateTransformations, Rotations, TestImages, ImageCore, StaticArrays, OffsetArrays, Interpolations, LinearAlgebra
using Test, ReferenceTests

refambs = detect_ambiguities(CoordinateTransformations, Base, Core)
using ImageTransformations
ambs = detect_ambiguities(ImageTransformations, CoordinateTransformations, Base, Core)
@test isempty(setdiff(ambs, refambs))

function typestring(::Type{T}) where T   # from https://github.com/JuliaImages/ImageCore.jl/pull/133
    buf = IOBuffer()
    show(buf, T)
    String(take!(buf))
end

# helper function to compare NaN
nearlysame(x, y) = x ≈ y || (isnan(x) & isnan(y))
nearlysame(A::AbstractArray, B::AbstractArray) = all(map(nearlysame, A, B))

tests = [
    "autorange.jl",
    "resizing.jl",
    "interpolations.jl",
    "warp.jl",
    "deprecated.jl" # test deprecations in the last
]

@testset "ImageTransformations" begin
for t in tests
    @testset "$t" begin
        include(t)
    end
end
end

nothing
