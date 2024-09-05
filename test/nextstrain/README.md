
I. Post-processing bactopia output 
```
gunzip -c bactopia/results/core-snp.filtered_polymorphic_sites.fasta.gz > variants.fasta

gunzip -c bactopia/results/core-snp-clean.full.aln.gz > sequences.fasta 

nextstrain/scripts/convert_branch_lengths.sh bactopia/data/core-snp.final_tree.tre 4033501 nextstrain/data/tree_raw.nwk
```

II. Running Nextstrain tools via Snakemake 
```
 nextstrain build --aws-batch --aws-batch-cpus 10 --aws-batch-memory 50000 . --jobs 1 -p auspice/cholera.json
```


