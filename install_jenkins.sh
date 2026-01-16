#!/bin/bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "===== USER DATA START ====="

# -------------------------------------------------
# Wait for network (critical on Ubuntu 24.04)
# -------------------------------------------------
until ping -c1 archive.ubuntu.com >/dev/null 2>&1; do
  sleep 3
done

# -------------------------------------------------
# Base system packages
# -------------------------------------------------
apt-get update -y
apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  apt-transport-https \
  unzip

# -------------------------------------------------
# Install Java 17 (Jenkins requirement)
# -------------------------------------------------
apt-get install -y openjdk-17-jdk

JAVA_HOME_PATH="/usr/lib/jvm/java-17-openjdk-amd64"

cat <<EOF >/etc/profile.d/java.sh
export JAVA_HOME=${JAVA_HOME_PATH}
export PATH=\$JAVA_HOME/bin:\$PATH
EOF

chmod +x /etc/profile.d/java.sh
export JAVA_HOME=${JAVA_HOME_PATH}
export PATH=$JAVA_HOME/bin:$PATH

java -version

# -------------------------------------------------
# Install Docker (official repo, stable)
# -------------------------------------------------
mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update -y
apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

systemctl enable docker
systemctl start docker

docker --version

# -------------------------------------------------
# Jenkins repository (correct 2023 key)
# -------------------------------------------------
mkdir -p /usr/share/keyrings

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
  | gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] \
https://pkg.jenkins.io/debian-stable binary/" \
> /etc/apt/sources.list.d/jenkins.list

apt-get update -y
apt-get install -y jenkins

# -------------------------------------------------
# Permissions (CRITICAL for CI)
# -------------------------------------------------
usermod -aG docker jenkins
usermod -aG docker ubuntu

chown -R jenkins:jenkins /var/lib/jenkins
chown -R jenkins:jenkins /var/cache/jenkins
chown -R jenkins:jenkins /var/log/jenkins

# -------------------------------------------------
# Enable & start Jenkins
# -------------------------------------------------
systemctl daemon-reload
systemctl enable jenkins
systemctl restart jenkins

# -------------------------------------------------
# Validation
# -------------------------------------------------
sleep 10
systemctl --no-pager status jenkins
docker ps

echo "===== USER DATA COMPLETE ====="