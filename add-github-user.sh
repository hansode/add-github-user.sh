#!/bin/bash
#
# requires:
#  bash
#  tr, egrep
#  getent, groupadd, useradd
#  su, mkdir, curl
#
set -e
set -o pipefail
set -x
 
if [[ -z "${1}" ]]; then
  echo "$0 <USER-NAME>" >&2
  exit 1
fi
 
declare devel_user=$(tr A-Z a-z <<< ${1})
declare devel_group=${devel_user}
declare devel_home=/home/${devel_user}
 
##
 
getent group  ${devel_group} >/dev/null || groupadd ${devel_group}
getent passwd ${devel_user}  >/dev/null || useradd -g ${devel_group} -d ${devel_home} -s /bin/bash -m ${devel_user}
 
##
 
if [[ -f /etc/sudoers ]]; then
  if ! egrep ^${devel_user} /etc/sudoers -q; then
    echo "${devel_user} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
  fi
fi
 
##
 
su - ${devel_group} -c "${SHELL} -ex" <<EOS
  if ! egrep -w "^umask 022" -q ${devel_home}/.bashrc; then
    echo "umask 022" >> ${devel_home}/.bashrc
  fi
EOS

su - ${devel_group} -c "${SHELL} -ex" <<EOS
  mkdir -p -m 700 ${devel_home}/.ssh
  curl -fsSkL https://github.com/${devel_user}.keys -o ${devel_home}/.ssh/authorized_keys
EOS
