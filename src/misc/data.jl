function nz_stream_foodweb()
  data_path = joinpath(@__DIR__, "../..", "data", "nz_stream")
  files = readdir(data_path)
  documents = filter(f -> endswith(f, ".csv"), files)
  Ns = UnipartiteNetwork{String}[]
  for doc in documents
    content = readdlm(joinpath(@__DIR__, "../..", "data", "nz_stream", doc), ',')
    species_names = convert(Array{String}, content[:,1][2:end])
    interaction_matrix = map(Int64, content[2:end,2:end]).>0
    push!(Ns, UnipartiteNetwork(interaction_matrix', species_names))
  end
  return Ns
end

function web_of_life(name)
  file_pathname = name * ".csv"
  data_path = joinpath(@__DIR__, "../..", "data", "weboflife")
  files = readdir(data_path)
  @assert file_pathname in files
  content = readdlm(joinpath(@__DIR__, "../..", "data", "weboflife", file_pathname), ',')
  bottom_species_names = convert(Array{String}, vec(content[:,1][2:end]))
  top_species_names = convert(Array{String}, vec(content[1,:][2:end]))
  int_mat = content[2:end,2:end]
  repl = findall(int_mat .== "#")
  int_mat[repl] .= 0.0
  interaction_matrix = map(Int64, round.(permutedims(int_mat)))
  ntype = BipartiteQuantitativeNetwork
  if maximum(interaction_matrix) == 1
    interaction_matrix = interaction_matrix .> 0
    ntype = BipartiteNetwork
  end
  this_net = ntype(interaction_matrix, top_species_names, bottom_species_names)
  forbidden_names = ["Numbers of flowers", "Num. of hosts sampled", "#", "Frequency of occurrences", "Number of flowers", "Number of droppings analysed"]
  sp_1 = filter(x -> !(x ∈ forbidden_names), species(this_net; dims=1))
  sp_2 = filter(x -> !(x ∈ forbidden_names), species(this_net; dims=2))
  return this_net[sp_1, sp_2]
end

function web_of_life()
  wol_ref = joinpath(@__DIR__, "../..", "data", "weboflife", "references.csv")
  wol_infos = readdlm(wol_ref, ',')
  names = Symbol.(replace.(wol_infos[1,:], " " => "_"))
  infos = [NamedTuple{tuple(names...)}(tuple(wol_infos[i,:]...)) for i in 2:size(wol_infos,1)]
  return infos
end
