#
# Cookbook Name:: tomcat
# Recipe:: force_restart

include_recipe 'tomcat::force_stop'
include_recipe 'tomcat::start'
