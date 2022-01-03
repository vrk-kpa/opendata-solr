FROM solr:8.11.1

# switch from solr to root user
USER root

# upgrade system
RUN apt-get update -yq && apt-get upgrade -yq

# setup env vars
ENV SOLR_CORE ckan
ENV SOLR_VERSION 6.6.6

# create folders
RUN mkdir -p /opt/solr/server/solr/$SOLR_CORE/conf
RUN mkdir -p /opt/solr/server/solr/$SOLR_CORE/data

# add config files
COPY solrconfig.xml /opt/solr/server/solr/$SOLR_CORE/conf/
COPY schema.xml /opt/solr/server/solr/$SOLR_CORE/conf/
ADD https://raw.githubusercontent.com/apache/lucene-solr/releases/lucene-solr/$SOLR_VERSION/solr/server/solr/configsets/basic_configs/conf/currency.xml \
    https://raw.githubusercontent.com/apache/lucene-solr/releases/lucene-solr/$SOLR_VERSION/solr/server/solr/configsets/basic_configs/conf/synonyms.txt \
    https://raw.githubusercontent.com/apache/lucene-solr/releases/lucene-solr/$SOLR_VERSION/solr/server/solr/configsets/basic_configs/conf/stopwords.txt \
    https://raw.githubusercontent.com/apache/lucene-solr/releases/lucene-solr/$SOLR_VERSION/solr/server/solr/configsets/basic_configs/conf/protwords.txt \
    https://raw.githubusercontent.com/apache/lucene-solr/releases/lucene-solr/$SOLR_VERSION/solr/server/solr/configsets/data_driven_schema_configs/conf/elevate.xml \
    /opt/solr/server/solr/$SOLR_CORE/conf/

# create core.properties
RUN echo name=$SOLR_CORE > /opt/solr/server/solr/$SOLR_CORE/core.properties

# setup permissions
RUN chown -R "$SOLR_USER:$SOLR_USER" /opt/solr/server/solr/$SOLR_CORE

# switch from root to solr user
USER $SOLR_USER:$SOLR_USER
