rule index:
    input:
        sequences="data/variants.fasta",
    output:
        results="results/sequence_index.tsv",
    shell:
        """
        augur index --sequences {input.sequences} --output {output.sequences} 
        """

rule filter:
    input:
        sequences="data/variants.fasta",
        metadata="data/metadata.tsv",
	index="results/sequence_index.tsv",
    output:
        sequences="results/filtered_sequences.fasta",
        metadata="results/filtered_metadata.tsv",
        log="results/filter.log"
    params: 
        filters="--exclude-where country=Unknown region=Unknown --exclude-ambiguous-dates-by year
	subsample_seed 12345",
        keep_root="--include-where accession=M66", 
	
    shell:
        """
        augur filter \
            --sequences {input.sequences} \
            --metadata {input.metadata} \
	    --sequence-index {input.index} \ 
            --output-sequences {output.sequences} \
            --output-metadata {output.metadata} \
            {params.filters} \
            {params.keep_root} \
            --output-log {output.log}
        """

rule tree:
    message:
        "Building tree"
    input:
        alignment=rules.filter.output.sequences,
    output:
        tree="results/tree_raw.nwk",
    threads: 4
    shell:
        """
        augur tree \
            --alignment {input.alignment} \
            --nthreads {threads} \
            --output-tree {output.tree}
        """


rule refine:
    message:
        "Refine"
    input:
        tree = "results/tree_raw.nwk",
        alignment="results/filtered_sequences.fasta",
	metadata="results/filtered_metadata.tsv",
    output:
        node_data="results/branch_lengths.json",
	tree="results/tree.nwk", 
    shell:
        """
        augur refine \
            --tree {input.tree} \
            --alignment {input.alignment} \
	    --metadata {input.metadata) \ 
            --output-node-data {output.node_data} \
            --inference {params.inference} \
	    --precision 3 \ 
	    --date-inference marginal \ 
	    --date-confidence \ 
	    --clock-filter-iqd 4 \ 
	    --timetree \
	    --keep-polytomies 
        """


rule ancestral:
    message: "ancestral"
    input:
        tree = "results/tree.nwk",
        alignment = "data/full_sequences.fasta",
    output:
        node_data = "results/nt_muts.json"
    shell:
        """
        augur translate \
            --tree {input.tree} \
            --alignment {input.node_data} \
            --output-node-data {output.node_data} \
        """

rule translate:
    message: "Translating amino acid sequences"
    input:
        tree = "results/tree.nwk",
        node_data = rules.ancestral.output.node_data,
        reference = "data/N16961.gbk",
    output:
        node_data = "results/aa_muts.json"
    shell:
        """
        augur translate \
            --tree {input.tree} \
            --ancestral-sequences {input.node_data} \
            --reference-sequence {input.reference} \
            --output-node-data {output.node_data} \
        """

rule traits:
    message:
        """
        Inferring ancestral traits for {params.columns}
        """
    input:
        tree = "results/tree.nwk",
        metadata="results/filtered_metadata.tsv",
    output:
        node_data="results/traits.json",
    params:
        columns="Country region Serotype Source Wave Transmission_Event subregion",
    shell:
        """
        augur traits \
            --tree {input.tree} \
            --metadata {input.metadata} \
            --output {output.node_data} \
            --columns {params.columns} \
            --confidence 
        """

rule export:
    message:
        "Exporting data files for auspice "
    input:
        tree = "results/tree.nwk",
        branch_lengths = "results/branch_lengths.json",
        nt_muts="results/nt_muts.json",
        traits="results/traits.json",
        lat_longs="config/lat_longs.tsv",
        colors = "config/colors.txt",
    output:
        auspice_json="auspice/cholera.json",
    shell:
        """
        augur export v2 \
            --tree {input.tree} \
            --node-data {input.branch_lengths} {input.nt_muts} {input.traits} \
            --lat-longs {input.lat_longs} \
            --colors {input.colors} \
            --output {output.auspice_json} \
            --geo-resolutions Country subregion \
            --color-by-metadata region \
            --maintainers "nashwa" \
            --title "Vibrio cholerae"
        """
