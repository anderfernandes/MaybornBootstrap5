# MaybornBootstrap5

A Mura CMS 7.1 theme that uses Bootstrap 5 and connects to Astral server side.

## Setup

1. Clone the repo and build the [Astral](https://github.com/anderfernandes/astral/tree/master) container image.

2. Pull the [murasoftware/muracms:7.1](https://hub.docker.com/r/murasoftware/muracms/tags) container image.

3. Pull the [mcr.microsoft.com/mssql/server:2017-latest](https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-2017&tabs=cli&pivots=cs1-bash). It will serve as the database for Mura.

4. Run `docker compose up`.

The compose file contains the enrivonmnet variables necessary to connect the services.
