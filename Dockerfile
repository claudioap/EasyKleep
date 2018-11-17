# Use a clean Arch Linux base install as the parent of this image 
# This is good for development, but might not fit production
FROM archlinux/base

LABEL maintainer="Cláudio Pereira <development@claudiop.com>"

# Install required system packages.
# base-devel:  Required to compile uwsgi (TODO: Remove after compilation)
# python:      Django intrepreter
# python-pip:  Python package manager
# sqlite:      Read vulnerability database
# gdal:        Geographical extensions
RUN pacman -Sy base-devel python python-pip sqlite gdal --noconfirm --noprogressbar

# Install pip packages
COPY pip-packages /usr/src/
RUN pip install --trusted-host pypi.python.org -r /usr/src/pip-packages
RUN rm /usr/src/pip-packages

# Tag /kleep for export
VOLUME  /kleep
# Change directory into it
WORKDIR /kleep
# Expose the uwsgi port
EXPOSE 1893

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Execute uwsgi daemon once this container runs
#ENTRYPOINT ["uwsgi", "/kleep/uwsgi.ini"]
