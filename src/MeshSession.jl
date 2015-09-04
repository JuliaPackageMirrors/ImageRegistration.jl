
function montage_section(n)
	@time Ms, images = load_section(PREMONTAGED_OFFSETS, n);
	@time add_all_matches!(Ms, images);
	@time solve_meshset!(Ms);
	save(Ms);
	images = 0;
end

function montage_sections(wafer_num, k::UnitRange{Int64})
	optimize_all_cores(PARAMS_MONTAGE);
	for n in k
	  @time montage_section(n);
	end

end

function align_stack(wafer_num, k::UnitRange{Int64})
	@time Ms = make_stack(PREALIGNED_OFFSETS, wafer_num, k);
	@time for i in 1:Ms.N-1
	  @time a = Ms.meshes[i].index[2];
	  @time b = Ms.meshes[i+1].index[2];
	 @time add_pair_matches!(Ms, a, b); 
	end
	solve_meshset!(Ms);
	save(Ms);
end

function align_to_fixed(wafer_num, aligned, prealigned)
	@time Ms = make_stack(PREALIGNED_OFFSETS, wafer_num, aligned, prealigned);
	@time for i in 1:Ms.N-1
	  @time a = Ms.meshes[i].index[2];
	  @time b = Ms.meshes[i+1].index[2];
	 @time add_pair_matches!(Ms, a, b); 
	end
	solve_meshset!(Ms);
	save(Ms);
end
