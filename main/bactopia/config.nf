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

executor{
  queueSize=25
}

process {
  executor = 'slurm'
  queue = "${params.slurm_queue}"
  scratch = params.slurm_use_scratch
  time = (params.max_time).m
  clusterOptions = "${params.slurm_opts}"
  min_time = 15000

withLabel : process_medium {
    cpus   = {check_max('request'           , RESOURCES.MAX_CPUS  , 'cpus'   )}
    memory = {check_max(36.GB * task.attempt, RESOURCES.MAX_MEMORY, 'memory' )}
    time   = (params.max_time).m


}

 }
