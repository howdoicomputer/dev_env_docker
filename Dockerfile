FROM ubuntu:14.10
MAINTAINER Tyler Hampton

WORKDIR /home/dev
ENV HOME /home/dev
ENV SHELL /usr/bin/zsh
ENV PROFILE $HOME/.zshrc

# This container has assumed that you've copied your SSH keys to the source directory
#
# Unfortunately, boot2docker doesn't have support for ssh agent forwarding so I can't use my hosts ssh to access cool stuff
ADD ssh $HOME/.ssh

RUN apt-get update && \
  apt-get install -y \
  git \
  irssi \
  subversion \
  ssh-client \
  curl \
  zsh \
  unzip \
  vim \
  wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup home environment
RUN useradd dev

# Setup zsh and add-ons
#
# # #
RUN curl -L http://install.ohmyz.sh | bash
ADD zshrc $HOME/.zshrc
RUN git clone https://github.com/zsh-users/antigen.git $HOME/.antigen
RUN /usr/bin/zsh $HOME/.zshrc
RUN chsh dev -s /usr/bin/zsh

# Install VIM and all my delicious plugins
#
# # #
RUN mkdir -p $HOME/.vim/.tmp
ADD vimrc $HOME/.vimrc
RUN git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
RUN yes | vim +PluginInstall +qall

# Setup git templates
#
# # #
RUN mkdir -p $HOME/.git_template/hooks
ADD commit-msg $HOME/.git_template/hooks/commit_msg
RUN git config --global init.templatedir $HOME/.git_template

RUN chown -R dev: $HOME
USER dev
CMD zsh
