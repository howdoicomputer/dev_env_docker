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
RUN wget --no-check-certificate https://raw.githubusercontent.com/howdoicomputer/dotfiles/4fa36534f0d8508415165f3a6a4354c351f06466/zshrc -O $HOME/.zshrc
RUN git clone https://github.com/zsh-users/antigen.git $HOME/.antigen
RUN /usr/bin/zsh $HOME/.zshrc
RUN chsh dev -s /usr/bin/zsh

# Install VIM and all my delicious plugins
#
# # #
RUN mkdir -p $HOME/.vim/.tmp
RUN wget --no-check-certificate https://raw.githubusercontent.com/howdoicomputer/dotfiles/0716e8755fbfb364959336a817c52a357dd924b0/vimrc -O $HOME/.vimrc
RUN git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
RUN yes | vim +PluginInstall +qall

RUN chown -R dev: /home/dev
USER dev
CMD zsh
