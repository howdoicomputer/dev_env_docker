# docker-devenv
A base setup for establishing disposable dev environment.

### Introduction

This is a burgeoning project to try and get disposable containers up and going for my projects.

The Dockerfile in this project will pull down my dotfiles and setup a dev user. It's an abstract container that is meant to be a base for other projects to inherit from.

### Notes

This does copy your ```~.ssh``` directory into the container so that you can use git and such.
