# Core functions

This page presents the core functions to manipulate networks. Whenever possible,
the approach of `EcologicalNetwork` is to overload functions from `Base`.

## Accessing species

```@docs
species(N::AbstractUnipartiteNetwork)
species(N::AbstractBipartiteNetwork)
```

```@docs
species(N::AbstractBipartiteNetwork, i::Int64)
species(N::AbstractUnipartiteNetwork, i::Int64)
```

## Accessing interactions

### Presence of an interaction

```@docs
has_interaction{NT<:AllowedSpeciesTypes}(N::AbstractEcologicalNetwork, i::NT, j::NT)
has_interaction(N::AbstractEcologicalNetwork, i::Int64, j::Int64)
```

### Value of an interaction

```@docs
getindex{T<:AllowedSpeciesTypes}(N::AbstractEcologicalNetwork, s1::T, s2::T)
getindex(N::AbstractEcologicalNetwork, i...)
```

### Neighbors

```@docs
getindex{T<:AllowedSpeciesTypes}(N::AbstractEcologicalNetwork, ::Colon, sp::T)
getindex{T<:AllowedSpeciesTypes}(N::AbstractEcologicalNetwork, sp::T, ::Colon)
```

### Induced sub-graph

```@docs
getindex{T<:AllowedSpeciesTypes}(N::AbstractUnipartiteNetwork, sp::Array{T})
getindex{T<:AllowedSpeciesTypes}(N::AbstractBipartiteNetwork, ::Colon, sp::Array{T})
getindex{T<:AllowedSpeciesTypes}(N::AbstractBipartiteNetwork, sp::Array{T}, ::Colon)
getindex{T<:AllowedSpeciesTypes}(N::AbstractBipartiteNetwork, sp1::Array{T}, sp2::Array{T})
```

## Network utilities

### Network size

```@docs
size(N::AbstractEcologicalNetwork)
```

### Species richness

```@docs
richness(N::AbstractEcologicalNetwork)
richness(N::AbstractEcologicalNetwork, i::Int64)
```

### Changing network shape

```@docs
transpose(N::AbstractEcologicalNetwork)
nodiagonal(N::AbstractUnipartiteNetwork)
nodiagonal(N::AbstractBipartiteNetwork)
```