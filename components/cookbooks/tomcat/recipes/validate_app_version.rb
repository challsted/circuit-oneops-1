#
# Cookbook Name:: tomcat
# Recipe:: version_app_version

include_recipe 'tomcat::version_status'
script = node['versioncheckscript']

bash 'CHECK_APP_VERSION' do
  code <<-EOH
    #{script}
    exit '$RETVAL'
  EOH
end
