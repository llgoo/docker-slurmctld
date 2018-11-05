FROM sinonkt/docker-slurmbase

LABEL maintainer="oatkrittin@gmail.com"

# Install slurm, slurmctld, slurm-perlapi
RUN rpm -ivh ${ROOT_RPMS}/slurm-${SLURM_VERSION}.el7.x86_64.rpm \
  ${ROOT_RPMS}/slurm-slurmctld-${SLURM_VERSION}.el7.x86_64.rpm \
  ${ROOT_RPMS}/slurm-perlapi-${SLURM_VERSION}.el7.x86_64.rpm && \
  rm -rf ${ROOT_RPMS}/*

# Fixed ownership and permission of Slurm
RUN mkdir /var/spool/slurmctld /var/log/slurm && \
  chown slurm: /var/spool/slurmctld /var/log/slurm && \
  chmod 755 /var/spool/slurmctld /var/log/slurm && \
  touch /var/log/slurm/slurmctld.log && \
  chown slurm: /var/log/slurm/slurmctld.log && \
  systemctl enable slurmctld

VOLUME [ "/sys/fs/cgroup", "/etc/slurm" ]

EXPOSE 22 6817