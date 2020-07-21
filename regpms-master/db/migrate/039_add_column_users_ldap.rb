class AddColumnUsersLdap < ActiveRecord::Migration
  def change
    add_column :users, :ldap_dn, :string
    add_column :users, :ldap_base, :string
  end
end
