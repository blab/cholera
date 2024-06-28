/*
Bactopia configuration for Hutch compute

Note that I've hardcoded my personal info - modify as necessary
*/

params {
    config_profile_name = 'Hutch'
    config_profile_description = 'Hutch compute'
    config_profile_contact = 'Victor Lin'

    slurm_queue = 'campus-new'
    slurm_opts = '--mail-user=vlin@fredhutch.org'
    singularity_pull_docker_container = true
    singularity_cache = '/home/vlin/.singularity/cache/'
    slurm_use_scratch = false
}

process {
  executor = 'slurm'
  queue = "${params.slurm_queue}"
  scratch = params.slurm_use_scratch
  time = (params.max_time).m
  clusterOptions = "${params.slurm_opts}"
}

singularity {
    enabled = true
    autoMounts = true
    cacheDir = "${params.singularity_cache}"
}
