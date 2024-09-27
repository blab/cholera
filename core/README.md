# core

trying to run bactopia here (version 3.1.0)

## Commands

```sh
# First ensure Singularity is available:
module load Singularity/3.5.3

# Run using our test accessions
bactopia --accessions test-accessions.txt --nfconfig hutch_compute_config.nf --outdir out/test-accessions -profile singularity

# Summarize results
bactopia summary --bactopia-path out/test-accessions

# Continue with Bactopia Tools
# <https://bactopia.github.io/latest/tutorial/#bactopia-tools>
```

## Links

- [Bactopia docs](https://bactopia.github.io/)
- [Hutch computing docs](https://sciwiki.fredhutch.org/scicomputing/compute_jobs/)

## Victor's scattered notes

To run on the Hutch cluster, I initially thought to go off this existing config for another cluster: [arcc.config](https://github.com/bactopia/bactopia/blob/master/conf/profiles/arcc.config)

But it turns out all that's necessary is to use the slurm profile and specify a "queue" ("partition" in Hutch computing docs): `-profile slurm --queue campus-new`.

---

### Test profile

The [test profile](https://github.com/bactopia/bactopia/blob/master/conf/profiles/test.config) isn't working on SLURM jobs. Error message:

> Cannot invoke method toBytes() on null object

Seems like [`task.memory`](https://www.nextflow.io/docs/latest/process.html#process-memory) is unset.

### Transient prokka error


```
[skipped  ] process > BACTOPIA:DATASETS                                   [100%] 1 of 1, stored: 1 ✔
[b6/8bcc8e] process > BACTOPIA:GATHER:GATHER_MODULE (GCF_001857405)       [100%] 4 of 4 ✔
[df/7c83a7] process > BACTOPIA:GATHER:CSVTK_CONCAT (meta)                 [100%] 1 of 1 ✔
[ef/850a2f] process > BACTOPIA:QC:QC_MODULE (GCF_001857405)               [100%] 4 of 4 ✔
[96/ca4c99] process > BACTOPIA:ASSEMBLER:ASSEMBLER_MODULE (GCF_001857405) [100%] 4 of 4 ✔
[-        ] process > BACTOPIA:ASSEMBLER:CSVTK_CONCAT                     -
[73/4480c2] process > BACTOPIA:SKETCHER:SKETCHER_MODULE (GCF_007624845)   [ 25%] 1 of 4
[76/b56ed3] process > BACTOPIA:ANNOTATOR:PROKKA_MODULE (GCF_007624775)    [ 60%] 6 of 10, failed: 6, retries: 6
[-        ] process > BACTOPIA:AMRFINDERPLUS:AMRFINDERPLUS_RUN            -
[-        ] process > BACTOPIA:AMRFINDERPLUS:GENES_CONCAT                 -
[-        ] process > BACTOPIA:AMRFINDERPLUS:PROTEINS_CONCAT              -
[62/f5f915] process > BACTOPIA:MLST:MLST_MODULE (GCF_007624775)           [ 75%] 3 of 4
[-        ] process > BACTOPIA:MLST:CSVTK_CONCAT                          -
[-        ] process > BACTOPIA:DUMPSOFTWAREVERSIONS                       -
[a8/3cb7bb] NOTE: Process `BACTOPIA:ANNOTATOR:PROKKA_MODULE (GCF_007624775)` terminated with an error exit status (2) -- Execution is retried (2)
...
Could not run command: makeblastdb -dbtype prot -in proteins\.faa -out GCF_025505115\/proteins -logfile /dev/null
```

I initially thought this was due to adding `--outdir` but I just tried again and it worked fine:

```
[skipped  ] process > BACTOPIA:DATASETS                                               [100%] 1 of 1, stored: 1 ✔
[7f/ff1d48] process > BACTOPIA:GATHER:GATHER_MODULE (GCF_007624775)                   [100%] 4 of 4 ✔
[ab/187f86] process > BACTOPIA:GATHER:CSVTK_CONCAT (meta)                             [100%] 1 of 1 ✔
[14/1cf54e] process > BACTOPIA:QC:QC_MODULE (GCF_007624775)                           [100%] 4 of 4 ✔
executor >  slurm (36)
[skipped  ] process > BACTOPIA:DATASETS                                               [100%] 1 of 1, stored: 1 ✔
[7f/ff1d48] process > BACTOPIA:GATHER:GATHER_MODULE (GCF_007624775)                   [100%] 4 of 4 ✔
[ab/187f86] process > BACTOPIA:GATHER:CSVTK_CONCAT (meta)                             [100%] 1 of 1 ✔
[14/1cf54e] process > BACTOPIA:QC:QC_MODULE (GCF_007624775)                           [100%] 4 of 4 ✔
[d0/92f387] process > BACTOPIA:ASSEMBLER:ASSEMBLER_MODULE (GCF_007624775)             [100%] 4 of 4 ✔
[4e/89f1bc] process > BACTOPIA:ASSEMBLER:CSVTK_CONCAT (assembly-scan)                 [100%] 1 of 1 ✔
[9b/6efa22] process > BACTOPIA:SKETCHER:SKETCHER_MODULE (GCF_007624775)               [100%] 4 of 4 ✔
[bc/a469b3] process > BACTOPIA:ANNOTATOR:PROKKA_MODULE (GCF_007624775)                [100%] 6 of 6, failed: 2, retries: 2 ✔
[6e/97cf19] process > BACTOPIA:AMRFINDERPLUS:AMRFINDERPLUS_RUN (GCF_007624775)        [100%] 4 of 4 ✔
[52/1746a2] process > BACTOPIA:AMRFINDERPLUS:GENES_CONCAT (amrfinderplus-genes)       [100%] 1 of 1 ✔
[74/701b7d] process > BACTOPIA:AMRFINDERPLUS:PROTEINS_CONCAT (amrfinderplus-proteins) [100%] 1 of 1 ✔
[4e/81aec9] process > BACTOPIA:MLST:MLST_MODULE (GCF_007624775)                       [100%] 4 of 4 ✔
[80/8fe292] process > BACTOPIA:MLST:CSVTK_CONCAT (mlst)                               [100%] 1 of 1 ✔
[39/cbe857] process > BACTOPIA:DUMPSOFTWAREVERSIONS (1)                               [100%] 1 of 1 ✔
```
