Team and repository tags
========================

[![Team and repository tags](https://governance.openstack.org/tc/badges/puppet-cloudkitty.svg)](https://governance.openstack.org/tc/reference/tags/index.html)

<!-- Change things from this point on -->

cloudkitty
==========

#### Table of Contents

1. [Overview - What is the cloudkitty module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with cloudkitty](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Release Notes - Release notes for the project](#release-notes)
8. [Contributors - Those with commits](#contributors)
9. [Repository - The project source code repository](#repository)

Overview
--------

The cloudkitty module is a part of [OpenStack](https://opendev.org/openstack), an effort by the OpenStack infrastructure team to provide continuous integration testing and code review for OpenStack and OpenStack community projects not part of the core software.  The module its self is used to flexibly configure and manage the Rating-as-a-Service for OpenStack.

Module Description
------------------

The cloudkitty module is a thorough attempt to make Puppet capable of managing the entirety of cloudkitty.  This includes manifests to provision region specific endpoint and database connections.  Types are shipped as part of the cloudkitty module to assist in manipulation of configuration files.

Setup
-----

**What the cloudkitty module affects**

* [Cloudkitty](https://docs.openstack.org/cloudkitty/latest/), the Rating-as-a-Service for OpenStack.

### Installing cloudkitty

    cloudkitty is not currently in Puppet Forge, but is anticipated to be added soon.  Once that happens, you'll be able to install cloudkitty with:
    puppet module install openstack/cloudkitty

### Beginning with cloudkitty

To utilize the cloudkitty module's functionality you will need to declare multiple resources.

Implementation
--------------

### cloudkitty

cloudkitty is a combination of Puppet manifest and ruby code to delivery configuration and extra functionality through types and providers.

Limitations
-----------

* All the cloudkitty types use the CLI tools and so need to be ran on the cloudkitty node.

Development
-----------

Developer documentation for the entire puppet-openstack project.

* https://docs.openstack.org/puppet-openstack-guide/latest/

Release Notes
-------------

* https://docs.openstack.org/releasenotes/puppet-cloudkitty

Contributors
------------

* https://github.com/openstack/puppet-cloudkitty/graphs/contributors

Repository
----------

* https://opendev.org/openstack/puppet-cloudkitty


