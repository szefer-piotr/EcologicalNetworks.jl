"""
    cascademodel(spec::Int64, Co::Float64)

Return matrix of the type `UnipartiteNetwork` randomly assembled according to
the cascade model for a given nuber of `spec` and connectivity `Co`.

> Cohen, J. E. and Newman, C. M. (1985) ‘A stochastic theory of community
> food webs I. Models and aggregated data’, Proc. R. Soc. Lond. B, 224(1237),
> pp. 421–448. doi: 10.1098/rspb.1985.0042.

# Examples
```jldoctest
julia> A = cascademodel(50, 0.35)
```
See also: `nichemodel`, `mpnmodel`, `nestedhierarchymodel`

"""
function cascademodel(spec::Int64, Co::Float64)

    # Evaluate input
    maxconnectance = ((spec^2-spec)/2)/(spec*spec)
    Co >= maxconnectance && throw(ArgumentError("Connectance for $(spec) species cannot be larger than $(maxconnectance) "))
    Co <= 0 && throw(ArgumentError("Connectance C must be positive"))
    spec <= 0 && throw(ArgumentError("Number of species L must be positive"))

    # Initiate matrix
    A = UnipartiteNetwork(zeros(Bool, (spec, spec)))

    # For each species randomly asscribe rank e
    e = sort(rand(spec), rev=false)

    # Probability for linking two species
    p = 2*Co*spec/(spec - 1)

    for consumer in  1:spec

        # Rank for a consumer
        rank = e[consumer]

        # Get a set of resources smaller than consumer
        potentialresources = findall(x -> x > rank, e)  # indices
        #resourcesranks = η[potentialresources]         # ranks
        #R = length(potentialresources)                 # length

        # Each gets a link with a probability p
        for resource in potentialresources

            # Take the resources and for each of them check a random number
            # if it is smaller than probability of linking two speceis create
            # a link in the A matrix

            # Random number for a potential resource
            rand() < p && (A[consumer, resource] = true)

        end

    end

    return A

end

"""
    cascademodel(N::T) where {T <: UnipartiteNetwork}

Applied to a `UnipartiteNetwork` return its randomized version.

# Examples
```jldoctest
julia> empirical_foodweb = EcologicalNetworks.nz_stream_foodweb()[1]
julia> A = cascademodel(empirical_foodweb)
```
"""
function cascademodel(N::T) where {T <: UnipartiteNetwork}

    return cascademodel(richness(N), connectance(N))

end

"""
    cascademodel(spec::Int64, L::Int64)

Number of links can be specified instead if connectance.

# Examples
```jldoctest
julia> A = cascademodel(45, 543)
```
"""
function cascademodel(spec::Int64, L::Int64)

    Co = (L/(spec*spec))

    return cascademodel(spec, Co)

end

"""

    cascademodel(parameters::Tuple)

Parameters tuple can also be provided in the form (spec::Int64, Co::Float64)
or (spec::Int64, Int::Int64).

"""
function cascademodel(parameters::Tuple)
    return cascademodel(parameters[1], parameters[2])
end
