# Use a clean Arch Linux base install as the parent of this image 
# This is good for development, but might not fit production
FROM archlinux/base

LABEL maintainer="Cláudio Pereira <development@claudiop.com>"

# Install required system packages.
# gcc:         GCC (required to compile uwsgi)
# python:      Django intrepreter
# python-pip:  Python package manager
# sqlite:      Read vulnerability database
# gdal:        Geographical extensions
# git:         Server version determination
# After finished, 
RUN pacman -Sy gcc python python-pip sqlite gdal git --noconfirm --noprogressbar --cachedir /tmp

# Install pip packages
COPY pip-packages /usr/src/
RUN pip install --no-cache-dir --trusted-host pypi.python.org -r /usr/src/pip-packages  && rm /usr/src/pip-packages

# Uninstall compiler & dependencies. Cleanup cleanup cache, doc's, man entries and unused locales.
RUN pacman -Rns gcc --noconfirm --noprogressbar && \
    rm -r /tmp /usr/share/doc /usr/share/man && \
    rm -r $(ls -1 /usr/share/locale | grep -v -e '\(en\|pt\)' | sed -e 's/^/\/usr\/share\/locale\//')

# Tag /kleep for export
VOLUME  /kleep
# Change directory into it
WORKDIR /kleep
# Expose the uwsgi port
EXPOSE 1893

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Execute uwsgi daemon once this container runs
ENTRYPOINT ["uwsgi", "configurations/uwsgi/kleep.ini"]
