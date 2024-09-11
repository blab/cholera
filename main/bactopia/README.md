I. Running bactopia on dataset of [Pathogenwatch](https://pathogen.watch/genomes/all) assemblies 
```
bactopia prepare --path data/ --assembly-ext .fasta --species "Vibrio cholerae" --taxid 666 > acc.txt

bactopia --samples acc.txt --cleanup_workdir --outdir results
```

II. Running bactopia tools - [snippy](https://bactopia.github.io/latest/bactopia-tools/snippy/) workflow

```
bactopia --wf snippy --mapqual 60 --basequal 13 --mincov 4 --minfrac .75 --mask mask.bed --mask_char N --include includes.txt --bactopia results --reference union_modified.gbk --max_cpus 36 --nfconfig config.nf
```
