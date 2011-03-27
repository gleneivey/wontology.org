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

# find the exact name and version of the wontomedia gem we're using, whether bundler/rvm/whatever
$:.detect {|dir| dir =~ %r%^(.*wontomedia-[^/]+)/% }
local_wontomedia_path = $1
local_wontomedia_path =~ %r%([^/]*wontomedia-[^/]+)%
wontomedia_name_with_version = $1

load File.join( local_wontomedia_path, 'config', 'deploy_wontomedia.rb' )
load File.join( local_wontomedia_path, 'config', 'deploy_on_a2hosting.rb' )


# Keep bundle in per-release directory tree because it contains the
# wontomedia gem and we have to modify the gem directory's content
# to customize the app.  Overhead of re-installing other gems on each
# deploy is wasteful, but a necessary side effect.
p release_path
p current_path
set :bundle_dir, File.join( release_path || current_path, 'bundle')
remote_wontomedia_path = File.join( bundle_dir, 'ruby', '1.8', 'gems', wontomedia_name_with_version )
require 'bundler/capistrano'

role :app, 'wontology.org'
role :web, 'wontology.org', :deploy => false
role :db,  'wontology.org', :primary => true

set :app_to_run, remote_wontomedia_path
set :app_to_customize, remote_wontomedia_path
set :app_customization, [
      File.join( app_to_customize, 'default-custom' ),
      File.join( release_path,     'customizations' )
  ].join(':')
set :a2_port,            12024
