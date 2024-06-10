# vibrio cholerae 

## description
Visualize global cholera phylogeny using [Nextstrain](https://docs.nextstrain.org/en/latest/).  

## data
 Masked full-sequence alignment and associated metadata from ~1200 representative _Vibrio cholerae_ strains [(Weill et al, 2019)](https://www.nature.com/articles/s41586-018-0818-3#data-availability) 

```
 nextstrain build --aws-batch --aws-batch-cpus 10 --aws-batch-memory 50000 . --jobs 1 -p auspice/cholera.json
```

### View [build](https://nextstrain.org/groups/blab/cholera/weill)



