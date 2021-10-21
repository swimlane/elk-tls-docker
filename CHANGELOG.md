# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] - 2021-10-21

    - Added KIBANA_URL to .env variables for public base URL type
    - Fixed issue with LetsEncrypt certificates being placed in the correct location
    - Adding support for 7.15.0

## [1.2.0] - 2021-07-14

    - Updated the docker-compose.production.yml to fix some bugs

## [1.1.0] - 2021-05-13
    
    - Added metricbeat and Elastic Agent containers
    - Modified generation of certificates
    - Modified most containers to adhere to more secure communications via certificates
    - Modified documentation

## [1.0.0] - 2020-11-23

    - Initial release of elk-tls-docker project
    - Added WiKi documentation
