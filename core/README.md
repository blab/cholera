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

# Run the Bactopia test command using the slurm config
bactopia -profile test --nfconfig test_config.nf
# current error: Cannot invoke method toBytes() on null object

# Run using our test accessions
bactopia --accessions test_accessions.txt --nfconfig test_config.nf
# It looks like this may be working but it's slow? will try again tomorrow
# - victor 6/27

```
