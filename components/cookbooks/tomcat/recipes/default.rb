#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# setup base directory
%w(run source software build).each do |dir|
  directory "#{node['global']['base']}/#{dir}" do
    mode 0775
    action :create
    recursive true
  end
end

# tomcat download
remote_file "#{node['global']['base']}/source/apache-tomcat-#{node['tomcat']['version']}.tar.gz" do
  source "http'//apache'.osuosl.org/tomcat/tomcat-6/v#{node['tomcat']['version']}/bin/apache-tomcat-#{node['tomcat']['version']}.tar.gz"
  action :create_if_missing
end

# tomcat extract
bash 'extract' do
  cwd "#{node['global']['base']}/software"
  code <<-EOH
  tar -zxf ../source/apache-tomcat-#{node['tomcat']['version']}.tar.gz
  EOH
end

# create custom CATALINA_BASE directory
%w(bin conf logs webapps work temp).each do |dir|
  directory "#{node['global']['base']}/run/#{dir}" do
    mode 0775
    action :create
    recursive true
  end
end

# generate configs in CATALINA_BASE from templates
# IGNORE Food Critic reports an issue of a missing template regardless of its presence
template "#{node['global']['base']}/run/bin/setenv.sh" do # ~FC033
  source 'setenv.sh.erb'
  mode '0644'
end

# IGNORE Food Critic reports an issue of a missing template regardless of its presence
template "#{node['global']['base']}/run/conf/server.xml" do # ~FC033
  source 'server.xml.erb'
  mode '0644'
end

file "#{node['global']['base']}/bom.Organization" do
  mode '0755'
  content node[global.organization]
  action :create
end

file "#{node['global']['base']}/bom.Assembly" do
  mode '0755'
  content node[global.assembly]
  action :create
end
