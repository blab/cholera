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
}

process {
  executor = 'slurm'
  queue = "${params.slurm_queue}"
  scratch = params.slurm_use_scratch
  time = (params.max_time).m
  clusterOptions = "${params.slurm_opts}"
}
