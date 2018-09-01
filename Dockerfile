FROM sinonkt/docker-slurmbase

LABEL maintainer="oatkrittin@gmail.com"

ENV ROOT_RPMS=/root/rpmbuild/RPMS/x86_64 \
    EASYBUILD_PREFIX=/home/modules \
    MODULES_DIR=${EASYBUILD_PREFIX} \
    MODULEPATH=${MODULES_DIR}/modules/all:$MODULEPATH

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
  chown slurm: /var/log/slurm/slurmctld.log
ADD etc/supervisord.d/slurmctld.ini /etc/supervisord.d/slurmctld.ini

# Switch to user `modules` to install EasyBuild
USER modules
WORKDIR /home/modules

# Install EasyBuild, Simulate source profile when we ssh
RUN source /etc/profile.d/z00_lmod.sh && \
    wget https://raw.githubusercontent.com/easybuilders/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py && \
    python bootstrap_eb.py $EASYBUILD_PREFIX && \
    rm -f bootstrap_eb.py

# Switch to root before run script
USER root

ADD scripts/start.sh /root/start.sh
RUN chmod +x /root/start.sh

EXPOSE 22 6817

CMD ["/bin/bash","/root/start.sh"]