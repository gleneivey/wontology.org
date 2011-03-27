# WontoMedia - a wontology web application
# Copyright (C) 2011 - Glen E. Ivey
#    www.wontology.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License version
# 3 as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program in the file COPYING and/or LICENSE.  If not,
# see <http://www.gnu.org/licenses/>.


  #### NOTE: this deployment configuration is intended to deploy an
  ####   instance of WontoMedia customized with the assets from:
  ####    * WontoMedia's 'default-custom' directory, overlayed with
  ####    * this repo's 'customizations' directory
  ####   It deploys to the generic-wontology site wontology.org and
  ####   can be used as example of deploying a web site with
  ####   WontoMedia installed as a gem.  For an example of WontoMedia
  ####   being incorporated into a site as a git submodule, see:
  ####   https://github.com/gleneivey/fred.wontology.org


set :application, "wontology.org"
set :repository,  "git://github.com/gleneivey/wontology.org.git"

require 'bundler/capistrano'


# find exactly the gem we're using, whether bundler/rvm/whatever
$:.detect {|dir| dir =~ %r%(^.*wontomedia-[^/]+)/%}
wontomedia = $1

load File.join( wontomedia, 'config', 'deploy_wontomedia.rb' )
load File.join( wontomedia, 'config', 'deploy_on_a2hosting.rb' )

role :app, 'wontology.org'
role :web, 'wontology.org', :deploy => false
role :db,  'wontology.org', :primary => true

set :app_to_run, wontomedia
set :app_to_customize, wontomedia
set :app_customization, [
      File.join( app_to_customize, 'default-custom' ),
      File.join( release_path,     'customizations' )
  ].join(':')
set :a2_port,            12024
