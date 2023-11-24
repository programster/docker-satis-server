Docker Satis Server
===================
A project to make it even easier to deploy a PHP Satis server.


## Usage

1. Copy the *.env.example* file to *.env* and fill in the details.
2. Copy the *volumes/config/satis.json.example* to *volumes/config/satis.json* and fill it in with
   details of your private repositories.
3. Copy the *volumes/config/credentials.txt.example* to *volumes/config/credentials.txt* and fill in the
   credentials if your repositories require a username and password (SVN). If not, then just leave
   the contents as-is, but the file must exist.
4. Run `docker-compose build` to build the image.
5. Run `docker-compose up` to start the satis server.


### Enabling SSL/TLS
If you are using a reverse proxy, simply make sure `SSL_ENABLED=false` is left alone in the *.env*
file (default) and you are done. Just make sure your reverse-proxy is passing HTTP requests to
this service instead of HTTPS.

If you want to have SSL/TLS enabled and don't want to make use of a reverse-proxy, then simply
add the following files to the *volumes/ssl* directory:

* site.crt - the site certificate file
* ca.crt - the certificate authority file
* private.pem - the private key file.

You may be more used to Nginx configurations with a file like *fullchain.pem*. That file simply
contains both the site certificate and the certificate authority public certificate. You can
take that file and split it out to create the *site.crt* and *ca.crt* files.

### Git And SSH Auth
If you are wondering how this will be able to securely access your git repositories, the
*docker-compose.yaml* file has been configured to pass-through the SSH agent/socket, so as long
as your server has access, then the docker container will have access. To test this, just try
running a git clone of your repository on your server. You may wish to just run `ssh-keygen`
and add the *$HOME/.ssh/id_rsa.pub* public key to your repositories to grant access.

If you get any errors during the build to do with the SSH auth socket etc, please make sure
the SSH agent is running on your server. You may wish to simply add the following to your
*.bashrc* file:

```bash
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
```

