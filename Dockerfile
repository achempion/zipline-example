FROM python:3.5

WORKDIR /srv/
RUN apt-get -y update \
    && apt-get -y install libfreetype6-dev libpng-dev libopenblas-dev liblapack-dev gfortran \
    && curl -L https://downloads.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz | tar xvz

WORKDIR /srv/ta-lib
RUN pip install 'numpy>=1.11.1,<2.0.0' \
  && pip install 'scipy>=0.17.1,<1.0.0' \
  && pip install 'pandas>=0.18.1,<1.0.0' \
  && ./configure --prefix=/usr \
  && make \
  && make install \
  && pip install TA-Lib \
  && pip install matplotlib

WORKDIR /srv/app
ADD ./requirements.txt /srv/app/requirements.txt
RUN pip install -r requirements.txt
RUN zipline ingest

ADD ./ /srv/app
