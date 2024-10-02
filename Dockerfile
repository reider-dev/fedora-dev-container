# base image
FROM fedora:latest

# shell config
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# default dir
ARG USER=dev
ARG HOME=/home/$USER

# add user and give sudo rights
RUN adduser -p $USER $USER \
    && usermod -aG wheel $USER \
    && passwd -d $USER \
    && echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers.d/$USER \
    && echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USER

# install packages
RUN dnf -y install git openssh-server python3-pip \
    && dnf clean all

# configure ssh
RUN mkdir /var/run/sshd \
    && ssh-keygen -A \
    && echo "AuthenticationMethods none" >> /etc/ssh/sshd_config.d/$USER.conf \
    && echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config.d/$USER.conf

# add missing files (hack to make ssh work with zed editor)
ADD zed/* /usr/lib64/

# configure environment
USER $USER
RUN git clone --bare https://github.com/tino376dev/dotfiles.git $HOME/.dotfiles \
    && git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout \
    && chmod +x $HOME/dev-setup/fedora-setup.sh \
    && $HOME/dev-setup/fedora-setup.sh \
    && chsh -s /usr/bin/fish

# configure entry
ADD --chown=$USER:$USER --chmod=0755 start.sh $HOME
WORKDIR $HOME/work
ENTRYPOINT ["../start.sh"]
EXPOSE 22
