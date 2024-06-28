# core

trying to run bactopia here

## Links

- [Bactopia docs](https://bactopia.github.io/)
- [Hutch computing docs](https://sciwiki.fredhutch.org/scicomputing/compute_jobs/)

## Victor's scattered notes

To run on the Hutch cluster, I'm going off this existing config for another cluster: [arcc.config](https://github.com/bactopia/bactopia/blob/master/conf/profiles/arcc.config)

Commands:

```sh
# First ensure Singularity is available:
module load Singularity/3.5.3

# Run using our test accessions
bactopia --accessions test_accessions.txt --nfconfig hutch_compute_config.nf
```

---

The [test profile](https://github.com/bactopia/bactopia/blob/master/conf/profiles/test.config) isn't working. Error message:

> Cannot invoke method toBytes() on null object

Seems like [`task.memory`](https://www.nextflow.io/docs/latest/process.html#process-memory) is unset.

Singularity isn't working. Error message:

> Could not run command: cat GCF_007624845\/GCF_007624845\.proteins\.tmp\.97\.faa | parallel --gnu --plain -j 4 --block 151523 --recstart '>' --pipe blastp -query - -db GCF_007624845/proteins -evalue 1e-09 -qcov_hsp_perc 80 -num_threads 1 -num_descriptions 1 -num_alignments 1 -seg no > GCF_007624845\/GCF_007624845\.proteins\.tmp\.97\.blast 2> /dev/null

Seems to be something with the temp dir: https://github.com/bactopia/bactopia/issues/423

Here's the full error output: [singularity-error-output.txt](./singularity-error-output.txt)
