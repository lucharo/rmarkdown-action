#Container image that runs your code (tidyverse installed)
FROM rocker/tidyverse:4.2.2

#Copy files inside r_files folder + install other R packages
COPY ./r_files ./r_files
RUN R -e "install.packages(c('DT'))"

#alternative
# RUN Rscript ./r_files/requirements.R

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["r_files/entrypoint.sh"]
