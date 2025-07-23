Satis Server
============

A project to allow you to easily spin up your own Satis server to act as your own private
[Packagist](https://packagist.org/).


## Getting Started

There are two main ways that you can deploy this through docker. The quickest way to get going is
to use the [pre-built image](https://hub.docker.com/r/programster/satis-server) with:

1. Copy the docker-compose.yml file
2. Copy the .env.example file and rename to .env and fill it in. Set the `DOCKER_IMAGE_NAME` to
   `programster/satis-server` to use the pre-built image.
3. Copy the config directory down and rename the `satis.json.example` file to `satis.json` before then adding your private
   package repositories.
4. rename the svn-credentials.txt.example file to svn-credentials.txt. Only bother editing it if you are using SVN.
5. Add the SSL certificates to the SSL folder if you are not using a proxy.
6. Run `docker-comopse up`

If you do not wish to use the pre-built `programster/satis-server` image, then you can build your
own image (and make customizations if you need), by cloning this repository, setting the
`DOCKER_IMAGE_NAME` to something else like `satis-server` for example, and running:

```bash
docker compose build
```

### System Requirements
To *run* the image, you only need:
* 1 vCPU
* 512 MB RAM

However, if you wish to build the image as well, you may need some more RAM.


## Configuration
### SSL / TLS
If you wish to provide your own SSL/TLS certificates, then place them within the `ssl/` directory
with the following names:

- cert.pem - the site certificate.
- chain.pem - the backing chain certificate. E.g. E6 for Let's Encrypt.
- privkey.pem - your private key.

Don't forget that you need to set SSL_ENABLED to `1` in your *.env* file.


## Git And SSH Auth

If you're wondering how this will be able to securely access your git repositories, the
docker-compose.yaml file has been configured to pass-through the SSH agent/socket, so as long as
your server has access, then the docker container will have access. To test this, just try running
a git clone of your repository on your server. You may wish to just run ssh-keygen and add the
$HOME/.ssh/id_rsa.pub public key to your repositories to grant access.

If you get any errors during the build to do with the SSH auth socket etc, please make sure the SSH
agent is running on your server. You may wish to simply add the following to your .bashrc file:

```bash
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
```
