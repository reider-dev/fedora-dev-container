## Description

Dockerfile to build a Fedora development container with the following utils:

- git - source control
- fish - default shell
- starship - shell prompt
- bat - better cat
- micro - text editor
- fzf - fuzzing find
- ripgrep - better grep

The container is prepared to accept an ssh connection, e.g. by "ssh -t root@localhost -p 22". It also contains older versions of libssl and libcrypt to support a zed editor remote connection ([#issue](https://github.com/zed-industries/zed/issues/15599)).

## Configuration

To config git, set the following environmental variable:

- GIT_AUTHOR_NAME
- GIT_AUTHOR_EMAIL
- GIT_COMMITTER_NAME
- GIT_COMMITTER_EMAIL

and make sure to mount your local .ssh to /root/.ssh if you you want to use git from within the container.

## USAGE

Run the container:
```
docker run --rm -d --name fedora-dev-container \
 -p 22:22 \
 -v ~/.gitconfig:/home/dev/.config/git/config \
 -v ~/.shh:/home/dev/.ssh \
 -u $(id -u):$(id -g) \
 tino376dev/fedora-dev-container
```

Connect with Docker:

```bash
docker exec -it fedora-dev-container /usr/bin/fish
```

Connect with ssh:

```bash
ssh -p 22 -t dev@localhost 
```
