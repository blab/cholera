/*
Bactopia configuration for Hutch compute cluster
*/

params {
    /* Pick a partition from:
     * <https://sciwiki.fredhutch.org/compdemos/gizmo_partition_index/>
     */
    slurm_queue = 'campus-new'
    slurm_opts = ''
    slurm_use_scratch = false

    /* TODO: consider using a temp dir
     * <https://sciwiki.fredhutch.org/scicomputing/store_temp/>
     */
    // singularity_cache = '/hpc/temp/bedford_t/…'
}

process {
  executor = 'slurm'
  queue = "${params.slurm_queue}"
  scratch = params.slurm_use_scratch
  // Doesn't work with 3.1.0 https://github.com/bactopia/bactopia/issues/558
  // time = (params.max_time).m
  clusterOptions = "${params.slurm_opts}"
}
