## user_saml_integration test helper

This is a convenience tooling targeted to help faster local testing and debugging of integration tests of the user_saml app.

### Let's go

1. In `docker-compose.yml` change the local path on where you have your user_saml checkout located.
1. Run `docker compose up -d`
1. Watch the behat output of `docker logs -f nextcloud`

#### Next iteration

The containers `ldap` and `sso` are treated as stateless services. They may continue to run. The `nextcloud` container actually only executes `behat` and exits. So that means:

1. Do your coding
1. Run `docker compose up -d`
1. Watch the behat output of `docker logs -f nextcloud`
1. Go to 1 until your are satisfied

#### Okay, now I am done

1. `docker compose down`

### A few more details?

The service containers `ldap` and `sso` are exactly those that are being used in the user_saml integration tests. Nothing fancy about them.

But for the nextcloud server part, we use a container that is defined here by the `Dockerfile`. It is based on Ubuntu, has PHP with some modules and composer installed, as well as sqlite and git. Otherwise it does pretty much what the integration tests does:
- it clones the master branch of the server (just the head)
- sets up the 3rdparty submodule
- does a basic installation
- adds a config file to set the loglevel for `user_saml` to `debug`
- and finally has the entrypoint script (`run-test.sh`) that runs when the container is started

The entrypoint is quite lean to. Like on the integration tests, it starts the PHP webserver with a handful of threads. user_saml is being force-enabled, production dependencies are installed, plus the deps for the integration tests.

Then there is one additional thing you should be aware of: The URLs to the `sso` service are replaced from `localhost:4443` to `sso:8443` as all containers run in an internal network, and the old URLs would not work. After the tests are run, the changes are being reverted again.

Well, and obviously it runs the integration tests.

It's a little clumsy to monitor them via `docker logs -f nextcloud` but it does it's job.

### Now I wanna run a specfic test, not all scenarios over and over and over again

Sure! Did the same.

In `run-tests.sh`  change `./vendor/bin/behat --colors` to the desired test, for example `./vendor/bin/behat --colors features/Shibboleth.feature:126`.

Then, rebuild the container via `docker buildx build -t user_saml_integration-nextcloud:latest .` and simply re-run the tests as if you did a code change.

### Btw, the names you chose suck.

[Yeah, well](https://martinfowler.com/bliki/TwoHardThings.html).
