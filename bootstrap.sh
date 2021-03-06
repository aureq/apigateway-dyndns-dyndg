#!/bin/sh -xe

# keep in sync with .travis.yml
bootstrap_deb () {
  apt-get update

  # virtualenv binary can be found in different packages depending on
  # distro version
  virtualenv_bin_pkg="virtualenv"
  if ! apt-cache show -qq "${virtualenv_bin_pkg}" >/dev/null 2>&1; then
    virtualenv_bin_pkg="python-virtualenv"
  fi

  apt-get install -y --no-install-recommends \
    ca-certificates \
    gcc \
    libssl-dev \
    libffi-dev \
    python \
    python-dev \
    "${virtualenv_bin_pkg}"
}

bootstrap_rpm () {
  installer=$(command -v dnf || command -v yum)
  "${installer?}" install -y \
    ca-certificates \
    gcc \
    libffi-devel \
    openssl-devel \
    python36-virtualenv \
    python36-pip
}

if [ -f /etc/os-release ]
then
  . /etc/os-release
  case "$ID" in
    "amzn")
      bootstrap_rpm
      exit
    ;;
  esac
fi

echo "You should run Amazon Linux for code Lambda functions"
